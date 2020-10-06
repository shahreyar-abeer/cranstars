
make_table <- function(r) {
  #r$cran_dl %>% 
    repo <- get_cran_name(r$repo)
    date_range = r$date
    #praise = paste0("{", repo, "} ", " is ", sample(adjectives, 1), "!")
    
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
    
    #print(str(cran))
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
    
    #cat("gh data", str(gh))
    
    cran_summary_data <- data.frame(col_names, cran_summary)
    
    print(cran_summary_data)
    
    print("gh summary")
    print(gh_summary)
    
    gh_summary_data <- data.frame(col_names, gh_summary)
    
    
    
    cran_summary_data %>% 
      left_join(gh_summary_data, by = "col_names") 
      
}