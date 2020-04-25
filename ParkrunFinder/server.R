#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        all_parkruns <- findParkrunUK()
        data <- reactive({
        # selection <- which(substring(all_parkruns[,1],1,1)==input$inputId)       
        all_parkruns[which(substring(all_parkruns[,1],1,1)==input$inputId),]})
        output$selectedParkruns <- renderDataTable((data()))
  # output$distPlot <- renderPlot({

                    
    # # generate bins based on input$bins from ui.R
    # x    <- faithful[, 2] 
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    # # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # 
  })
  
