make_species <- function(name, order = 1) {
    structure(
        list(
            name = name,
            order = order
        ),
        class = 'species'
    )
}

make_reaction <- function(reactants, products, rate) {
    structure(
        list(
            reactants = reactants,
            products = products,
            rate = rate
        ),
        class = 'reaction'
    )
}

make_network <- function(reactions) {
    structure(
        list(reactions = reactions),
        class = 'network'
    )
}