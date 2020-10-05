#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      sidebarLayout(
        sidebarPanel(
          width = 3,
          fluidRow(
            h1("cranStars", class = "h-title"),
            mod_sidebar_ui("sidebar")
          )
        ),
        
        mainPanel(
          width = 9,
          fluidRow(
            column(
              width = 6,
              mod_plot_ui("cran", 600)
            ),
            column(
              width = 6,
              mod_plot_ui("gh", 450)
            ),
            verbatimTextOutput("repo")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @importFrom shiny tags
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'cranstars'
    ),
    waiter::use_waiter(),
    shinyjs::useShinyjs()
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
    
  )
}

