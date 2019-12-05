#' \code{chemnet} package
#'
#' Chemical Reaction Networks
#'
#' @docType package
#' @name chemnet
#' @importFrom magrittr %>%
#' @importFrom stringr str_extract str_replace str_length
#' @importFrom crayon blurred blue silver make_style strip_style %+%
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
