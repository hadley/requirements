flat_map_chr <- function(x, f, ...) {
  if (length(x) == 0) {
    character()
  } else {
    unlist(lapply(x, f, ...))
  }
}

char_or_sym <- function(x) {
  if (is.character(x)) {
    x
  } else if (is.symbol(x)) {
    as.character(x)
  } else {
    character()
  }
}
