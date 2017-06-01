#Load Libraries
library(dplyr)
library(plotly)

#import consupmtion data
use.data <- read.csv('data/clean/use_clean.csv', stringsAsFactors = FALSE)

#Create function that takes in a data set, state and year and returns 
#a pie chart with info regaurding energy consumption in given state and year
BuildPieChart <- function(data, state = 'Overall', year = 2014){
  #put an x on the year
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
  state.data$Description <- gsub(' total consumption', '', state.data$Description)
  state.data$Description <- gsub(' total consumed', '', state.data$Description)
  state.data$Description <- gsub(' (including supplemental gaseous fuels)', '', state.data$Description)
  state.data$Description <- gsub(' (i.e., sold)', '', state.data$Description)
  state.data$Description <- gsub('.', '', state.data$Description)
  state.data$Description <- gsub(',', '', state.data$Description)
  
  #Filter data to get only whats needed for pie chart
  state.data <- select(state.data, use, Description) %>% filter(!grepl('excluding', Description)) %>% 
    filter(Description != 'Total energy consumption.') %>% filter(Description != 'Total electrical system energy losses.')%>% 
    mutate(year_dif = use)
  
  #filter data so that pie chart only shows energy types that make up
  #1.5 percent or higher of total state energy consumption
  percent.of.total.btu <- sum(state.data[,'use'], na.rm = TRUE)*.01
  state.data <- filter(state.data, year_dif > percent.of.total.btu)
  
  #cretae pie chart using values from given year and state
  #to show which energy types the state used
   p <- plot_ly(state.data, labels = ~Description, values = ~year_dif, type = 'pie',
          textposition = 'inside',
          textinfo = 'label+percent',
          showlegend =FALSE
  ) %>% 
    layout(title= paste0(state, ' Energy Consumption by Energy Type in ', substr(year, 2, 5)),
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           autosize = FALSE, width = 800, height = 800
    )
  
   return(p)
}
 




