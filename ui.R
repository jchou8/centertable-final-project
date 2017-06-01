# Include libraries
library(shiny)
library(dplyr)
library(plotly)

# Get list of state names for use in widgets
states <- read.csv("./data/state_codes.csv", stringsAsFactors = FALSE)
state.names <- states$StateName[1:51]
energy.types <- c("Total Energy", "Asphalt and road oil", "Aviation gasoline",                 
                  "Coal", "Distillate fuel", "Fuel ethanol",
                  "Electricity", "Jet fuel", "Kerosene",                          
                  "Liquefied petroleum gases", "Motor gasoline", "Natural gas", "Petroleum coke", "Residual fuel oil",                
                  "Wood and waste")
energy.codes <- c("TET", "ART", "AVT", "CLT", "DFT", "EMT", "EST", "JFT", "KST", "LGT", "MGT", "NGT", "PCT", "RFT", "WWT")

# Set up UI
shinyUI(navbarPage("EIA State Energy Data", theme = "bootstrap.css",
                   
  # Overview tab with information on the project
  tabPanel("Overview",
    titlePanel('Project Overview'),
    p("The report provides a broad overview of energy consumption, production, and expenditure data.
        The purpose of this report is to educate the general public on how our nation's energy consumption,
        production, and expenditure has changed over time, with an emphasis on renewable vs. nonrenewable energy.
        We believe that people should be more concerned with the state of the environment and hope that our report
        will motivate people to consider the importance of renewable energy"),
    h3("Data"),
    p("The dataset we are working with contains data on energy consumption, production, and expenditures from 1960 to 2014. 
       This data was collected by the US Energy Information Administration, a part of the US Department of Energy, 
       and is publicly available here: ",
      a("State Energy Data System", href = "https://www.eia.gov/state/seds/seds-data-complete.php?sid=US#CompleteDataFile")
    ),
    h3("Structure"),
    p("The first tab contains a simple overview map that shows how energy trends vary between states.
       The next three tabs contains different visualizations that explores a different aspect of the data - 
       production, consumption, or expenditures. Each visualization allows the data to be considered at either the
       nationwide level or a per-state level at various points in our nation's history."),
    
    h3("Project Creators"),
    tags$ul(
      tags$li("Joseph Chou"), 
      tags$li("Felicia Dunscomb"), 
      tags$li("Samuel Perng"),
      tags$li("Andrew Roger")
    )
  ),
  
  tabPanel("Energy by State",
    titlePanel("Production, Consumption, and Expenditure by State"),
    p("This map shows production, consumption, or expenditure data by State for a given year. 
       The dataset can be selected with the drop down menu, and the year can be adjusted with the slider.
        Hovering over a state will display detailed comparison information."),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = 'dataset',
          label = 'Dataset',
          choices = c('Production', 'Consumption', 'Expenditure'),
          selected = 'Production'
        ),
             
        sliderInput(inputId = 'select.year',
          label = 'Year',
          min = 1970,
          max = 2014,
          value = 2014,
          sep = ''
        )
      ),
           
      mainPanel(
        plotlyOutput('map')
      )
    )
  ),
  
  tabPanel("Production",
    titlePanel('Energy Production By Type'),
    p("This chart displays energy production over time, separated into four major categories: coal, crude oil, natural gas, and renewable. The data can be filtered down to a specific state and range of years."),
           
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
    p("The following pie chart is intended to give an idea of which energy types a given state is 
       consuming the most/least of. All units are in billions of BTUs. The chart can be filtered by 
       year to see how a state has changed which energy it is consuming over time. 
       Observe how certain energy types have emerged and diminished between various states."),
    p("We have concluded from our chart and analysis that overall our country is beggining to find new reneawble 
       energy sources like geothermal, solar, and wind energy. However, we are not growing the use of these sources
       at a fast pace. It is clear some states have made a conceded effort to boost renewable energy consumption, while
       some states, like Texas, have made no effort. The states that have been most succesful in consuming more
       renewable energy are states that have ramped up consumption of one distinct type of renewable enery."),
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = 'distinct.state',
                      label = "State",
                      choices = c("Overall", state.names),
                      selected = "Overall"
                      
          ),
        sliderInput(inputId = 'distinct.year',
                    label = 'Year',
                    min = 1960,
                    max = 2014,
                    value = 2014,
                    sep = ''
        )
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel('Chart', plotlyOutput("distinct.energy.type")),
          tabPanel('Table', tableOutput('consumption.table'))
        )
      )
     )
    ),
  
  tabPanel("Expenditures",
    titlePanel('Energy Expenditures by State and Energy Type'),
    p("This bar chart shows the differences between each state's expenditures. This allows the user to see
      which states pay the most for a certain type of energy.  Selecting the different energy types
      will present the user with a stacked bar chart allowing the user to compare which energy the state spends more on.
      The year slider will show the corresponding plot with the data from that year."),
    
    sidebarLayout(
      sidebarPanel(
        # checkbox input for energy type
        checkboxGroupInput("energy", 'Energy Types',
                           choiceNames = energy.types,
                           choiceValues = energy.codes,
                           selected = energy.codes[-1]),
        # sliderInput for year
        sliderInput("year",
                    label = "Year",
                    min = 1960,
                    max = 2014,
                    value = 2014,
                    sep = '')
        
      ),
      
      # displays barplot
      mainPanel(
        plotlyOutput("bar", height = "600px")
      )
    ),
    
    p("Note: after 1992, fuel ethanol data is incuded in motor gasoline data.")
  )
  )
)
