#' Parses a string containing a representation of a unidirectional
#' or bidirectional chemical reaction
#' 
#' If the reaction string contains a bidirectional reaction, the returned
#' list will contain both reaction objects.
#'
#' @param string string containing the chemical reaction representation
#'
#' @return list of reaction objects
#' @export
parse_reaction <- function(string) {
    csv <- split_trim(string, ",")
    bidirectional <- grepl("<->", string, fixed = TRUE)
    dir_sym <- ifelse(bidirectional, "<->", "->")
    
    reaction_sym <- csv[1]
    rate <- csv[2]

    species_syms <- split_trim(reaction_sym, dir_sym)

    species_list <- function(specieslist_string)
        specieslist_string %>% split_trim("+") %>% lapply(parse_species) %>% .[!is.na(.)]

    reactants <- species_list(species_syms[1])
    products <- species_list(species_syms[2])
    
    reactions <- list(structure(list(
            reactants = reactants,
            products = products,
            rate = rate
        ),
        class = "reaction"
    ))
    if (bidirectional)
        reactions <- append(reactions,
            list(structure(list(
                reactants = products,
                products = reactants,
                rate = csv[3]
            ),
            class = "reaction")
        ))

    reactions
}

#' @export
toString.reaction <- function(x, ...) {
    specieslist_string <- function(s_list)
        s_list %>% lapply(toString)
    reactants_string <- specieslist_string(x$reactants)
    products_string <- specieslist_string(x$products)
    paste0(reactants_string, " -> ", products_string, ", rate: ", x$rate)
}

#' @export
print.reaction <- function(x, ...) {
    cat(paste0(toString(x), "\n"))
}

#' @export
species.reaction <- function(x) {
    species_names <- function(species_list) {
        if (length(species_list) == 0) ## ifelse fails here, leave as is
            return(character())
        species_list %>% sapply(function(species) species$name)
    }

    c(species_names(x$reactants), species_names(x$products)) %>% unique()
}
