#' @export
compile_network <- function(network, force = FALSE) {
    netfile <- network_file(network, force)
    sourceCpp(netfile$path, cacheDir = path_dir(netfile$path), rebuild = force)
    netfile$constructor()
}
