
library(shiny)
library(dplyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("EIA State Energy Data"),
  
  #add overview
  
  tabsetPanel(
    tabPanel("State Energy Consumption",
             sidebarLayout(
               sidebarPanel(
                 selectInput("state",
                             label = "Choose a state: ",
                             choices = c("Alabama (AL)", "Arkansas (AR)"))
               ),
               
               mainPanel())),
    
    tabPanel("Clean Energy",
             sidebarLayout(
               sidebarPanel(),
               
               mainPanel())),
    
    tabPanel("Expenditures",
             sidebarLayout(
               sidebarPanel(),
               
               mainPanel()))
  )
))
