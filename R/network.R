#' Creates a reaction network object from a string
#'
#' @param string string containing the chemical network representation
#'
#' @return Reaction network [`list`] object
#' @export
parse_network <- function(string) {
    reactions <- string %>% split_trim("\n") %>% lapply(parse_reaction) %>% unlist(recursive = FALSE)
    
    structure(list(
            reactions = reactions
        ),
        class = "network"
    )
}
#' @rdname parse_network
#' @export
network <- parse_network

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
    rate_width <- x$reactions %>% sapply(function(reaction) str_length(as.character(reaction$rate))) %>% max(4)

    desc <- blurred(str_c("# Reaction network: ",
                          length(x$reactions), " reaction", ifelse(1 < length(x$reactions), "s", ""),
                          " x ",
                          length(species(x)), " species")) %+% "\n"
    header <- blue(sprintf(paste0("%", reactants_width + width + 2, "s"), "Reactants") %+%
                   "    " %+%
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
                sprintf(paste0("%", rate_width, "s"), reaction$rate)
        }) %>%
        paste(collapse = "\n")

    out <- desc %+%
        header %+%
        string %+%
        "\n"    
    cat(out)
}
