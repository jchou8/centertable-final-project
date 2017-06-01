# Include libraries
library(shiny)
library(dplyr)
library(plotly)

# Get list of state names for use in widgets
states <- read.csv("./data/state_codes.csv", stringsAsFactors = FALSE)
state.names <- states$StateName[1:51]
energy.types <- c("Total Energy", "Asphalt and Road Oil", "Aviation gasoline",                 
                 "Coal", "Distillate fuel", "Fuel ethanol, excluding denaturant",
                 "Electricity", "Jet fuel", "Kerosene",                          
                 "LPG", "Motor gasoline", "Natural gas",                       
                 "All petroleum products", "Petroleum coke", "Residual fuel oil ",                
                 "Wood and waste")
energy.codes <- c("TET", "ART", "AVT", "CLT", "DFT", "EMT", "EST", "JFT", "KST", "LGT", 
                  "MGT", "NGT", "PAT", "PCT", "RFT", "WWT")

# Set up UI
shinyUI(navbarPage("EIA State Energy Data", theme = "bootstrap.css",
                   
  # Overview tab with information on the project
  tabPanel("Overview",
    titlePanel('Project Overview'),
    h3("The Report"),
    p("This report provides a broad overview of energy consumption, production, and expenditure data.
        The intention of this report is to educate the general public on how our nation's energy consumption,
        production, and expenditure has changed over time. Our primary audience is anyone who is interested the
        environment, or our nations energy overview. In addition anyone who is interested in a distcint type
        of energy can track how that energy's usage has changed over time. "),
    h3("Data"),
    p("The dataset we are working with contains data on energy consumption, production, and expenditures from 1960 to 2014. 
       This data was collected by the US Energy Information Administration, a part of the US Department of Energy, 
       and is publicly available here: ",
      a("State Energy Data System", href = "https://www.eia.gov/state/seds/seds-data-complete.php?sid=US#CompleteDataFile")
    ),
    h3("Structure"),
    p("We designed our application to be multiple visauls that allowed users to better understand the change
        expenditure in the U.S.. Each visual allows users to explore differernt apects our nations energy
        history. Each interactive visual can be used to answer unique energy questions."),
    
    h3("Project Creators"),
    tags$ul(
      tags$li("Joseph Chou"), 
      tags$li("Felicia Dunscomb"), 
      tags$li("Samuel Perng"),
      tags$li("Andrew Roger")
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
  
  tabPanel("Expenditures",
    titlePanel('Energy Expenditures by State and Energy Type'),
    h3("Bar Chart Overview"),
    p("This bar chart shows the differences between each state's expenditures.  This allows the user to see
      which states pay the most for a certain type of energy.  Selecting the different energy types (select two max)
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
    )
  )
  )
)
