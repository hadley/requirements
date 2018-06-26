#' Find requirements from a block of code
#'
#' Looks for `::`, `:::`, `library()`, `require()`, `requireNamespace()`,
#' and `loadNamespace()`.
#'
#' @param x Code to examine. Supports unquoting.
#' @export
#' @examples
#' req_code(library("rlang"))
#' req_code(rlang::expr())
req_code <- function(x) {
  x <- enexpr(x)
  unique(find_pkgs_rec(x))
}

find_pkgs_rec <- function(x) {
  if (is_syntactic_literal(x) || is_symbol(x)) {
    return(character())
  }

  if (is_pairlist(x)) {
    return(flat_map_chr(as.list(x), find_pkgs_rec))
  }

  if (is_call(x, c("::", ":::"))) {
    char_or_sym(x[[2]])
  } else if (is_call(x, c("library", "require"))) {
    x <- call_standardise(x, env = baseenv())
    if (isTRUE(x$character.only) || identical(x$character.only, quote(T))) {
      if (is.character(x$package)) {
        x$package
      } else {
        character()
      }
    } else {
      char_or_sym(x$package)
    }
  } else if (is_call(x, c("requireNamespace", "loadNamespace"))) {
    x <- call_standardise(x, env = baseenv())
    char_or_sym(x$package)
  } else {
    flat_map_chr(as.list(x)[-1], find_pkgs_rec)
  }

}
