
get_cran_name <- function(repo) {
  broken <- strsplit(repo, "/")
  unlist(lapply(broken, "[[", 2))
}
