#' Propensity functions
#' 
#' @param network a reaction network object created using [`network`]
#' @param rateless if `TRUE` (default `FALSE`), generates propensities without using rate constants
#' 
#' @return [`list`] of propensity functions
#' @export
propensities <- function(network, rateless = FALSE) {
    network$reactions %>% lapply(propensity_function, species(network), rateless = rateless)
}

propensity_snippet <- function(reaction, all_species, rateless = FALSE, cpp = FALSE) {
    r <- ifelse(rateless, 1, reaction$rate)
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
    x_mul <- paste0(x, collapse = "*")
    ifelse(str_length(x_mul) == 0, r, paste0(c(r, "*", x_mul), collapse = ""))
}

propensity_function <- function(reaction, all_species, rateless = FALSE) {
    prop_string <- propensity_snippet(reaction, all_species, rateless = rateless)
    text <- paste0("function(x) {\n",
                   "    ", prop_string, "\n",
                   "}")
    eval(parse(text = text))
}
