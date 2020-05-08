#' Example network strings
#' 
#' @param name one of: `'mm'` (Michaelis Menten), `'shlogl'`, `'gbk'` (Goldbeter-Koshland Switch), or `'pc'` (Potassium Channel)
#'
#' @return Reaction network string for use in [parse_network()]
#' @export
example_network_strings <- function(name) {
    switch(name,
        "mm" = mm_string,
        "schlogl" = schlogl_string,
        "gbk" = gbk_string,
        "pc" = pc_string
    )
}

mm_string <-
"
S + E <-> SE,    1.66e-3, 1e-4
   SE  -> E + P, 1e-1
"

schlogl_string <-
"
2X <-> 3X, 3e-2, 1e-4
 0 <-> X,  2e2,  3.5
"

gbk_string <-
"
S + E1 <-> C1,     5e-2, 1e-1
    C1  -> E1 + P, 1e-1
P + E2 <-> C2,     1e-2, 1e-1
    C2  -> E2,     1e-1
"

pc_string <-
"
C1 <-> C2, 1e-1, 1e-1
C2 <-> C3, 1e-1, 1e-1
C3 <-> O,  1e-1, 1e-1
 O <-> I,  1e-1, 1e-1
 I <-> C3, 1e-1, 1e-1
"
