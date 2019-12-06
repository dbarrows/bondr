update <- function(reaction, all_species, cpp = FALSE) {
    x <- character()
    for (s in all_species) {
        delta <- 0
        for (r in reaction$reactants) {
            if (r$name == s)
                delta <- delta - r$order
        }
        for (p in reaction$products) {
            if (p$name == s)
                delta <- delta + p$order
        }
        if (delta != 0) {
            index <- ifelse(cpp, 0, 1) + match(s, all_species) - 1
            x <- c(x, ifelse(cpp,
                             paste0("v[", index, "] += ", delta),
                             paste0("v[", index, "] <- v[", index, "] + ", delta)))
        }
    }
    terminator <- ifelse(cpp, ";", "\n")
    paste(x, collapse = terminator %+% ifelse(cpp, " ", "")) %+% terminator
}
