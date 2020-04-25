#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("List of UK Parkrun locations"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
            selectInput("inputId", "Letter",  c("Choose one" = "", LETTERS), selected = NULL, multiple = FALSE,
                        selectize = TRUE, width = NULL, size = NULL)
       # sliderInput("bins",
       #             "Number of bins:",
       #             min = 1,
       #             max = 50,
       #             value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
            dataTableOutput("selectedParkruns")
       # plotOutput("distPlot")
    )
  )
))
