test_that("cran_plot() works", {
  r = list(
    repo = "hadley/dplyr",
    date = c((Sys.Date() - 10), (Sys.Date() - 5)),
    cran_dl = cran_dl_data,
    gh_stars = gh_stars_data
  )
  expect_is(cran_plot(r), "highchart")
})

test_that("gh_plot() works", {
  r = list(
    repo = "hadley/dplyr",
    date = c((Sys.Date() - 10), (Sys.Date() - 5)),
    cran_dl = cran_dl_data,
    gh_stars = gh_stars_data
  )
  expect_is(gh_plot(r), "ggplot")
})
