#' Create a species
#' 
#' Parse a string to create a reaction network object.
#'
#' @param string string containing the chemical species representation
#' 
#' @return Species object
#' @export
parse_species <- function(string) {
    if (string %in% empty_sets) return(NULL)

    parsed_order <- str_extract(string, '^\\d+')
    order <- if (is.na(parsed_order)) 1 else as.numeric(parsed_order)
    name <- if (order == 1) string else str_replace(string, '^\\d+', '')
    
    structure(list(
            name = name,
            order = order
        ),
        class = 'species'
    )
}

#' @export
as.character.species <- function(x, ...) {
    coef <- if (x$order == 1) '' else x$order
    paste0(coef, x$name)
}

#' @export
print.species <- function(x, ...) {
    cat(paste(as.character(x), '\n'))
}

#' species
#' 
#' @param x object containing species
#' 
#' @return [`vector`] of species names
#' @export
species <- function(x) {
    UseMethod('species')
}
