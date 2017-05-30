# Include libraries
library(shiny)
library(dplyr)
library(plotly)

# Get list of state names for use in widgets
states <- read.csv("./data/state_codes.csv", stringsAsFactors = FALSE)
state.names <- states$StateName[1:51]

# Set up UI
shinyUI(navbarPage("EIA State Energy Data", theme = "bootstrap.css",
                   
  # Overview tab with information on the project
  tabPanel("Overview",
    titlePanel('Project Overview'),
    h3("The Report"),
    p("This report provides a broad overview of energy consumption, production, and expenditure data. eh"),
    h3("Data"),
    p("The dataset we are working with contains data on energy consumption, production, and expenditures from 1960 to 2014. 
       This data was collected by the US Energy Information Administration, a part of the US Department of Energy, 
       and is publicly available here: ",
      a("State Energy Data System", href = "https://www.eia.gov/state/seds/seds-data-complete.php?sid=US#CompleteDataFile")
    ),
    
    h3("Project Creators"),
    tags$ul(
      tags$li("Joseph Chou"), 
      tags$li("Felicia Dunscomb"), 
      tags$li("Samuel Perng"),
      tags$li("Andrew Roger")
    )
  ),
    
  tabPanel("Energy by State",
    sidebarLayout(
      sidebarPanel(
        selectInput("state",
          label = "Choose a state: ",
           choices = state.names
        )
      ),     
      mainPanel()
    )
  ),
    
  tabPanel("Energy Production By Type",
    titlePanel('Energy Production By Type'),
    p("This chart displays energy production for each year, separated into four major categories: coal, crude oil, natural gas, and renewable. The data can be filtered down to a specific state and range of years."),
           
    sidebarLayout(
      sidebarPanel(
        
        selectInput('prod.state', label = 'State', choices = c("Overall", state.names), selected = "Overall"),
        sliderInput('prod.year.range', label = 'Years', min = 1960, max = 2014, value = c(1960, 2014), sep = "")
      ),
     
      mainPanel(
        tabsetPanel(
          tabPanel('Plot', plotlyOutput('production.over.time')),
          tabPanel('Table', tableOutput('production.table'))
        )
      )
    )
  ),
    
  tabPanel("Expenditures",
    sidebarLayout(
      sidebarPanel(),
      mainPanel()
    )
  )
))
