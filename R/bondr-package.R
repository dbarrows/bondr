#' [`bondr`] package
#'
#' Chemical reaction networks
#'
#' @docType package
#' @name bondr
#' 
#' @importFrom magrittr %>%
#' @importFrom stringr str_extract str_replace str_length str_c str_sub str_detect
#' @importFrom crayon blurred blue silver make_style strip_style %+%
#' @importFrom Rcpp sourceCpp
#' @importFrom digest digest
#' @importFrom fs dir_create file_temp file_copy path file_exists path_dir
#' @importFrom readr read_file
#' @importFrom clisymbols symbol
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
