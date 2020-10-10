#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom highcharter highchartOutput
mod_plot_ui <- function(id, height, type){
  ns <- NS(id)
  tagList(
    fluidRow(
      if ( type == "cran" ) highchartOutput(ns("plot_cran"), height = height)
      else plotOutput(ns("plot_gh"), height = height)
    )
  )
}
    
#' main Server Function
#' @importFrom highcharter renderHighchart
#' @noRd 
mod_plot_server <- function(id, r, type = c("cran", "gh")){
  
  type <- match.arg(type)
  
  moduleServer(
    id = id,
    function(input, output, session) {
      ns <- session$ns
      
      if ( type == "cran" ) {
        output$plot_cran <- renderHighchart({
          cran_plot(r)
        })
      } else {
        output$plot_gh <- renderCachedPlot({
          
          req(r$cran_dl)
          req(r$gh_stars)
          # if (type == "cran") {
          #   gg <- cran_plot(r)
          # } else {
          #   gg <- gh_plot(r)
          # }
          
          gh_plot(r)
          
        }, cacheKeyExpr = {list(r$repo, r$date, r$gh_stars, r$cran_dl)} )
      }
      
      
    }
  )
}

 
