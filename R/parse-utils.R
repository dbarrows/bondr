split_trim <- function(s, sep) {
    s %>% trimws() %>% strsplit(sep, fixed = TRUE) %>% sapply(trimws)
}
