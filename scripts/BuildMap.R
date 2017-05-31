#Map of US with consumption shown and slider that changes the year
#options to switch production and expenditures
library(plotly)
library(dplyr)

consumption <- read.csv('data/use_all_btu.csv', stringsAsFactors = FALSE)
expenditure <- read.csv('data/ex_all.csv', stringsAsFactors = FALSE)
production <- read.csv('data/prod_all.csv', stringsAsFactors = FALSE)



#function to build map
BuildMap <- function(data, first.year = 1960, last.year = 2014) {
  year <- toString(first.year)
  year <- paste0('X', year)
  
  #filtering data to a df with only state codes, and total consumption for each
  #state that specific year
  map.data <- data %>% select_(~State, year) %>% na.omit() %>% 
    #could not select year column otherwise for some reason
    mutate_(year = year) %>% select(State, year) %>% 
    group_by(State) %>% summarise(total.consumption = sum(year))
  
  
  #map geo
  map.geo <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showlakes = TRUE,
    lakecolor = toRGB('white')
  )
  
  hover.text <- paste0(map.data$State, '<br>', 'Total consumption in btu: ', map.data$total.consumption)
  
  p <- plot_geo(map.data, locationmode = 'USA-states') %>% 
    add_trace(
      z = ~total.consumption, text = hover.text, locations = ~State,
      color = ~total.consumption, colors = 'Purples'
    ) %>% 
    colorbar(title = 'BTU') %>% 
    layout(
      title = 'Test map',
      geo = map.geo
    )
  
}

BuildMap(consumption)
