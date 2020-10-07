#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#' 
#' @importFrom shiny reactiveValues
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  r = reactiveValues(
    repo = NULL,
    date = NULL,
    cran_dl = NULL,
    gh_stars = NULL
  )
  mod_sidebar_server("sidebar", r)
  mod_plot_server("cran", r, "cran")
  mod_plot_server("gh", r, "gh")
  mod_table_server("gt", r)
  
  output$quote <- renderUI({
    invalidateLater(1000)
    tags$blockquote(icon("clock"), format(Sys.time(), "%a, %b %d, %Y | %X"), style = "color: #8a8a8a")
  })
  
}
