#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      plotOutput(ns("plot"), height = 600)
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
        
        if (type == "cran") {
          gg <- cran_plot(r)
        } else {
          gg <- gh_plot(r)
        }
        
        gg +
          theme_minimal(base_size = 18, base_family = "sans")
        
      }, cacheKeyExpr = list(r$repo, r$date))
    }
  )
}
    
## To be copied in the UI
# mod_main_ui("main_ui_1")
    
## To be copied in the server
# callModule(mod_main_server, "main_ui_1")
 