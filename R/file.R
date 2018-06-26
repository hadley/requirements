#' Extract requirements from a file
#'
#' @param path Path to file
#' @export
#' @examples
#' path <- system.file("examples", "simple.R", package = "requirements")
#' req_file(path)
req_file <- function(path) {
  if (!file.exists(path)) {
    stop("`path` does not exist", call. = FALSE)
  }
  ext <- tolower(tools::file_ext(path))

  switch(ext,
    r = req_file_r(path),
    character()
  )
}

req_file_r <- function(path) {
  tryCatch(
    error = function(err) character(),
    {
      code <- parse(path)
      req_code(!!code)
    }
  )
}
