context("Network properties")
library(bondr)
library(magrittr)
library(stringr)

source("utils.R")

body_string <- function(prop) {
    prop %>% body() %>% as.character() %>% .[2] %>% str_replace_all(" ", "")
}

test_that("Propensities", {
    net <- network("A -> B, 1")
    expect_equal(
        propensities(net)[[1]] %>% body_string(),
        "1*x[1]"
    )
    
    net <- network("2A -> 0, 0.5")
    expect_equal(
        propensities(net)[[1]] %>% body_string(),
        "0.5*x[1]*(x[1]-1)/2"
    )
    expect_equal(
        propensities(
            net,
            rateless = TRUE
        )[[1]] %>% body_string(),
        "1*x[1]*(x[1]-1)/2"
    )
})

test_that("Updates", {
    net <- network("A -> B, 1")
    expect_equal(
        updates(net)[[1]] %>% body_string(),
        "x+c(-1,1)"
    )
    
    net <- network("X -> 0, 1")
    expect_equal(
        updates(net)[[1]] %>% body_string(),
        "x+c(-1)"
    )

    net <- network("2X -> 3X, 1")
    expect_equal(
        updates(net)[[1]] %>% body_string(),
        "x+c(1)"
    )
})

test_that("Stoichiometric matrix", {
    net <- network("
        A <-> B, 1, 2
        0  -> A, 0.5
    ")
    expect_equal(
        stmat(net),
        matrix(c(-1, 1, 1, -1, 1, 0), nrow = 2)
    )

    net <- network("
        0  -> A,  1
        3X -> 2X, 2
    ")
    expect_equal(
        stmat(net),
        matrix(c(1, 0, 0, -1), nrow = 2)
    )
})