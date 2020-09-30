
# github stars data -------------------------------------------------------

## list tidyverse packages
tidypacks <- 
  c("tidyverse/broom",
    "hadley/dplyr",
    "wesm/feather",
    "tidyverse/forcats",
    "hadley/ggplot2",
    "tidyverse/haven",
    "hadley/httr",
    "rstats-db/hms",
    "jeroenooms/jsonlite",
    "hadley/lubridate",
    "tidyverse/magrittr",
    "hadley/modelr",
    "hadley/purrr",
    "tidyverse/readr",
    "hadley/readxl",
    "tidyverse/stringr",
    "tidyverse/tibble",
    "hadley/rvest",
    "tidyverse/tidyr",
    "hadley/xml2")

## getting the github stars using the get_gh_stars() defined in this package
gh_stars_data <- purrr::map(tidypacks, get_gh_stars)
gh_stars_data <- dplyr::bind_rows(gh_stars_data)

usethis::use_data(gh_stars_data, overwrite = TRUE)


# cran downloads data -----------------------------------------------------

## getting cran names, function get_cran_name() defined in the package
tidypacks_cran <- get_cran_name(tidypacks)

## getting cran data for 10+ years
cran_dl_data <- get_cran_data(tidypacks_cran,
                              from_date = "2010-01-01",
                              to_date = "2020-09-01")

usethis::use_data(cran_dl_data, overwrite = TRUE)

