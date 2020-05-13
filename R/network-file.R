network_file <- function(network, rateless = FALSE, force = FALSE) {
    name <- str_c("network_", digest(list(network, rateless)))

    header_snippet <-  gsub("SPECIES",
                            str_c('"', species(network), '"', collapse = ', '),
                            top_template)

    reactions_snippet <- network$reactions %>%
        sapply(function(reaction) {
            reaction_template %>%
                gsub("ORDER", order(reaction), .) %>%
                gsub("PROPENSITY", propensity_snippet(reaction, species(network), rateless = rateless, cpp = TRUE), .) %>%
                gsub("UPDATES", update_snippet(reaction, species(network), cpp = TRUE), .)
        }) %>%
        str_sub(., 2, -2) %>%
        str_c(., collapse = "\n")

    constructor_name <- str_c("construct_", name)
    bottom_snippet <- bottom_template %>% gsub("CONSTRUCTOR_NAME", constructor_name, .)
        
    contents <- str_c(header_snippet, reactions_snippet, bottom_snippet) %>%
        gsub("NETWORK_NAME", name, .) %>%
        trimws() %>%
        str_c(., "\n")

    constructor <- function() {
        eval(parse(text = str_c(constructor_name, "()")))
    }

    temp_dir <- dir_create(path(tempdir(), "networks"))
    file_name <- str_c(name, ".gen.r.cpp")
    file_path <- path(temp_dir, file_name)

    if (!file_exists(file_path) || force) {
        file_copy(path(system.file("include", package = "bondr"), "rnet.h"),
                  path(temp_dir, "rnet.h"),
                  overwrite = TRUE)
        f <- file(file_path)
        writeLines(contents, f)
        close(f)
    }

    structure(list(
            name = name,
            path = file_path,
            constructor = constructor
        ),
        class = "network_file"
    )
}

top_template <- '
// [[Rcpp::depends(RcppArmadillo)]]

#include <rnet.h>

using namespace arma;

class NETWORK_NAME : public bondr::rnet {
public:
    NETWORK_NAME() {
        species = { SPECIES };
        reactions = {
'

reaction_template <- '
            bondr::reaction {
                ORDER,
                [](vec& x) -> double { return PROPENSITY; },
                [](vec& x) { UPDATES }
            },
'

bottom_template <- '
        };
    };
};

// [[Rcpp::export()]]
SEXP CONSTRUCTOR_NAME() {
    return Rcpp::XPtr<bondr::rnet>(new NETWORK_NAME());
}
'