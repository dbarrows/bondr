#' Creates a reaction object from a string
#' 
#' If the reaction string contains a bidirectional reaction, the returned
#' list will contain both reaction objects.
#'
#' @param string string containing the chemical reaction representation
#'
#' @return [`list`] of reaction objects
#' @export
parse_reaction <- function(string) {
    csv <- split_trim(string, ",")
    bidirectional <- grepl("<->", string, fixed = TRUE)
    dir_sym <- ifelse(bidirectional, "<->", "->")
    
    reaction_sym <- csv[1]
    rate <- as.numeric(csv[2])

    species_syms <- split_trim(reaction_sym, dir_sym)

    species_list <- function(specieslist_string)
        specieslist_string %>% split_trim("+") %>% lapply(parse_species) %>% .[!sapply(., is.null)]

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
                rate = as.numeric(csv[3])
            ),
            class = "reaction")
        ))

    reactions
}

specieslist_string <- function(s_list) {
    string <- s_list %>% sapply(as.character) %>% paste(collapse = " + ")
    ifelse(string == "", "0", string)
}

order <- function(reaction) {
    orders <- reaction$reactants %>% lapply(function(species) species$order)
    ifelse(length(orders) == 0, 0, sum(unlist(orders)))
}

#' @export
as.character.reaction <- function(x, ...) {
    reactants_string <- specieslist_string(x$reactants)
    products_string <- specieslist_string(x$products)

    reactants_string %+% " " %+% silver(left_arrow) %+% " " %+% products_string %+% silver(", rate: ") %+% blue(x$rate)
}

#' @export
print.reaction <- function(x, ...) {
    cat(paste0(as.character(x), "\n"))
}

#' @export
species.reaction <- function(x) {
    species_names <- function(species_list)
        species_list %>% sapply(function(species) species$name) %>% as.character()

    c(species_names(x$reactants), species_names(x$products)) %>% unique()
}