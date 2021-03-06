#Load Libraries
library(dplyr)
library(plotly)

#import consupmtion data
use.data <- read.csv('data/clean/use_clean.csv', stringsAsFactors = FALSE)


ConsumptionData <- function(data, state = 'Overall', year = 2014) {
  year <- toString(year)
  year <- paste0('X',year)
  
  data <- select_(data, year, ~Description, ~StateName) %>% mutate_(use = year)
  
  #Filter data to select given state and year, exclude and  
  #'Total energy consumption observation'
  if (state == "Overall") {
    state.data <- group_by(data, Description) %>% summarize(use = sum(use))
  } else {
    state.data <- filter(data, StateName == state)
  }
  
  #Take end phrases off of descriptions to make labels on pie chart more clear
  state.data$Description <- gsub('total consumption', '', state.data$Description)
  state.data$Description <- gsub('total consumed', '', state.data$Description)
  state.data$Description <- gsub('\\(including supplemental gaseous fuels\\)', '', state.data$Description)
  state.data$Description <- gsub('\\(i.e., sold\\)', '', state.data$Description)
  state.data$Description <- gsub('\\.', '', state.data$Description)
  state.data$Description <- gsub(',', '', state.data$Description)
  state.data$Description <- trimws(state.data$Description)
  
  #Filter data to get only whats needed for pie chart
  state.data <- select(state.data, Description, use) %>% filter(!grepl('excluding', Description)) %>% 
                filter(Description != 'Total energy consumption',
                       Description != 'Total electrical system energy losses',
                       Description != 'Asphalt and road oil aviation gasoline kerosene lubricants and other petroleum products',
                       Description != 'Other petroleum products',
                       Description != 'Asphalt and road oil',
                       Description != 'Aviation gasoline',
                       Description != 'Distillate fuel oil',
                       Description != 'Jet fuel',
                       Description != 'Kerosene-type jet fuel',
                       Description != 'Kerosene',
                       Description != 'LPG',
                       Description != 'Lubricants',
                       Description != 'Motor gasoline',
                       Description != 'Petroleum coke',
                       Description != 'Residual fuel oil',
                       Description != 'Electricity',
                       Description != 'Naphtha-type jet fuel',
                       Description != 'Fossil fuels',
                       Description != 'Renewable energy',
                       Description != 'Supplemental gaseous fuels')
  
  return(state.data)
}

#Create function that takes in a data set, state and year and returns 
#a pie chart with info regaurding energy consumption in given state and year
BuildPieChart <- function(data, state = 'Overall', year = 2014){
  #put an x on the year
  state.data <- ConsumptionData(data, state, year)
  
  #filter data so that pie chart only shows energy types that make up
  #1.5 percent or higher of total state energy consumption
  #percent.of.total.btu <- sum(state.data[,'use'], na.rm = TRUE)*.01
  #state.data <- filter(state.data, use > percent.of.total.btu)
  
  #cretae pie chart using values from given year and state
  #to show which energy types the state used
   p <- plot_ly(state.data, labels = ~Description, values = ~use, type = 'pie',
          textinfo = 'label+percent',
          showlegend = FALSE,
          insidetextfont = list(color = '#FFFFFF'),
          hoverinfo = 'text',
          text = ~paste(use, 'billion Btu')
  ) %>% 
    layout(title = paste0(state, ' Energy Consumption by Energy Type in ', year),
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           autosize = FALSE, width = 1000, height = 800, margin = list(r = 200, b = 200)
    )
  
   return(p)
}
 




