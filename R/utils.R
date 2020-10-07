
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


globalVariables(c("repos", "cran_dl_data", "gh_stars_data"))

orange <- "#DA7C30"


adjectives <- c("outstanding", "great", "first-class", "awesome", "luminous",
                "extraordinary", "polished", "stylish", "magnificent", "stunning",
                "superb", "praiseworthy", "marvelous", "sensational", "remarkable")

make_yrmon <- function(date) {
  paste0(format(date, "%b"), ", ", format(date, "%Y"))
}


get_most_count <- function(data) {
  d <- data %>%
    filter(count == max(count, na.rm = TRUE)) %>%
    slice(1) %>% 
    select(date, count) %>%
    mutate(
      date = format(date, "%d %b, %Y"),
      count = ifelse(count > 1000, paste0(round(count/1000, 1), "k"), count)
    )
    paste(d$date, " (", d$count, ")")
}

get_most_month <- function(data) {
  d <- data %>%
    count(.data$yrmon, wt = count) %>%
    filter(n == max(n, na.rm = TRUE)) %>%
    slice(1) %>% 
    mutate(n = ifelse(n > 1000, paste0(round(n/1000, 1), "k"), n))
    paste(d$yrmon, "(", d$n, ")")
}

get_avg <- function(data) {
  avg <- NULL
  avg2 <- NULL
  data %>%
    group_by(.data$yrmon) %>%
    summarise(avg = mean(count, na.rm = TRUE)) %>%
    #glimpse() %>% 
    summarise(avg2 = mean(avg)) %>%
    mutate(avg2 = ifelse(avg2 > 1000, paste0(round(avg2/1000, 1), "k"), round(avg2, 1))) %>% 
    pull()
}



#' Theme for the github calendar plot
#' 
#' @param base_size \code{numeric} Base font size
#' @param base_family \code{string} Base font family
#' 
#' @importFrom ggplot2 theme_bw
theme_calendar <- function(base_size = 15, base_family = "sans") {
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