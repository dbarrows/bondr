#' Generates the update functions to use for the reaction network
#' 
#' @param network a reaction network object created using [`parse_network`]
#' 
#' @return [`list`] of update functions
#' @export
updates <- function(network) {
    network$reactions %>% lapply(update_function, species(network))
}

update_snippet <- function(reaction, all_species, cpp = FALSE) {
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
        if (!cpp)
            x <- c(x, delta)
        else if (cpp && delta != 0) {
            index <- ifelse(cpp, 0, 1) + match(s, all_species) - 1
            x <- c(x, paste0("x[", index, "] += ", delta))
        }
    }
    ifelse(cpp,
           paste(x, collapse = "; ") %+% ";",
           paste0("x + c(", paste(x, collapse = ", "), ")"))
}

update_function <- function(reaction, all_species) {
    up_string <- update_snippet(reaction, all_species)
    text <- paste0("function(x) {\n",
                   "    ", up_string, "\n",
                   "}")
    eval(parse(text = text))
}
