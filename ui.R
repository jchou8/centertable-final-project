
library(shiny)
library(dplyr)

states <- read.csv("./data/state_codes.csv", stringsAsFactors = FALSE)
state.names <- states$StateName[1:51]

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "bootstrap.css",
  
  titlePanel("EIA State Energy Data"),
  
  #add overview
  
  tabsetPanel(
    tabPanel("Overview",
               titlePanel('Project Overview'),
               p("This is placeholder text until I figure out how to do things")
             ),
    
    tabPanel("State Energy Consumption",
             sidebarLayout(
               sidebarPanel(
                 selectInput("state",
                             label = "Choose a state: ",
                             choices = c("Alabama (AL)", "Arkansas (AR)"))
               ),
               
               mainPanel())),
    
    tabPanel("Energy Production By Type",
             titlePanel('Energy Production By Type'),
             p("This is placeholder text alsdkfjksd"),
             
             sidebarLayout(
               sidebarPanel(
                 selectInput('prod.state', label = 'State', choices = c("Overall", state.names), selected = "Overall"),
                 sliderInput('prod.year.range', label = 'Years', min = 1960, max = 2014, value = c(1960, 2014), sep = "")
               ),
               
               mainPanel(
                 plotlyOutput('production.over.time')
               )
             )
    ),
    
    tabPanel("Expenditures",
             sidebarLayout(
               sidebarPanel(),
               
               mainPanel()))
  )
))
