#' sidebar UI Function
#'
#' @description Module for the sidebar. The main data processing is handled by it.
#'
#' @param id Module's ID
#'
#' @import shiny
#' @importFrom shinyjs hidden show hide
#' @importFrom waiter Waiter spin_loaders
#' 
#' @noRd 
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
    hidden(textInput(
      inputId = ns("my_repo"),
      label = "Your Repo",
      placeholder = "e.g., rstudio/rsconnect",
      value = "dreamRs/esquisse"
    )),
    hidden(actionButton(
      inputId = ns("go"),
      label = "Go"
    )),
    checkboxInput(
      inputId = ns("check_my_repo"),
      label = "I want to check out my pakcage!"
    ),
    uiOutput(ns("downloading"), style="height:100px;")
  )
}
    
#' sidebar Server Function
#' 
#' @param id Modules ID
#' @param input,output,session Internal parameters for {shiny}.
#' 
#' @importFrom shinybusy show_modal_spinner remove_modal_spinner
#'
#' @noRd 
mod_sidebar_server <- function(id, r){
  moduleServer(
    id = id,
    function(input, output, session) {
      ns <- session$ns
      
      w = Waiter$new(
        id = ns("downloading"),
        color = "transparent",
        html = tagList(
          spin_loaders(id = 38, color = "#292e1eff"),
          tags$p("connecting & downloading ...", style = "color:#292e1eff")
        )
      )
      
      observeEvent(input$repo, {
      
        if( isFALSE(input$check_my_repo) ) {
          r$repo = input$repo
          r$cran_dl = cran_dl_data
          r$gh_stars = gh_stars_data
        }

      })
      
      observeEvent(input$date, {
        r$date = input$date
      })
      
      observeEvent(input$check_my_repo, {
        if ( isTRUE(input$check_my_repo) ) {
          hide("repo", anim = TRUE, animType = "fade")
          show("my_repo", anim = TRUE, animType = "slide")
          show("go", anim = TRUE, animType = "slide")
        } else {
          hide("my_repo", anim = TRUE, animType = "fade")
          hide("go", anim = TRUE, animType = "fade")
          show("repo", anim = TRUE, animType = "slide")
        }
      })
      
      observeEvent(input$go, {
        
        r$cran_dl <- NULL
        r$gh_stars <- NULL
        
        if ( isTRUE(input$check_my_repo) ) {
          
          package = input$my_repo
          date = input$date
          
          if ( isTRUE(grepl("/", package)) ) {
            
            
            
            
            # output$login <- renderUI({
            #   h3("This is it")
            # })
            
            # show_modal_spinner(
            #   spin = "folding-cube",
            #   color = "#4F84B6",
            #   text = "Trying & Downloading Github data. \n
            #   The more stars you have, the longer you'll have to wait!"
            # )
            # 
            
            #gh_stars <- reactive()
            
            gh_stars <- reactive({ 
              w$show()
              cran_name <- get_cran_name(package)
              r$cran_dl <- get_cran_data(
                package_names = cran_name,
                from_date = date[1],
                to_date = date[2]
              )
              get_gh_stars(package)
            })
            
            output$downloading <- renderUI({
              #w$show()
              #gh_stars <- reactive({ get_gh_stars(package) })
              # if( !inherits(gh_stars(), "try-error") )
              #   tags$p(icon("download"), paste("Downloaded", nrow(gh_stars()), "rows"))
            })
            
            # observeEvent(gh_stars(), {
            #   print("now")
            #   shinyjs::hide("downloading", anim = TRUE, animType = "fade", time = 3)
            # })
            
            
            #gh_stars <- ""
            
            # remove_modal_spinner()
            
            if( inherits(gh_stars(), "try-error") ) {
              showModal(modalDialog(
                title = "Warning: Cannot Proceed",
                "Please make sure the github repo exists."
              ))
            } else {
              #print(gh_stars())
              
              if( sum(r$cran_dl$count) == 0 ) {
                showModal(modalDialog(
                  title = "Is it on CRAN yet?",
                  "Data for CRAN has 0 rows, it may not be up on CRAN yet.",
                  "Or simply, it doesn't have any downloads."
                ))
              } else {
                showModal(modalDialog(
                  title = "Success!",
                  "Data successfully downloaded from CRAN & Github."
                ))
              }
              
              r$repo <- package
              r$gh_stars <- gh_stars()
            }
          } else {
            showModal(modalDialog(
              title = "Warning: Cannot Proceed.",
              "Please provide your repo name in the form", tags$em('rstudio/rsconnect')
            ))
          }
        }
      })
    }
  )
}


