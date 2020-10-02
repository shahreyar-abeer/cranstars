
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

orange <- "#DA7C30"


adjectives <- c("outstanding", "great", "first-class", "awesome", "luminous",
                "extraordinary", "polished", "stylish", "magnificent", "stunning",
                "superb", "praiseworthy", "marvelous", "sensational", "remarkable")

make_yrmon <- function(date) {
  as.Date(paste0(format(date, "%Y-%m"), "-01"))
}