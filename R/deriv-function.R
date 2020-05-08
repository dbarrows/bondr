#' Derivative function compatible with [`deSolve`](https://cran.r-project.org/web/packages/deSolve/index.html)
#' 
#' @param network a reaction network object created using [`parse_network`]
#' 
#' @return [`function`] with the signature `function(t, y, parms, ...)`
#' @export
deriv_function <- function(network) {
    n_species <- length(species(network))
    stoi_mat <- updates(network) %>% sapply(function(up) up(numeric(n_species)))
    props <- propensities(network)

    function(t, y, parms,...) {
        stoi_mat %*% (props %>% sapply(function(prop) prop(y))) %>%
            as.vector() %>%
            list()
    }
}
