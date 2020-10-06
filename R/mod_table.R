#' table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import gt
mod_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      gt_output(ns("gt"))
    )
  )
}
    
#' table Server Function
#'
#' @noRd 
mod_table_server <- function(id, r){
  
  moduleServer(
    id = id,
    function(input, output, session) {
      
      ns <- session$ns
      
      output$gt <- render_gt({
        
        req(r$cran_dl)
        req(r$gh_stars)
        
        make_table(r) %>% 
          gt(rowname_col = "col_names") %>% 
          cols_label(
            cran_summary = md(paste(web_image("https://cran.r-project.org/Rlogo.svg",
                                                      height = "18px; padding-top:0px !important"),
                                        "CRAN Downloads")),
            gh_summary = md(paste(web_image("https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
                                                    height = "25px; padding-top:0px !important"),
                                      "Github Stars"))
          ) %>% 
          opt_table_lines() %>% 
          tab_header(
            title = "Summary Statistics",
            subtitle = paste0("{", r$repo, "}")
          ) %>% 
          tab_footnote("In case of ties, only the first value is shown", locations = cells_stub(rows = c("Most in a day")))
      })
    }
  )
  
}


