context('Species')
library(bondr)
library(magrittr)

source('utils.R')

test_that('Species parsing', {
    expect_equal(
        parse_species('X'),
        make_species('X')
    )
    expect_equal(
        parse_species('2X'),
        make_species('X', 2)
    )
    expect_equal(
        parse_species('3X2'),
        make_species('X2', 3)
    )
    expect_equal(
        parse_species('0'),
        NULL
    )
})