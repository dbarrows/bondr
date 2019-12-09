#' Parses a string containing a representation of a chemical network
#'
#' @param string string containing the chemical network representation
#'
#' @return reaction network list object
#' @export
parse_network <- function(string) {
    reactions <- string %>% split_trim("\n") %>% lapply(parse_reaction) %>% unlist(recursive = FALSE)
    
    structure(list(
            reactions = reactions
        ),
        class = "network"
    )
}

#' @export
species.network <- function(x) {
    lapply(x$reactions, species) %>% unlist() %>% unique()
}

#' @export
print.network <- function(x, ...) {
    width <- ceiling((length(x$reactions) + 1) / 10)
    reactants_strings <- x$reactions %>% sapply(function(reaction) specieslist_string(reaction$reactants))
    products_strings <- x$reactions %>% sapply(function(reaction) specieslist_string(reaction$products))

    max_length <- function(cvec)
        cvec %>% sapply(strip_style) %>% sapply(str_length) %>% max()

    reactants_width <- max(max_length(reactants_strings), 10)
    products_width <- max(max_length(products_strings), 10)
    rate_width <- x$reactions %>% sapply(function(reaction) str_length(as.character(reaction$rate))) %>% max()

    desc <- blurred("# Chemical reaction network") %+% "\n"
    header <- blue(sprintf(paste0("%", reactants_width + width + 2, "s"), "Reactants") %+%
                   "   " %+%
                   sprintf(paste0("%", -products_width, "s"), "Products") %+%
                   sprintf(paste0("%", rate_width, "s"), "Rate") %+%
                   "\n")
    string <- sapply(1:length(x$reactions), function(i) {
            reaction <- x$reactions[[i]]
            reactants <- sprintf(paste0("%", reactants_width, "s"), strip_style(specieslist_string(reaction$reactants)))
            products <- sprintf(paste0("%", -products_width, "s"), strip_style(specieslist_string(reaction$products)))
            blurred(formatC(i, width = width)) %+% "  " %+%
                reactants %+% " " %+%
                silver(left_arrow) %+% " " %+%
                products %+%
                formatC(reaction$rate, width = rate_width)
        }) %>%
        paste(collapse = "\n")

    out <- desc %+%
        header %+%
        string %+%
        "\n"    
    cat(out)
}

#' Generates the propensity functions to use for the reaction network.
#' 
#' @param network a reaction network object created using \code{parse_network}
#' 
#' @return a list of propensity functions
#' @export
propensities <- function(network) {
    network$reactions %>% lapply(propensity_function, species(network))
}

#' Generates the update functions to use for the reaction network.
#' 
#' @param network a reaction network object created using \code{parse_network}
#' 
#' @return a list of update functions
#' @export
updates <- function(network) {
    network$reactions %>% lapply(update_function, species(network))
}

#' Generates a derivative function compatible with solvers in the \code{deSolve} package
#' 
#' @param network a reaction network object created using \code{parse_network}
#' 
#' @return a function with the signature \code{function(t, y, parms, ...)}
#' @export
deriv_function <- function(network) {
    n_species <- length(species(network))
    stoi_mat <- updates(network) %>% sapply(function(up) up(numeric(n_species)))
    props <- propensities(network)

    function(t, y, parms,...) {
        prod <- stoi_mat %*% (props %>% sapply(function(prop) prop(y)))
        list(prod)
    }
}
