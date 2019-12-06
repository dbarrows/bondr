#' Constructs a species object from a string containing a representation
#' of a chemical species
#'
#' @param string string containing the chemical species representation
#'
#' @return species object
#' @export
parse_species <- function(string) {
    if (string %in% empty_sets) return(NA)

    parsed_order <- str_extract(string, "\\d+")
    order <- ifelse(is.na(parsed_order), 1, as.numeric(parsed_order))
    name <- ifelse(order == 1, string, str_replace(string, "\\d+", ""))
    
    structure(list(
            name = name,
            order = order
        ),
        class = "species"
    )
}

#' @export
as.character.species <- function(x, ...) {
    coef <- ifelse(x$order == 1, "", x$order)
    paste0(coef, x$name)
}

#' @export
print.species <- function(x, ...) {
    cat(paste(as.character(x), "\n"))
}

#' species
#' 
#' @param x object containing species
#' @return vector of species names
#' @export
species <- function(x) {
    UseMethod("species")
}
