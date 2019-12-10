#' Generates the stoichiometric matrix for a reaction network
#' 
#' Columns correspond to reactions, and rows to species
#' 
#' @param network a reaction network object created using \code{parse_network}
#' 
#' @return stoichiometric matrix
#' @export
stoichiometric_matrix <- function(network) {
    zero_vec <- numeric(length(species(network)))
    updates(network) %>% sapply(function(up) up(zero_vec))
}
