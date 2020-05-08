context("Network")
library(bondr)
library(magrittr)

source("utils.R")

test_that("Network Parsing", {
    expect_equal(
        network("A -> B, 1"),
        make_network(list(make_reaction(
            list(make_species("A")),
            list(make_species("B")),
            1
        )))
    )
    expect_equal(
        network("A <-> B, 1, 2"),
        network("
            A -> B, 1
            B -> A, 2
        ")
    )
    expect_equal(
        network("
            A <-> B, 1, 2
            0  -> A, 0.5 
        "),
        make_network(list(
                make_reaction(
                    list(make_species("A")),
                    list(make_species("B")),
                    1
                ),
                make_reaction(
                    list(make_species("B")),
                    list(make_species("A")),
                    2
                ),
                make_reaction(
                    list(),
                    list(make_species("A")),
                    0.5
                )
            )
        )
    )
})