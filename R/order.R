#' order
#' 
#' @param x object containing an order
#' 
#' @return [`numeric`] order
#' @export
order <- function(x) {
    UseMethod('order')
}
