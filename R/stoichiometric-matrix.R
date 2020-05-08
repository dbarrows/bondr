#' Stoichiometric matrix for a reaction network
#' 
#' Columns correspond to reactions, rows to species.
#' 
#' @param network a reaction network object created using [`network`]
#' 
#' @return Stoichiometric [`matrix`]
#' @export
stoichiometric_matrix <- function(network) {
    zero_vec <- numeric(length(species(network)))
    updates(network) %>% sapply(function(up) up(zero_vec))
}
