
make_table <- function(r) {
  
  ## for R-CMD-check
  n_stars <- NULL  
  
  repo <- get_cran_name(r$repo)
  date_range = r$date
    
  cran <- r$cran_dl %>%
    filter(
      .data$package == repo,
      date >= date_range[1] & date <= date_range[2]
    ) %>% 
    mutate(
      yrmon = make_yrmon(date)
    )
  
  gh <- r$gh_stars %>% 
    filter(
      .data$package == r$repo,
      date >= date_range[1] & date <= date_range[2]
    ) %>% 
    mutate(
      yrmon = make_yrmon(date)
    ) %>% 
    rename(count = n_stars)
  
  col_names <- c(
    "Most in a day",
    "Best month",
    "Average/month"
  )

  cran_summary <- c(
    get_most_count(cran),
    get_most_month(cran),
    get_avg(cran)
  )
  
  gh_summary = c(
    get_most_count(gh),
    get_most_month(gh),
    get_avg(gh)
  )
  
  cran_summary_data <- data.frame(col_names, cran_summary)
  gh_summary_data <- data.frame(col_names, gh_summary)
  
  cran_summary_data %>% 
    left_join(gh_summary_data, by = "col_names")
      
}