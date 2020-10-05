
#' Get only package name from repo name
#'
#' @param repo \code{string} The repo name, e.g., \bold{"rstudio/rsconnect"}
#'
#' @return \code{string} The package name, e.g., \bold{"rsconnect"}
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

#' Theme for the github calendar plot
#' 
#' @param base_size \code{numeric} Base font size
#' @param base_family \code{string} Base font family
#' 
#' @importFrom ggplot2 theme_bw
theme_calendar <- function(base_size = 15, base_family = "sans") {
  ## TODO: start with theme_minimal
  ret <- theme_bw(base_family = base_family, base_size = base_size) +
    theme(legend.background = element_blank(),
          legend.key = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          strip.background = element_blank(),
          plot.background = element_blank(),
          axis.line = element_blank(),
          panel.grid = element_blank())
  ret
}