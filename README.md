
<!-- README.md is generated from README.Rmd. Please edit that file -->

# chemnet

<!-- badges: start -->

<!-- badges: end -->

Chemnet provides utilities and classes for working with reaction
networks

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
devtools::install_github("dbarrows/chemnet")
```

## Creating networks

You write systems of reactions using a natural syntax, and chemnet will
parse it and turn it into an S3 object.

``` r
library(chemnet)

synthesis <- parse_network("A + B -> C, 2.4e-5")
synthesis
#> # Reaction network: 1 reaction x 3 species
#>     Reactants    Products    Rate
#> 1       A + B -> C         2.4e-5
```

#### Sources / Sinks

You can specify sources / sinks using `0` as the species name.

``` r
parse_network("0 -> A, 4")
#> # Reaction network: 1 reaction x 1 species
#>     Reactants    Products  Rate
#> 1           0 -> A            4
```

#### Multiple reactions

Reactions can be entered on new lines.

``` r
network_string <- "
    S + E -> SE, 1.66e-3
    SE -> E + P, 1e-1
"
parse_network(network_string)
#> # Reaction network: 2 reactions x 4 species
#>     Reactants    Products     Rate
#> 1       S + E -> SE        1.66e-3
#> 2          SE -> E + P        1e-1
```

#### Bidirectional reactions

You can use `<->` to indicate bidirectional reactions, with an
additional rate specified at the end of the line.

``` r
parse_network("A <-> B, 1e-1, 2.2")
#> # Reaction network: 2 reactions x 2 species
#>     Reactants    Products  Rate
#> 1           A -> B         1e-1
#> 2           B -> A          2.2
```

#### Species Orders

Prefixing a species name with a number will be interpreted as a reaction
coefficient.

``` r
network <- parse_network("2A -> B, 1e-1")
str(network$reactions[[1]])
#> List of 3
#>  $ reactants:List of 1
#>   ..$ :List of 2
#>   .. ..$ name : chr "A"
#>   .. ..$ order: num 2
#>   .. ..- attr(*, "class")= chr "species"
#>  $ products :List of 1
#>   ..$ :List of 2
#>   .. ..$ name : chr "B"
#>   .. ..$ order: num 1
#>   .. ..- attr(*, "class")= chr "species"
#>  $ rate     : chr "1e-1"
#>  - attr(*, "class")= chr "reaction"
```

## Using networks

#### Propensity functions

You can generate the propensity functions for a reaction network.

``` r
network <- parse_network("
         A -> B, 2.5
    2B + C -> A, 4e-2
")
props <- propensities(network)
props
#> [[1]]
#> function(x) {
#>     2.5*x[1]
#> }
#> <environment: 0x7f97dfcbc5f0>
#> 
#> [[2]]
#> function(x) {
#>     4e-2*x[2]*(x[2]-1)/2*x[3]
#> }
#> <environment: 0x7f97dfc06a50>
```

Note that dimerisations and multiple reactants are handled properly.

Propensity functions take a state vector of species quantities, ordered
according to the output of the `species` function.

``` r
species(network)
#> [1] "A" "B" "C"
state <- c(2, 5, 4) # Corresponds to A, B, C
(props[[1]](state))
#> [1] 5
(props[[2]](state))
#> [1] 1.6
```
