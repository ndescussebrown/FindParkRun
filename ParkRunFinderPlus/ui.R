#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# This app displays a list of ParkRun location within the UK and ranks them according to the distance from
# a particular postcode and enables selection of the ParkRun that start with a particular letter. The list of ParkRusn in the UK is scraped from 
# https://en.wikipedia.org/wiki/List_of_Parkruns_in_the_United_Kingdom. Before scraping I ensured I was
# authorised by using the paths_allowed function in the robotstxt package.
# paths_allowed(
# paths = "/wiki/List_of_Parkruns_in_the_United_Kingdom",
# domain = "https://en.wikipedia.org", 
# bot    = "*")

library(shiny)
library(shinycssloaders)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        
        # Application title
        titlePanel("List of UK Parkrun locations"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        
                        "Parkrun is a series of 5k runs held on Saturday mornings in areas of open space around the UK. They are open to all,
                        free, and are safe and easy to take part in. They are so popular than a phenomenon appeared in the form of the ParkRun
                        alphabet where participants try and run ParkRuns to cover all letters of the alphabet. This app is designed
                        to make it easier for them to find a nearby ParkRun starting by the letter of their choice!",
                        br(),br(),
                        strong("How to use the app:"), 
                        tags$ol(
                                tags$li(" Enter your postcode"), 
                                tags$li("Enter the letter of interest (if you want to return all ParkRuns then just select 'All')"), 
                                tags$li("Maximise the app window to ensure you can view the results that will appear on the right hand side."),
                                tags$li("Wait for about 10-15 seconds for the results to be returned"),
                                tags$li("Once the results are returned, you can filter them further by using the search
                        function at the top right hand side of the results table."),
                        tags$li("Please note that some towns will not have latitudes and longitudes associated with them in the original wikipedia page used for this app, making it impossible to calculate the distance from the user postcode. These ParkRuns locations are nevertheless returned at the bottom of the results table"),
                        tags$li("Please also note distances are calculated as as-the-crow-flies distances.")),
                        textInput("postcodeId","Enter your postcode:",value = "", width = NULL,
                                  placeholder = NULL),
                        selectInput("inputId", "Letter",  c("Choose one" = "", c("All",LETTERS)), selected = NULL, multiple = FALSE,
                                    selectize = TRUE, width = NULL, size = NULL),
                        
                        "\n\n Regions are:",
                        tags$ol(
                                tags$li("Channel Islands"), 
                                tags$li("East Midlands"), 
                                tags$li("East of England"),
                                tags$li("Greater London"),
                                tags$li("North East England"),
                                tags$li("North West England"),
                                tags$li("Northern Ireland"),
                                tags$li("Scotland"),
                                tags$li("South East England"),
                                tags$li("South West England"),
                                tags$li("Wales"),
                                tags$li("West Midlands"),
                                tags$li("Yorkshire and the Humber")
                                
                        )
                        
                ),
                
                # Show the list of ParkRuns requested
                mainPanel(
                        withSpinner(dataTableOutput("selectedParkruns"),color="#0dc5c1")
                )

        )
))
