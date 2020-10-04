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
      start = "2018-01-01",
      end = Sys.Date() - 3,
      startview = "year"
    ),
    shiny::textInput(
      inputId = ns("my_package"),
      label = "My package",
      placeholder = "rstudio/rsconnect"
    ),
    actionButton(
      inputId = ns("go"),
      label = "Go"
    ),
    checkboxInput(
      inputId = ns("my_repo"),
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
        
        if( isFALSE(input$my_repo) ) {
          r$repo = input$repo
          r$cran_dl = cran_dl_data
          r$gh_stars = gh_stars_data
        }

      })
      
      observeEvent(input$date, {
        r$date = input$date
      })
      
      observeEvent(input$go, {
        
        
        if ( isTRUE(input$my_repo) ) {
          
          package = input$my_package
          date = input$date
          
          if ( isTRUE(grepl("/", package)) ) {
            
            
            cran_name <- get_cran_name(package)
            r$cran_dl <- get_cran_data(
              package_names = cran_name,
              from = date[1],
              to = date[2]
            )
            
            # output$login <- renderUI({
            #   h3("This is it")
            # })
            shinybusy::show_modal_spinner(
              spin = "folding-cube",
              color = "#4F84B6",
              text = "Trying & Downloading Github data. \n
              The more stars you have, the longer you'll have to wait!"
            )
            gh_stars <- get_gh_stars(package)
            shinybusy::remove_modal_spinner()
            
            if( inherits(gh_stars, "try-error") ) {
              showModal(modalDialog(
                title = "Warning: Cannot Proceed",
                "Please make sure the github repo exists."
              ))
            } else {
              r$repo <- package
              r$gh_stars <- gh_stars
            }
          } else {
            showModal(modalDialog(
              title = "Warning: Cannot Proceed.",
              "Please provide your repo name in the form", tags$em('rstudio/rsconnect')
            ))
          }
          
          # cran_name <- try(
          #   get_cran_name(package),
          #   silent = TRUE
          # )
          # if(inherits(cran_name, "try-error")) {
          #   showModal(modalDialog(
          #     title = "Make sure you're package is on CRAN"
          #   ))
          # } else {
          #   r$cran_dl <- get_cran_data(
          #     package_names = cran_name,
          #     from = date[1],
          #     to = date[2]
          #   )
          #   r$repo <- package
          #   r$gh_stars <- get_gh_stars(package)
          # }
          # 
          
          
          
          
          
          
        }
          
      })
      
      
    }
  )
}
    
## To be copied in the UI
# mod_sidebar_ui("sidebar_ui_1")
    
## To be copied in the server
# callModule(mod_sidebar_server, "sidebar_ui_1")
 
