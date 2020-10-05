

#' Title
#'
#' @param r \code{reactiveValues} object with 4 slots, repo, date, cran_dl & gh_stars
#'
#' @importFrom dplyr filter
#' @import ggplot2
#' 
#' @return
#' @export
#'
cran_plot <- function(r) {
  
  repo <- get_cran_name(r$repo)
  date_range = r$date
  praise = paste0("{", repo, "} ", " is ", sample(adjectives, 1), "!")
  
  r$cran_dl %>%
    filter(
      .data$package == repo,
      date >= date_range[1] & date <= date_range[2]
    ) %>% 
    glimpse() %>% 
    ggplot() +
    geom_path(aes(x = date, y = count, group = .data$package), color = orange) +
    labs(
      title = "CRAN Downloads",
      subtitle = paste0("CRAN downloads for {", repo, "}"),
      caption = praise
    ) +
    theme_minimal(base_size = 18, base_family = "sans")
}



#' Title
#'
#' @param r \code{reactiveValues} object with 4 slots, repo, date, cran_dl & gh_stars
#'
#' @return
#' 
#' @importFrom lubridate year week day
#' 
#' @export
#'
gh_plot <- function(r) {
  #praise = paste0("{", repo, "} ", " is ", sample(adjectives, 1), "!")
  
  repo = r$repo
  date_range = r$date
  
  start = date_range[1]
  end = date_range[2]
  all_dates <- data.frame(date = seq(start, end, by = "day"))
  
  stars <- r$gh_stars %>% 
    filter(package == repo)
  
  joined <- all_dates %>% 
    left_join(stars) %>% 
    mutate(year = year(date), week = week(date), day = weekdays(date, TRUE)) %>% 
    filter(date >= date_range[1] & date <= date_range[2])
  
  
  joined %>% 
    glimpse() %>% 
    ggplot(aes(x = week, y = day, fill = n_stars)) +
    
    scale_fill_gradient(
      low = "#c1f5ca",
      high = "#366E39",
      na.value = "grey90",
      limits = c(0, max(joined$n_stars)
      )) +
    
    geom_tile(color = "white", size = 0.4) +
    facet_wrap("year", ncol = 1) +
    scale_x_continuous(
      expand = c(0, 0),
      breaks = seq(1, 52, length = 12),
      labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")) +
    scale_y_discrete(
      expand = c(0, 0),
      #breaks = seq(1, 7),
      labels = c("Thu", "Wed", "Tue", "Mon", "Sun", "Sat", "Fri"),
    ) + 
    labs(
      title = "Github Stars (in a github calendar plot)",
      subtitle = paste0("Stars for {", repo, "}")
    ) +
    theme_calendar() +
    theme(axis.title = element_blank(),
          axis.ticks = element_blank(),
          legend.position = "bottom",
          legend.key.width = unit(1, "cm"),
          strip.text = element_text(hjust = 0.01, face = "bold", size = 15),
          title = element_text(size = 18),
          legend.title = element_blank())
}
