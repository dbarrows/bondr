#' @export
compile_network <- function(network) {
    netfile <- network_file(network)
    sourceCpp(netfile$path)
    netfile$constructor()
}
