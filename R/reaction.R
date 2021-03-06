#' Create a reaction
#' 
#' Parse a string to create a reaction network object.
#' 
#' If the reaction string contains a bidirectional reaction, the returned
#' list will contain both reaction objects.
#'
#' @param string string containing the chemical reaction representation
#'
#' @return [`list`] of reaction objects
#' @export
parse_reaction <- function(string) {
    csv <- split_trim(string, ',')
    bidirectional <- grepl('<->', string, fixed = TRUE)
    dir_sym <- if (bidirectional) '<->' else '->'
    
    reaction_sym <- csv[1]
    rate <- as.numeric(csv[2])

    species_syms <- split_trim(reaction_sym, dir_sym)

    species_list <- function(specieslist_string)
        specieslist_string %>% split_trim('+') %>% lapply(parse_species) %>% .[!sapply(., is.null)]

    reactants <- species_list(species_syms[1])
    products <- species_list(species_syms[2])
    
    reactions <- list(structure(list(
            reactants = reactants,
            products = products,
            rate = rate
        ),
        class = 'reaction'
    ))
    if (bidirectional)
        reactions <- append(reactions,
            list(structure(list(
                reactants = products,
                products = reactants,
                rate = as.numeric(csv[3])
            ),
            class = 'reaction')
        ))

    reactions
}

specieslist_string <- function(s_list) {
    string <- s_list %>% sapply(as.character) %>% paste0(collapse = ' + ')
    if (0 < str_length(string)) string else '0'
}

#' @export
as.character.reaction <- function(x, ...) {
    reactants_string <- specieslist_string(x$reactants)
    products_string <- specieslist_string(x$products)

    reactants_string %+% ' ' %+% silver(right_arrow) %+% ' ' %+% products_string %+% silver(', rate: ') %+% blue(x$rate)
}

#' @export
print.reaction <- function(x, ...) {
    cat(paste0(as.character(x), '\n'))
}

#' @export
species.reaction <- function(x) {
    species_names <- function(species_list)
        species_list %>% sapply(function(species) species$name) %>% as.character()

    c(species_names(x$reactants), species_names(x$products)) %>% unique()
}

#' @export
rates.reaction <- function(x) {
    x$rate
}

#' @export
order.reaction <- function(x) {
    # note that `sapply` returns a list if input is empty, so we need to use `vapply`
    x$reactants %>%
        vapply(function(species) species$order, numeric(1)) %>%
        sum()
}