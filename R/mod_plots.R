#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_plot_ui <- function(id, height){
  ns <- NS(id)
  tagList(
    fluidRow(
      plotOutput(ns("plot"), height = height)
    )
  )
}
    
#' main Server Function
#'
#' @noRd 
mod_plot_server <- function(id, r, type = c("cran", "gh")){
  
  type <- match.arg(type)
  
  moduleServer(
    id = id,
    function(input, output, session) {
      ns <- session$ns
      
      
      output$plot <- renderCachedPlot({
        
        req(r$cran_dl)
        req(r$gh_stars)
        if (type == "cran") {
          gg <- cran_plot(r)
        } else {
          gg <- gh_plot(r)
        }
        
        gg
        
      }, cacheKeyExpr = {list(r$repo, r$date, r$gh_stars, r$cran_dl)} )
    }
  )
}
    
## To be copied in the UI
# mod_main_ui("main_ui_1")
    
## To be copied in the server
# callModule(mod_main_server, "main_ui_1")
 
