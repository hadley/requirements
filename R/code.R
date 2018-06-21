find_pkgs <- function(x) {
  x <- enexpr(x)
  find_pkgs_rec(x)
}

find_pkgs_rec <- function(x) {
  if (is_syntactic_literal(x) || is_symbol(x)) {
    return(character())
  }

  if (is_pairlist(x)) {
    return(flat_map_chr(x, find_pkgs_rec))
  }

  x <- call_standardise(x)

  if (is_call(x, c("::", ":::"))) {
    char_or_sym(x$pkg)
  } else if (is_call(x, c("library", "require"))) {
    if (isTRUE(x$character.only) || identical(x$character.only, quote(T))) {
      character()
    } else {
      char_or_sym(x$package)
    }
  } else if (is_call(x, c("requireNamespace", "loadNamespace"))) {
    char_or_sym(x$package)
  } else {
    flat_map_chr(x[-1], find_pkgs_rec)
  }

}
