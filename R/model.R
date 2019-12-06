top_template <- '
// [[Rcpp::plugins(cpp17)]]
// [[Rcpp::depends(RcppArmadillo)]]

#include "rnetwork.h"

class NETWORK_NAME : public rnetwork {
public:
    NETWORK_NAME() {
        name = "DISPLAY_NAME";
        species = { SPECIES };
        reactions = {
'

reaction_template <- '
            reaction {
                ORDER,
                [](const arma::vec& x) -> double { return PROPENSITY; },
                [](arma::vec& x) { UPDATES }
            },
'

bottom_template <- '
        };
    };
};

// [[Rcpp::export()]]
rnetwork construct() {
    return NETWORK_NAME();
}
'

file_contents <- function(network, display_name) {
    name <- gsub(" ", "", display_name)

    header <- gsub("NETWORK_NAME", name, top_template)
    header <- gsub("DISPLAY_NAME", display_name, header)
    species <- str_c('"', network$species, '"', collapse = ', ')
    header <- gsub("SPECIES", species, header)

    reactions <- c()
    for (reaction in network$reactions) {
        r <- reaction_template
        r <- gsub("ORDER", length(reaction$reactants), r)
        r <- gsub("PROPENSITY", propensity_cpp(reaction, network$species), r)
        r <- gsub("UPDATES", update_cpp(reaction, network$species), r)
        reactions <- c(reactions, r)
    }

    footer <- gsub("NETWORK_NAME", name, bottom_template)

    trimws(paste0(header, paste0(str_sub(reactions, 2, -2), collapse = "\n"), footer))
}

write_network <- function(network, display_name, path) {
    name <- gsub(" ", "", display_name)
    contents <- file_contents(network, display_name)

    file_path <- fs::path(path, paste0(name, ".gen.r.cpp"))
    
    network_file <- file(file_path)
    writeLines(contents, network_file)
    close(network_file)
    
    file_path
}
