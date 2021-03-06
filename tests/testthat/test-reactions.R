context('Reactions')
library(bondr)
library(magrittr)

source('utils.R')

test_that('Reaction parsing', {
    expect_equal(
        parse_reaction('A -> B, 1'),
        list(make_reaction(
            list(make_species('A')),
            list(make_species('B')),
            1
        ))
    )
    expect_equal(
        parse_reaction('A <-> B, 1, 2'),
        list(
             make_reaction(
                list(make_species('A')),
                list(make_species('B')),
                1
            ),
            make_reaction(
                list(make_species('B')),
                list(make_species('A')),
                2
            )
        )
    )
    expect_equal(
        parse_reaction('0 -> X, 0.5'),
        list(make_reaction(
            list(),
            list(make_species('X')),
            0.5
        ))
    )
    expect_equal(
        parse_reaction('X -> 0, 1.2'),
        list(make_reaction(
            list(make_species('X')),
            list(),
            1.2
        ))
    )
})

test_that('Reaction orders', {
    expect_equal(
        order(parse_reaction('0 -> X, 1')[[1]]),
        0
    )
    expect_equal(
        order(parse_reaction('X -> 0, 1')[[1]]),
        1
    )
    expect_equal(
        order(parse_reaction('A + B -> X, 1')[[1]]),
        2
    )
    expect_equal(
        order(parse_reaction('A + 2B -> X, 1')[[1]]),
        3
    )
    expect_equal(
        order(parse_reaction('2B + 3X -> X, 1')[[1]]),
        5
    )
})