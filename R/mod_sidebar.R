#' sidebar UI Function
#'
#' @description Module for the sidebar. The main data processing is handled by it.
#'
#' @param id Module's ID
#'
#' @import shiny
#' @importFrom shinyjs hidden

#' 
#' @noRd 
mod_sidebar_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h3("Overview"),
    tags$p("This app shows CRAN downloads & Github Stars statistics for a given package (repo)."),
    tags$p("You can check out some tidyverse packages that comes with the app.",
           "And if you have a package on CRAN, see how its doing."),
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
      label = "See how my package is doing."
    ),
    uiOutput(ns("downloading"), style="height:100px;"),
    tags$p("Because the data from github is downloaded page by page,
           the more stars you have, the longer you'll have to wait."),
    tags$blockquote("Popularity is a curse sometimes",
                    style = "color: #8a8a8a; font-size:14px;"),
    tags$p("I'll leave it to you to ponder on that."),
    tags$hr(),
    tags$footer(
      tags$img(src = "https://raw.githubusercontent.com/rstudio/hex-stickers/master/thumbs/shiny.png",
               height = "60px", width = "50px", style = "padding-top:0 !important; float:right"),
      tags$img(src = "https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png",
               height = "60px", width = "50px", style = "padding-top:0 !important; float:right"),
      tags$a(href = "https://github.com/shahreyar-abeer/cranstars", target = "_blank",
             icon("link"), "Github"),
      HTML("&nbsp;"),
      tags$a(href = "https://thewaywer.rbind.io/projects/cranstars-a-first-golem-app-possibly-cran/",
             target = "_blank", icon("link"), "Blog Post"),
      br(),
      br(),
      "by",
      tags$a(href = "https://thewaywer.rbind.io/about/", "Zauad Shahreer Abeer"),
      style = "text-align: center;"
    )
  )
}
    
#' sidebar Server Function
#' 
#' @param id Module's ID
#' @param input,output,session Internal parameters for {shiny}.
#' 
#' @importFrom shinyjs show hide
#' @importFrom waiter Waiter spin_loaders
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
          tags$p("connecting & downloading", style = "color:#292e1eff")
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
          hide("repo", anim = TRUE, animType = "fade", time = .2)
          show("my_repo", anim = TRUE, animType = "slide", time = 1.2)
          show("go", anim = TRUE, animType = "slide", time = 1.2)
        } else {
          hide("my_repo", anim = TRUE, animType = "fade", time = .2)
          hide("go", anim = TRUE, animType = "fade", time = .2)
          show("repo", anim = TRUE, animType = "slide", time = 1.2)
        }
      })
      
      observeEvent(input$go, {
        
        r$cran_dl <- NULL
        r$gh_stars <- NULL
        
        if ( isTRUE(input$check_my_repo) ) {
          
          package = input$my_repo
          date = input$date
          
          if ( isTRUE(grepl("/", package)) ) {

            gh_stars <- reactive({ 
              w$show()
              g <- get_gh_stars(package)
              cran_name <- get_cran_name(package)
              r$cran_dl <- get_cran_data(
                package_names = cran_name,
                from_date = date[1],
                to_date = date[2]
              )
              g
            })
            
            output$downloading <- renderUI({
              # ...
            })
            
            if( inherits(gh_stars(), "try-error") ) {
              showModal(modalDialog(
                title = "Error! Cannot Proceed",
                icon("warning"),
                "Please make sure the github repo exists.",
                style="background: #ff9966"
              ))
            } else {
              
              if( sum(r$cran_dl$count) == 0 ) {
                showModal(modalDialog(
                  title = "Is it on CRAN yet?",
                  icon("warning"),
                  "0 downloads from CRAN. Maybe its not on CRAN yet, is it?",
                  style = "background: #ffcc00"
                ))
              } else {
                showModal(modalDialog(
                  title = "Success!",
                  icon("check"), 
                  " Data successfully downloaded from CRAN & Github.",
                  style = "background: #99cc33;"
                ))
              }
              r$repo <- package
              r$gh_stars <- gh_stars()
            }
          } else {
            showModal(modalDialog(
              title = "Error! Cannot Proceed.",
              icon("warning"),
              "Please provide your repo name in the form", tags$em('rstudio/rsconnect'),
              style="background: #ff9966"
            ))
          }
        }
      })
    }
  )
}


