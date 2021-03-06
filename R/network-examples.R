#' Example networks
#' 
#' @param name one of: `'mm'` (default, Michaelis Menten), `'shlogl'`, `'gbk'` (Goldbeter-Koshland Switch), or `'pc'` (Potassium Channel)
#'
#' @return Reaction [`network`]
#' @export
network_examples <- function(name = NULL) {
    network_string_examples(name) %>% network()
}

#' Example network strings
#' 
#' For use in [parse_network()].
#' 
#' @param name one of: `'mm'` (default, Michaelis Menten), `'shlogl'`, `'gbk'` (Goldbeter-Koshland Switch), or `'pc'` (Potassium Channel)
#'
#' @return Reaction network string
#' @export
network_string_examples <- function(name = NULL) {
    if (is.null(name)) return(mm_string)
    switch(name,
        'mm' = mm_string,
        'schlogl' = schlogl_string,
        'gbk' = gbk_string,
        'pc' = pc_string
    )
}

mm_string <-
'
S + E <-> SE,    1.66e-3, 1e-4
   SE  -> E + P, 1e-1
'

schlogl_string <-
'
2X <-> 3X, 3e-2, 1e-4
 0 <-> X,  2e2,  3.5
'

gbk_string <-
'
S + E1 <-> C1,     5e-2, 1e-1
    C1  -> E1 + P, 1e-1
P + E2 <-> C2,     1e-2, 1e-1
    C2  -> E2,     1e-1
'

pc_string <-
'
C1 <-> C2, 1e-1, 1e-1
C2 <-> C3, 1e-1, 1e-1
C3 <-> O,  1e-1, 1e-1
 O <-> I,  1e-1, 1e-1
 I <-> C3, 1e-1, 1e-1
'
