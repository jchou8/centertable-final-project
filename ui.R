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
    
  tabPanel("Production",
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
    
  tabPanel("Consumption",
    titlePanel('Energy Consumption By Energy Type'),
    h3("Pie Chart Overview"),
    p("The following pie chart is intended to give an idea of which energy types a given state is 
                      consuming the most/least of. All units are in billions of BTUs. The chart can be filtered by 
                      year to see how a state has changed which energy it is consuming over time. 
                      Observe how certain energy types have emerged and diminished between various states."),
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = 'distinct.state',
                      label = "State:",
                      choices = c(state.name),
                      selected = "Alabama"
                      
          ),
        sliderInput(inputId = 'distinct.year',
                    label = 'Years',
                    min = 1960,
                    max = 2014,
                    value = 2014,
                    sep = ''
        )
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel('Chart', plotlyOutput("distinct.energy.type")),
          tabPanel('Table', 'placeholder')
        )
      )
     )
    )
  )
)
