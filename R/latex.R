#' LaTeX representation of a network
#' 
#' Exports an `array` (for use in the `equation` environment) or `tabular` for use in the `table` environment. The `tabular` output requires the [`booktabs`](https://ctan.org/pkg/booktabs) LaTeX package to be loaded.
#' 
#' @param network a reaction network object created using [`network`]
#' @param tabular if `TRUE` (default `FALSE`) exports a `tabluar`
#' 
#' @return LaTeX code for `network`
#' @export
latex <- function(network, tabular = FALSE) {
    header <- trim_newlines(if(tabular) table_header else eq_header)
    footer <- trim_newlines(if(tabular) table_footer else eq_footer)
    body <- 1:length(network$reactions) %>%
        sapply(function(i) {
                reaction <- network$reactions[[i]]
                str_c(tabs(if(tabular) 2 else 1),
                      reaction_latex(reaction, i),
                      if (tabular) str_c(r'( & )', reaction$rate) else '')
            }) %>%
            str_c(collapse = str_c(r'( \\)', '\n')) %>%
            { if (tabular) str_c(., r'( \\)') else . }
    str_c(c(header, body, footer), collapse = '\n') %>%
        str_c('\n') %>%
        cat()
}

reaction_latex <- function(reaction, index, tabular = FALSE) {
    str_c(c(species_list_latex(reaction$reactants),
            str_c(r'(\xrightarrow{k_{)', index, r'(}})'),
            species_list_latex(reaction$products)),
          collapse = r'( & )')
}

species_list_latex <- function(species_list) {
    if (length(species_list) == 0) {
        r'(\varnothing)'
    } else {
        species_list %>%
            sapply(species_latex) %>%
            str_c(collapse = ' + ')
    }
}

species_latex <- function(species) {
    str_c(if (1 < species$order) as.numeric(species$order) else '',
          species$name)
}

tabs <- function(n) str_c(rep(' ', 4*n), collapse = '')

trim_newlines <- function(s) {
    s %>%
        str_replace('^\\n', '') %>%
        str_replace('\\n$', '')
}

eq_header <- r'(
\begin{array}{rcl}
)'
eq_footer <- r'(
\end{array}
)'

table_header <- r'(
\begin{tabular}{rcl@{\hskip 1cm}l}
    \toprule
        \multicolumn{3}{l}{Reaction} & Rate \\
    \midrule
)'
table_footer <- r'(
    \bottomrule
\end{tabular}
)'

