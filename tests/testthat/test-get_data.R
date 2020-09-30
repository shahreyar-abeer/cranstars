
test_that("get_gh_data() works", {
  repo <- "rstudio/rsconnect"
  expect_is(get_gh_stars(repo), "data.frame")
})

test_that("get_cran_data() works", {
  package_name <- "rsconnect"
  expect_is(get_cran_data(package_name, from = (Sys.Date() - 10)), "data.frame")
})
