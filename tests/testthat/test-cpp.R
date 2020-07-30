context('C++')
library(bondr)
library(magrittr)

source('utils.R')

test_that('Compiles', {
    expect_equal(
        network_examples() %>%
            compile() %>%
            class(),
        'externalptr'
    )
})
