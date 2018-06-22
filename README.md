# requirements

requirements allows you to impute required packages from R code, files (like `.R`, `.Rmd` and `.Rnw`) and directories. It primarily looks for use of functions like `library()` and `::`, but also uses heuristics to detect common implicit dependencies (e.g. methods, shiny, and roxygen2).

## Installation

requirements is not currently available on CRAN, but you can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("hadley/requirements")
```
