#' Compiles a reaction network to a C++ object
#' 
#' The compiled network is exposed via an `Xptr` and can be used in cpp code via the [`Rcpp`] package.
#' Make sure to link to this package using the `LinkingTo` field in the `DESCRIPTION` file of a
#' package, or with [`Rcpp::depends`](https://rdrr.io/rforge/Rcpp/man/dependsAttribute.html) in C++ code.
#' 
#' @param network a reaction network object created using [`parse_network`]
#' @param rateless if `TRUE` (default `FALSE`), generates propensities without using rate constants
#' @param force if `TRUE` (default `FALSE`), forces the overwriting and recompilation of the network source file
#' @param display_path if `TRUE` (default `FALSE`), displays the path to the network file
#' 
#' @return `Xptr` to a compiled network object
#' @export
compile_network <- function(network, rateless = FALSE, force = FALSE, display_path = FALSE) {
    netfile <- network_file(network, rateless = rateless, force = force)
    if (display_path)
        message(str_c("Network source written to '", netfile$path,"'"))
    sourceCpp(netfile$path, cacheDir = path_dir(netfile$path), rebuild = force)
    netfile$constructor()
}