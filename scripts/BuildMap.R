
#Map of US with production data initially shown and slider that changes the year
#options to switch production and expenditures
library(plotly)
library(dplyr)

map.data <- function(data, year) {
  year <- toString(year)
  year <- paste0('X', year)
  
  #filtering data to a df with only state codes, and total consumption for each
  #state that specific year
  
  #https://stackoverflow.com/questions/10276092/to-find-whether-a-column-exists-in-data-frame-or-not
  if("StateCode" %in% colnames(data)) {
    #http://rprogramming.net/rename-columns-in-r/
    colnames(data)[colnames(data)=="StateCode"] <- "State"
  }
  
  map.data <- data %>% select_(~State, year) %>% na.omit() %>% 
    #could not select year column otherwise for some reason
    mutate_(year = year) %>% select(State, year) %>% 
    group_by(State) %>% summarise(total = sum(year)) %>% 
    filter(State != "US")
}


#function to build map
Build.Map <- function(data, first.year = 1970, dataset) {
  mapping.data <- map.data(data, first.year)
  cumulative <- sum(mapping.data$total)
  avg <- median(mapping.data$total)
  
  # Set map geography and appearance
  map.geo <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showlakes = TRUE,
    lakecolor = toRGB('white')
  )
  
  # Set hover annotations
  hover.text <- paste0(mapping.data$State, '<br>', 'Percentage of Total: ', 
                       paste0(round(100*mapping.data$total / cumulative, 2), '%'),
                       '<br>', 'National median: ', paste0(round(100*avg / cumulative, 2), '%'))
  
  # Change legend depending on what's being mapped
  if (dataset == 'Expenditure') {
    color.title <- 'Million dollars'
  } else {
    color.title <- 'Billion Btu'
  }
  
  # Create the plot
  p <- plot_geo(mapping.data, locationmode = 'USA-states', width = 800, height = 600) %>% 
    add_trace(z = ~total, text = hover.text, locations = ~State, colors = "Blues") %>% 
    colorbar(title = color.title) %>% 
    layout(
      title = paste('USA Energy', dataset, 'Map', first.year),
      geo = map.geo
    )
  return(p)
}