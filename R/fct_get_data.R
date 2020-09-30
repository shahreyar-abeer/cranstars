

#' Get the github stars for the supplied repo on a daily basis
#'
#' @param repo A \code{character} vector containing the repo name, eg. "rstudio/rsconnect"
#'
#' @return A \code{data.frame}
#' 
#' 
#' @export
#'
#' @importFrom lubridate ymd_hms
#' @importFrom gh gh
#' @importFrom rlang .data
#' @import dplyr
#' 
#'
#' @examples
#' get_gh_stars("rstudio/rsconnect")
#' 
get_gh_stars <- function(repo) {
  # get data, loop because pagination
  stardates <- NULL
  
  geht <- TRUE
  page <- 1
  while(geht){
    stars <- try(gh::gh(paste0("/repos/", repo, "/stargazers"),
                    .send_headers = c("Accept" = 'application/vnd.github.v3.star+json'),
                    .token = Sys.getenv("GITHUB_PAT"),
                    page = page))
    
    geht <- length(stars) != 0
    if(geht){
      stardates <- c(stardates, vapply(stars, "[[", "", "starred_at"))
      page <- page + 1
    }
  }
  
  star_table <- data.frame(time = ymd_hms(stardates)) %>% 
    mutate(date = as.Date(.data$time)) %>% 
    group_by(date) %>% 
    summarise(n_stars = n()) %>% 
    mutate(package = repo)
  
  star_table
}


#' Title
#'
#' @param package_names A character vector, names of packages to download data for
#' @param from_date A string
#' @param to_date A string, default is set to today's date
#'
#' @return A \code{data.frame}
#' 
#' @importFrom cranlogs cran_downloads
#' 
#' @export
#'
#' @examples
#' get_cran_data("rsconnect")
#' 
get_cran_data <- function(package_names, from_date, to_date = Sys.Date()) {
  cran_downloads(
    package_names,
    from = from_date,
    to = as.character(to_date)
  )
}




