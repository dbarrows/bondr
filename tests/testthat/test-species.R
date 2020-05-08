context("Species")
library(bondr)
library(magrittr)

make_species <- function(name, order = 1) {
    structure(
        list(
            name = name,
            order = order
        ),
        class = "species"
    )
}

test_that("Species parsing", {
    expect_equal(
        parse_species("X"),
        make_species("X")
    )
    expect_equal(
        parse_species("2X"),
        make_species("X", 2)
    )
    expect_equal(
        parse_species("3X2"),
        make_species("X2", 3)
    )
    expect_equal(
        parse_species("0"),
        NULL
    )
})

make_reaction <- function(reactants, products, rate) {
    structure(
        list(
            reactants = reactants,
            products = products,
            rate = rate
        ),
        class = "reaction"
    )
}

test_that("Reaction parsing", {
    expect_equal(
        parse_reaction("A -> B, 1"),
        list(
             make_reaction(
                list(make_species("A")),
                list(make_species("B")),
                1
            )
        )
    )
    expect_equal(
        parse_reaction("A <-> B, 1, 2"),
        list(
             make_reaction(
                list(make_species("A")),
                list(make_species("B")),
                1
            ),
            make_reaction(
                list(make_species("B")),
                list(make_species("A")),
                2
            )
        )
    )
    expect_equal(
        parse_reaction("0 -> X, 0.5"),
        list(
             make_reaction(
                list(),
                list(make_species("X")),
                0.5
            )
        )
    )
    expect_equal(
        parse_reaction("X -> 0, 1.2"),
        list(
             make_reaction(
                list(make_species("X")),
                list(),
                1.2
            )
        )
    )
})