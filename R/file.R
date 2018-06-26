#' Extract requirements from a file
#'
#' @description
#' * `.R`: extracts requirements from parsed code
#'
#' * `.Rmd`: requirements from chunks. If rmarkdown package is installed,
#'   will also add requirements from custom output type.
#'
#' @param path Path to file
#' @export
#' @examples
#' path_r <- system.file("examples", "simple.R", package = "requirements")
#' path_rmd <- system.file("examples", "simple.Rmd", package = "requirements")
#'
#' req_file(path_r)
#' req_file(path_rmd)
req_file <- function(path) {
  if (!file.exists(path)) {
    stop("`path` does not exist", call. = FALSE)
  }
  ext <- tolower(tools::file_ext(path))

  switch(ext,
    r = req_file_r(path),
    rmd = req_file_rmd(path),
    character()
  )
}

# .R ----------------------------------------------------------------------

req_file_r <- function(path) {
  tryCatch(
    error = function(err) character(),
    {
      code <- parse(path)
      req_code(!!code)
    }
  )
}

# .Rmd --------------------------------------------------------------------

req_file_rmd <- function(path) {
  lines <- readLines(path)

  chunks <- rmd_chunks(lines)
  chunk_reqs <- flat_map_chr(chunks, req_text)

  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    yaml_reqs <- character()
  } else {
    format <- rmarkdown::default_output_format(path)
    yaml_reqs <- req_text(format)
  }

  reqs <- c("rmarkdown", chunk_reqs, yaml_reqs)
  unique(reqs)
}

rmd_chunks <- function(lines) {
  # From https://github.com/rstudio/rstudio/blob/0edb05f67b4f2eea25b8cfb15f7c64ec9b27b288/src/gwt/acesupport/acemode/rmarkdown_highlight_rules.js#L181-L184
  chunk_start_re <- "^(?:[ ]{4})?`{3,}\\s*\\{[Rr]\\b(?:.*)engine\\s*\\=\\s*['\"][rR]['\"](?:.*)\\}\\s*$|^(?:[ ]{4})?`{3,}\\s*\\{[rR]\\b(?:.*)\\}\\s*$";
  chunk_end_re <- "^(?:[ ]{4})?`{3,}\\s*$"

  chunk_start <- grepl(chunk_start_re, lines, perl = TRUE)
  chunk_end <- grepl(chunk_end_re, lines, perl = TRUE)

  chunk_num <- cumsum(chunk_start)
  in_chunk <- (chunk_num - cumsum(chunk_end)) != 0

  chunks <- split(lines[in_chunk], chunk_num[in_chunk])
  names(chunks) <- NULL

  # Strip off first element, the chunk header
  chunks <- lapply(chunks, function(x) x[-1])
  lapply(chunks, paste, collapse = "\n")
}

req_text <- function(text) {
  tryCatch(
    error = function(err) character(),
    {
      code <- parse(text = text)
      req_code(!!code)
    }
  )
}
