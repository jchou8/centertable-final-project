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
        will motivate people to consider the importance of renewable energy and our planet's future."),
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
       nationwide level or a per-state level at various points in our nation's history. Above each chart is an overview
       describing the chart and its features, along with the conclusions that we have come to."),
    
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
    p("This chart displays energy production over time, separated into four major categories: 
      coal, crude oil, natural gas, and renewable. The data can be filtered down to a specific state and range of years."),
    
    p("From this chart, we can see that renewable energy production has been slowly growing over the past 50 years.
       However, non-renewable sources still make up an overwhelming majority of our energy production, 
       and both crude oil and natural gas production have sharply increased recently. 
       For example, starting around 2010, natural gas energy production skyrocketed in Pennsylvania and Arkanasas, 
       and crude oil production skyrocketed in North Dakota and Texas.
       Despite advances in renewable energy, it seems that it is currently not growing fast enough to keep up with the 
       overall increased demand for energy, so it is imperative that we continue to push for advances in renewable and clean energy."),
           
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
    p("We have concluded from our chart and analysis that overall our country is beginning to find new renewable 
       energy sources like geothermal, solar, and wind energy. However, we are not growing the use of these sources
       at a fast pace. It is clear some states have made a concerted effort to boost renewable energy consumption, while
       some states, have made less progress. The states that have been most succesful in consuming more
       renewable, like Washington, Maine, and Idaho, are states that have specifically ramped up consumption of one 
       distinct type of renewable energy."),
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
    p("This chart illustrates how there are two leading states that pay the most for overall energy, Texas and California. 
      One of these two states seems to dominate each of the categories in the more recent years of the data. This could 
      possibly be attributed to the large population of each state and the possible energy demands that they may have. 
      Following this logic, the idea that New York may also be a leading state comes up. Although it is one of the top three states in the early seventies,
      the decline of its energy expenditures are shown over the years.  Following this trend, the third leading state
      seems to fluctuate between New York and Florida.  This could possibly mean that Florida will overtake New York's energy 
      expenditures in a few more years."),
    p("Both Motor Gasoline and Electricity have been going up over the years between the 1970s to the 2000s. Even as other energy
      types rise, the expenditures on Motor Gasoline and Electricity seem to be growing at a constant rate in terms of expenditure. This is most 
      likely due to the wide use of vehicles and electricity in every single state. The more frequent use of cars and other motor vehicles 
      will increase this expenditure in the future. Although this trend is not currently present in the data, the growing use of smart
      vehicles that run off of electricity instead of gasoline could change the outcome of the graphs further in the future. 
      Since electricity is strongly interwoven into US society and infrastructure, the likelihood of electricity expenditures going down is close to none. 
      This is shown in the upward trend of Electricity in the bar charts over all the years."),
    
    sidebarLayout(
      sidebarPanel(
        # checkbox input for energy type
        checkboxGroupInput("energy", 'Energy Types',
                           choiceNames = energy.types,
                           choiceValues = energy.codes,
                           selected = c("DFT", "EST", "JFT", "LGT", "MGT", "NGT")),
        # sliderInput for year
        sliderInput("year",
                    label = "Year",
                    min = 1970,
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
