# include libraries
library(dplyr)
library(plotly)
library(tidyr)

# Read in data
# energy.prod <- read.csv("../data/clean/prod_clean.csv", stringsAsFactors = FALSE)


BuildScatter <- function(data,  state = 'USA', startYear = 1960, endYear = 2014) {
  # Reshape and clean the data
  energy.prod.clean <- data %>% gather(year, production, X1960:X2014, convert = TRUE) %>% 
    mutate(year = as.numeric(gsub("X", "", year))) %>% 
    filter(substr(MSN, 4, 4) != "C", substr(MSN, 2, 2) != "O") %>% 
    mutate(Description = gsub("[.]", "", Description),
           Description = gsub("\\(including lease condensate\\)", "", Description),
           Description = gsub("production", "", Description),
           Description = gsub("marketed", "", Description),
           Description = gsub("total", "", Description),
           Description = gsub(" ", "", Description)) %>%
    filter(Description != "Total energy") %>% 
    group_by(year, Description, StateName) %>% 
    summarize(production = sum(as.numeric(production)))
    
    if (state == "USA") {
      energy.prod.filtered <- energy.prod.clean %>% group_by(year, Description) %>% summarize(production = sum(production))
    } else {
      energy.prod.filtered <- energy.prod.clean %>% filter(StateName == state) %>% select(-StateName)
    }
  
    energy.prod.filtered <- energy.prod.filtered %>% filter(year >= startYear, year <= endYear) %>% spread(Description, production)
    
    prod.plot <- plot_ly(energy.prod.filtered, x = ~year, type = 'scatter', mode = 'line+markers',
                         y = ~Coal, name = 'Coal', mode = 'line+markers', hoverinfo = 'text',
                         text = ~paste("<b>Coal</b>", "</br>Year: ", year, "</br>Production: ", Coal, " billion BTU")) %>%
      add_trace(y = ~Crudeoil, name = 'Crude oil', mode = 'line+markers', hoverinfo = 'text',
                text = ~paste("<b>Crude oil</b>", "</br>Year: ", year, "</br>Production: ", Crudeoil, " billion BTU")) %>%
      add_trace(y = ~Naturalgas, name = 'Natural gas', mode = 'line+markers', hoverinfo = 'text',
                text = ~paste("<b>Natural gas</b>", "</br>Year: ", year, "</br>Production: ", Naturalgas, " billion BTU")) %>%
      add_trace(y = ~Renewableenergy, name = 'Renewable energy', mode = 'line+markers', hoverinfo = 'text',
                text = ~paste("<b>Renewable energy</b>", "</br>Year: ", year, "</br>Production: ", Renewableenergy, " billion BTU")) %>%
      layout(title = paste(state, "Energy Production by Type"),
             xaxis = list(title = "Year"),
             yaxis = list (title = "Energy Produced (Billion BTU)"))
    
    return(prod.plot)
}




