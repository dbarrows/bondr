#' rates
#' 
#' @param x object containing reaction rates
#' 
#' @return [`vector`] of reaction rates
#' @export
rates <- function(x) {
    UseMethod("rates")
}
