#' sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sidebar_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h3("Overview"),
    tags$p("This app shows the cran download stats & gh stars stasts"),
    selectizeInput(
      inputId = ns("repo"),
      label = "Repo",
      choices = repos$tidypacks
    ),
    dateRangeInput(
      inputId = ns("date"),
      label = "Date Range",
      min = "2010-01-01",
      max = Sys.Date() - 3,
      start = "2015-01-01",
      end = Sys.Date() - 3,
      startview = "year"
    ),
    shiny::textInput(
      inputId = ns("my_package"),
      label = "My package"
    ),
    actionButton(
      inputId = ns("go"),
      label = "Go"
    ),
    checkboxInput(
      inputId = ns("change"),
      label = "I want to check out my pakcage!"
    )
  )
}
    
#' sidebar Server Function
#'
#' @noRd 
mod_sidebar_server <- function(id, r){
  moduleServer(
    id = id,
    function(input, output, session) {
      ns <- session$ns
      
      observeEvent(input$repo, {
        r$repo = input$repo
      })
      
      observeEvent(input$date, {
        r$date = input$date
      })
      
      observeEvent(input$go, {
        
        package = input$my_package
        date = input$date
        
        if (input$change) {
          r$repo <- package
          r$cran_dl <- get_cran_data(
            package_names = get_cran_name(package),
            from = date[1],
            to = date[2]
          )
          r$gh_stars <- get_gh_stars(package)
        }
          
      })
      
      
    }
  )
}
    
## To be copied in the UI
# mod_sidebar_ui("sidebar_ui_1")
    
## To be copied in the server
# callModule(mod_sidebar_server, "sidebar_ui_1")
 
