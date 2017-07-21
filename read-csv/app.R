#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   sidebarLayout(
     shiny::fileInput("datafile", 'Choose CSV File'),
      mainPanel(
         tableOutput("filetable_result")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  filedata_DM <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    read.csv(infile$datapath,header=FALSE)   
  })
  
  output$filetable_result <- renderTable(filedata_DM())
}

# Run the application 
shinyApp(ui = ui, server = server)

