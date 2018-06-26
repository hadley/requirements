#' Extract requirements from a directory
#'
#' Extracts requirements from all files in the directory and then ...
#'
#' @param path Path to recursively search
req_dir <- function(path = ".") {
  files <- dir(path, recursive = TRUE, include.dirs = FALSE, full.names = TRUE)

  sort(unique(flat_map_chr(files, req_file)))
}
