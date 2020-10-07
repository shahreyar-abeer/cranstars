test_that("make_table() works", {
  r = list(
    repo = "hadley/dplyr",
    date = c((Sys.Date() - 50), (Sys.Date() - 10)),
    cran_dl = cran_dl_data,
    gh_stars = gh_stars_data
  )
  expect_is(make_table(r), "data.frame")
})