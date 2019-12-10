#' Generates the propensity functions to use for the reaction network.
#' 
#' @param network a reaction network object created using \code{parse_network}
#' 
#' @return a list of propensity functions
#' @export
propensities <- function(network) {
    network$reactions %>% lapply(propensity_function, species(network))
}

propensity_snippet <- function(reaction, all_species, cpp = FALSE) {
    r <- reaction$rate
    x <- sapply(reaction$reactants, function(s) {
            if (s$name %in% empty_sets)
                return("")
            index <- ifelse(cpp, 0, 1) + match(s$name, all_species) - 1
            prod <- paste0("x[", index, "]")
            if (s$order > 1) {
                xi <- prod
                for (i in 1:(s$order-1))
                    prod <- paste0(prod, "*(", xi, "-", i, ")")
                prod <- paste0(prod, "/", factorial(s$order))
            }
            prod
        })
    x_mul <- paste(x, collapse = "*")
    ifelse(str_length(x_mul) == 0, r, paste(c(r, "*", x_mul), collapse = ""))
}

propensity_function <- function(reaction, all_species) {
    prop_string <- propensity_snippet(reaction, all_species)
    text <- paste0("function(x) {\n",
                   "    ", prop_string, "\n",
                   "}")
    eval(parse(text = text))
}
