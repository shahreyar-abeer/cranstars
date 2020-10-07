#' cranStars User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
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
              mod_plot_ui("gh", 450)
            ),
            column(
              width = 6,
              mod_plot_ui("cran", 450)
            ),
            column(
              width = 6,
              mod_table_ui("gt")
            ),
            column(
              width = 6,
              uiOutput("quote")
            )
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
#' @importFrom waiter use_waiter
#' @importFrom shinyjs useShinyjs
#' 
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
    use_waiter(),
    useShinyjs()
  )
}

