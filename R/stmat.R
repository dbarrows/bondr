#' Stoichiometric matrix
#' 
#' Columns correspond to reactions, rows to species.
#' 
#' @param network a reaction network object created using [`network`]
#' 
#' @return Stoichiometric [`matrix`]
#' @export
stmat <- function(network) {
    zero_vec <- numeric(length(species(network)))
    mat <- updates(network) %>%
        lapply(function(up) up(zero_vec)) %>%
        do.call(c, .) %>%
        matrix(nrow = length(species(network)))
    rownames(mat) <- species(network)
    colnames(mat) <- str_c('R', 1:ncol(mat))
    mat
}
