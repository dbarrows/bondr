#' Generates a derivative function compatible with solvers in the \code{deSolve} package
#' 
#' @param network a reaction network object created using \code{parse_network}
#' 
#' @return a function with the signature \code{function(t, y, parms, ...)}
#' @export
deriv_function <- function(network) {
    n_species <- length(species(network))
    stoi_mat <- updates(network) %>% sapply(function(up) up(numeric(n_species)))
    props <- propensities(network)

    function(t, y, parms,...) {
        prod <- stoi_mat %*% (props %>% sapply(function(prop) prop(y)))
        list(prod)
    }
}
