#' Parses a string containing a representation of a chemical network
#'
#' @param string string containing the chemical network representation
#'
#' @return reaction network list object
#' @export
parse_network <- function(string) {
    reactions <- string %>% split_trim("\n") %>% lapply(parse_reaction) %>% unlist(recursive = FALSE)
    species <- c()
    for (reaction in reactions)
        species <- c(species,
                     sapply(reaction$reactants, function(sp) sp$name),
                     sapply(reaction$products, function(sp) sp$name))
    
    structure(list(
            reactions = reactions
        ),
        class = "network"
    )
}

#' @export
species.network <- function(x) {
    sapply(x$reactions, species) %>% unlist() %>% unique()
}

#' @export
print.network <- function(x, ...) {
    width <- ceiling(length(x$reactions) / 10)
    reactants_strings <- x$reactions %>% sapply(function(reaction) specieslist_string(reaction$reactants))
    products_strings <- x$reactions %>% sapply(function(reaction) specieslist_string(reaction$products))

    max_length <- function(cvec)
        cvec %>% sapply(strip_style) %>% sapply(str_length) %>% max()

    max_reactants_width <- max_length(reactants_strings)
    max_products_width <- max_length(products_strings)

    string <- sapply(1:length(x$reactions), function(i) {
            reaction <- x$reactions[[i]]
            reactants <- sprintf(paste0("%", max_reactants_width, "s"), strip_style(specieslist_string(reaction$reactants)))
            products <- sprintf(paste0("%", max_products_width, "s"), strip_style(specieslist_string(reaction$products)))
            blurred(formatC(i, width = width)) %+% "  " %+%  reactants %+% silver(left_arrow) %+% products
        }) %>%
        paste(collapse = "\n")
    
    out <- blurred("# A chemical reaction network with reactions:") %+% "\n" %+% string %+% "\n"    
    cat(out)
}
