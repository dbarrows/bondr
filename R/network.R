#' Parses a string containing a representation of a chemical network
#'
#' @param string string containing the chemical network representation
#'
#' @return reaction network list object
#' @export
parse_network <- function(string) {
    reactions <- string %>% split_trim("\n") %>% lapply(parse_reaction) %>% unlist(recursive = FALSE)

    all_species <- species.network(list(reactions = reactions))
    propensities <- reactions %>% lapply(propensity_function, all_species)
    updates <- reactions %>% lapply(update_function, all_species)
    
    structure(list(
            reactions = reactions,
            propensities = propensities,
            updates = updates
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
