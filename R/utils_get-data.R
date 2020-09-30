
#' Get only package name from repo name
#'
#' @param repo The repo name, e.g \code{"rstudio/rsconnect"}
#'
#' @return A string, the package name, e.g \code{"rsconnect"}
#' @export
#'
#' @examples
#' get_cran_name("rsconnect/rstudio")
get_cran_name <- function(repo) {
  broken <- strsplit(repo, "/")
  unlist(lapply(broken, "[[", 2))
}
