#' Extract requirements from a `NAMESPACE` file
#'
#' Looks for `imports()` and `importFrom()` directives.
#'
#' @param path Path to directory containing namespace file.
#' @export
req_namespace <- function(path) {
  ns <- parseNamespaceFile(basename(path), dirname(path), mustExist = TRUE)
  imports <- ns$imports

  pkg_name <- function(x) {
    if (length(x) == 1) {
      x
    } else if (length(x) == 2) {
      x[[1]]
    } else {
      character()
    }
  }

  unique(flat_map_chr(imports, pkg_name))
}

