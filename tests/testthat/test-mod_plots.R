test_that("mod_plot_ui works", {
  expect_is(mod_plot_ui("ID", 450, "cran"), "shiny.tag.list")
})

test_that("mod_plot_server works for ggplot", {
  shiny::testServer(
    mod_plot_server,
    args = list(
      r = reactiveValues(
        repo = "hadley/dplyr",
        date = c((Sys.Date() - 10), (Sys.Date() - 5)),
        cran_dl = cran_dl_data,
        gh_stars = gh_stars_data
      ),
      type = "gh"
    ), {
      expect_type(session$output$plot_gh$src, "character")
      expect_equal(session$output$plot_gh$class, "shiny-scalable")
    })
})


test_that("mod_plot_server works for highchart", {
  shiny::testServer(
    mod_plot_server,
    args = list(
      r = reactiveValues(
        repo = "hadley/dplyr",
        date = c((Sys.Date() - 10), (Sys.Date() - 5)),
        cran_dl = cran_dl_data,
        gh_stars = gh_stars_data
      ),
      type = "cran"
    ), {
      expect_type(session$output$plot_cran, "character")
      expect_s3_class(session$output$plot_cran, "json")
    })
})