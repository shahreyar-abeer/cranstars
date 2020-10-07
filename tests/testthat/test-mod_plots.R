test_that("mod_plot_ui works", {
  expect_is(mod_plot_ui("ID", 450), "shiny.tag.list")
})

test_that("mod_plot_server works", {
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
      expect_type(session$output$plot$src, "character")
      expect_equal(session$output$plot$class, "shiny-scalable")
    })
})


