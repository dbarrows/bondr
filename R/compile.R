#' Compiles a reaction network to a C++ object.
#' 
#' The compiled network is exposed via an \code{Xptr} and can be used in cpp code via the Rcpp package.
#' Make sure to link to this package using the \code{LinkingTo} field in the DESCRIPTION file of a
#' package, or with \code{Rcpp::depends} in C++ code.
#' 
#' @param network a reaction network object created using \code{parse_network}
#' @param force if set to \code{TRUE}, forces the overwriting and recompilation of the network source file
#' 
#' @return \code{Xptr} to a compiled network object
#' @export
compile_network <- function(network, force = FALSE) {
    netfile <- network_file(network, force)
    sourceCpp(netfile$path, cacheDir = path_dir(netfile$path), rebuild = force)
    netfile$constructor()
}
