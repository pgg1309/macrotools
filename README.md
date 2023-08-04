
<!-- README.md is generated from README.Rmd. Please edit that file -->

# macrotools

<!-- badges: start -->
<!-- badges: end -->

The goal of macrotools is to collect some functions that the author uses
regularly during macroeconomic analysis.

## Installation

You can install the development version of macrotools from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("pgg1309/macrotools")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(macrotools)
## Obtains the reference week for BLS payroll for the year 2022
get_bls_refweek('2022', '2022')
#>  [1] 2022-01-09 UTC--2022-01-15 UTC 2022-02-06 UTC--2022-02-12 UTC
#>  [3] 2022-03-06 UTC--2022-03-12 UTC 2022-04-10 UTC--2022-04-16 UTC
#>  [5] 2022-05-08 UTC--2022-05-14 UTC 2022-06-12 UTC--2022-06-18 UTC
#>  [7] 2022-07-10 UTC--2022-07-16 UTC 2022-08-07 UTC--2022-08-13 UTC
#>  [9] 2022-09-11 UTC--2022-09-17 UTC 2022-10-09 UTC--2022-10-15 UTC
#> [11] 2022-11-06 UTC--2022-11-12 UTC 2022-12-04 UTC--2022-12-10 UTC
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
