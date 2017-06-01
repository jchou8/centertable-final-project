# include libraries
library(dplyr)
library(plotly)
library(tidyr)

# Read in data
# energy.prod <- read.csv("../data/clean/prod_clean.csv", stringsAsFactors = FALSE)

# Returns cleaned up data of energy production
ProductionData <- function(data, state = 'Overall', startYear = 1960, endYear = 2014) {
  # Reshape and clean data
  energy.prod.clean <- data %>% gather(year, production, X1960:X2014, convert = TRUE) %>% 
    mutate(year = as.numeric(gsub("X", "", year))) %>% 
    filter(substr(MSN, 4, 4) != "C", substr(MSN, 2, 2) != "O") %>% 
    mutate(Description = gsub("[.]", "", Description),
           Description = gsub(" \\(including lease condensate\\)", "", Description),
           Description = gsub(" production", "", Description),
           Description = gsub(" marketed", "", Description),
           Description = gsub(" total", "", Description),
           Description = gsub(" ", "_", Description)) %>%
    group_by(year, Description, StateName) %>% 
    summarize(production = sum(as.numeric(production)))
  
  # Filter data to specific state (or whole country)
  if (state == "Overall") {
    energy.prod.filtered <- energy.prod.clean %>% group_by(year, Description) %>% summarize(production = sum(production))
  } else {
    energy.prod.filtered <- energy.prod.clean %>% filter(StateName == state) %>% select(-StateName)
  }
  
  # Filter data to specified time range
  energy.prod.filtered <- energy.prod.filtered %>% filter(year >= startYear, year <= endYear) %>% spread(Description, production)
  
  return(energy.prod.filtered)
}

# Produces the line plot
ProductionPlot <- function(data,  state = 'Overall', startYear = 1960, endYear = 2014) {
    # Get cleaned data
    filtered <- ProductionData(data, state, startYear, endYear)  
  
    # Create plot
    prod.plot <- plot_ly(filtered, x = ~year, type = 'scatter', mode = 'line+markers',
                         y = ~Coal, name = 'Coal', mode = 'line+markers', hoverinfo = 'text',
                         text = ~paste("<b>Coal</b>", "</br>Year: ", year, "</br>Production: ", Coal, " billion Btu")) %>%
      add_trace(y = ~Crude_oil, name = 'Crude oil', mode = 'line+markers', hoverinfo = 'text',
                text = ~paste("<b>Crude oil</b>", "</br>Year: ", year, "</br>Production: ", Crude_oil, " billion Btu")) %>%
      add_trace(y = ~Natural_gas, name = 'Natural gas', mode = 'line+markers', hoverinfo = 'text',
                text = ~paste("<b>Natural gas</b>", "</br>Year: ", year, "</br>Production: ", Natural_gas, " billion Btu")) %>%
      add_trace(y = ~Renewable_energy, name = 'Renewable energy', mode = 'line+markers', hoverinfo = 'text',
                text = ~paste("<b>Renewable energy</b>", "</br>Year: ", year, "</br>Production: ", Renewable_energy, " billion Btu")) %>%
      layout(title = paste(state, "Energy Production by Type"),
             xaxis = list(title = "Year"),
             yaxis = list (title = "Energy Produced (Billion Btu)"))
    
    return(prod.plot)
}




