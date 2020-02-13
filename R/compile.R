#' Compiles a reaction network to a C++ object.
#' 
#' The compiled network is exposed via an \code{Xptr} and can be used in cpp code via the Rcpp package.
#' Make sure to link to this package using the \code{LinkingTo} field in the DESCRIPTION file of a
#' package, or with \code{Rcpp::depends} in C++ code.
#' 
#' @param network a reaction network object created using \code{parse_network}
#' @param rateless if \code{TRUE} (default \code{FALSE}), generates propensities without using rate constants
#' @param force if \code{TRUE} (default \code{FALSE}), forces the overwriting and recompilation of the network source file
#' @param display_path if \code{TRUE} (default \code{FALSE}), displays the path to the network file
#' 
#' @return \code{Xptr} to a compiled network object
#' @export
compile_network <- function(network, rateless = FALSE, force = FALSE, display_path = FALSE) {
    netfile <- network_file(network, rateless = rateless, force = force)
    if (display_path)
        message(str_c("Network source written to '", netfile$path,"'"))
    sourceCpp(netfile$path, cacheDir = path_dir(netfile$path), rebuild = force)
    netfile$constructor()
}
