#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  r = reactiveValues(
    repo = NULL,
    date = NULL,
    cran_dl = cran_dl_data,
    gh_stars = gh_stars_data
  )
  mod_sidebar_server("sidebar", r)
  mod_plot_server("cran", r, "cran")
  mod_plot_server("gh", r, "gh")
  output$repo <- renderPrint({
    paste(get_cran_name(r$repo), r$date)
  })
}
