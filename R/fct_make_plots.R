

#' Title
#'
#' @param repo 
#' @param date_range 
#'
#' @importFrom dplyr filter
#' @import ggplot2
#' 
#' @return
#' @export
#'
#' @examples
cran_plot <- function(r) {
  
  
  repo <- get_cran_name(r$repo)
  date_range = r$date
  praise = paste0("{", repo, "} ", " is ", sample(adjectives, 1), "!")
  
  r$cran_dl %>%
    filter(
      package == repo,
      date >= date_range[1] & date <= date_range[2]
    ) %>% 
    glimpse() %>% 
    ggplot() +
    geom_path(aes(x = date, y = count, group = package), color = orange) +
    labs(
      title = "CRAN Downloads",
      subtitle = paste0("CRAN downloads for {", repo, "}"),
      caption = praise
    ) 
}



gh_plot <- function(r) {
  #praise = paste0("{", repo, "} ", " is ", sample(adjectives, 1), "!")
  
  repo = r$repo
  date_range = r$date
  
  r$gh_stars %>% 
    filter(
      package == repo,
      date >= date_range[1] & date <= date_range[2]
    ) %>% 
    mutate(yrmon = make_yrmon(date)) %>% 
    # mutate(
    #   mon = lubridate::month(date),
    #   yr = lubridate::year(date)
    # ) %>% 
    group_by(package, yrmon) %>% 
    tally(n_stars) %>%
    glimpse() %>% 
    ggplot() +
    geom_path(aes(x = yrmon, y = n, group = package), color = "steelblue", size = 1.5) +
    labs(
      title = "Github Stars",
      subtitle = paste0("Github stars for {", repo, "}")
    )
    #ggplot() +
  
  # cran_dl_data %>%
  #   filter(package == repo,
  #          date >= date_range[1] & date <= date_range[2]) %>%
  #   ggplot() +
  #   geom_path(aes(x = date, y = count, group = package), color = orange) +
  #   labs(
  #     title = "CRAN Downloads",
  #     subtitle = paste0("CRAN downloads for {", repo, "}"),
  #     caption = praise
  #   )
}
