#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
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
source('findParkrunUKplusdistance.R')
# 
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
       
        data <- reactive({
                req(input$postcodeId)

                all_parkruns <- findParkrunUKplusdistance(input$postcodeId)
                if (input$inputId=="All") {
                        all_parkruns[order(all_parkruns[,6]),]
                }
                else
                {
                parkrun_order <- all_parkruns[which(substring(all_parkruns[,1],1,1)==input$inputId),]
                parkrun_order[order(parkrun_order[,6]),]
                }
                })
                output$selectedParkruns <- renderDataTable((data()))

        })

