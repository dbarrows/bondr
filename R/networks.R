#' Michaelis Menten network string
#'
#' @export
mm_string <-
"
S + E <-> SE,    1.66e-3, 1e-4
   SE  -> E + P, 1e-1
"

#' Schlogl network string
#'
#' @export
schlogl_string <-
"
2X <-> 3X, 3e-2, 1e-4
 0 <-> X,  2e2,  3.5
"

#' Golbeter-Koshland Switch network string
#'
#' @export
gbk_string <-
"
S + E1 <-> C1,     5e-2, 1e-1
    C1  -> E1 + P, 1e-1
P + E2 <-> C2,     1e-2, 1e-1
    C2  -> E2,     1e-1
"

#' PotassiumChannel network string
#'
#' @export
pc_string <-
"
C1 <-> C2, 1e-1, 1e-1
C2 <-> C3, 1e-1, 1e-1
C3 <-> O,  1e-1, 1e-1
 O <-> I,  1e-1, 1e-1
 I <-> C3, 1e-1, 1e-1
"
