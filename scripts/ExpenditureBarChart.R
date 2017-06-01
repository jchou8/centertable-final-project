library(plotly)
library(dplyr)
library(shiny)

TotalBarChart <- function(data, energy.type, year) {
  
  # the input energy choices
  names <- c("Total Energy", "Asphalt and Road Oil", "Aviation gasoline",                 
    "Coal", "Distillate fuel", "Fuel ethanol, excluding denaturant",
    "Electricity", "Jet fuel", "Kerosene",                          
    "LPG", "Motor gasoline", "Natural gas",                       
    "All petroleum products", "Petroleum coke", "Residual fuel oil ",                
    "Wood and waste")
  
  # the input energy choice values given
  name.code <- c("TET", "ART", "AVT", "CLT", "DFT", "EMT", "EST", "JFT", "KST", "LGT", 
                 "MGT", "NGT", "PAT", "PCT", "RFT", "WWT")
  # data frame that associates the energy names and its codes.
  prop.name <- data.frame(names, name.code)
  
  #Makes year easier to use
  year <- paste(year)
  
  #Filters data to include needed information and the appropriate year
  edited.data <- data %>% select(StateName, MSN, Description, chart.year = ends_with(year)) %>%
                  filter(StateName != "United States")
  
  #Sort and filters data on whether the overall energy is wanted.
  if ("TET" %in% energy.type) { #change to "All" if necessary
    edited.data <- edited.data %>% filter(Description == "Total energy expenditures.")
  } else {
    edited.data <- edited.data %>% filter(MSN %in% paste0(energy.type, "CV"))
  }
  
  # Sort to see if it has multiple energies from the selection or that it does not contain Total Energy
  if (length(energy.type) > 1 & !("TET" %in% energy.type)){
    
    # Creates a data frame for the bar chart
    bar.data <- data.frame(StateName = c(unique(edited.data$StateName)))
    
    # Goes through each energy type and makes it a column in bar data.
    for (energy in energy.type) {
      temp.data <- edited.data %>% filter(MSN %in% paste0(energy, "CV"))
      energy.data <- data.frame(c(unique(edited.data$StateName)), c(temp.data$chart.year))
      colnames(energy.data) <- c("StateName", energy)
      bar.data <- right_join(bar.data, energy.data)
    }
    
    # Initialize the bar chart
    p <- plot_ly(type = "bar")
    
    # loops through each type of energy given
    for (energy in energy.type) {
      temp.data <- bar.data %>% select_(~StateName, energy) %>% mutate_(expense = energy)
      p <- p %>% add_trace(data = temp.data, x = ~StateName, y = ~expense, hoverinfo = 'text',
                           hovertext = ~paste0("State: ", StateName, "<br>$", expense,"M"),
                           name = prop.name$names[name.code == energy])
    }
    
    # adds the layout to the plot
    p <- p %>% layout(title = paste("Selected Energies by State, in", year), 
                      barmode = "stack",
                      xaxis = list(title = "State"),
                      yaxis = list(title = "Expenditures (Million Dollars)"), margin = c(b = 300))
  } else {
    # Creates a bar chart of a single energy
    energy.type <- energy.type[1] # meant to set any thing that has TET to the only one in the chart
    p <- plot_ly(edited.data,
                 x = ~StateName,
                 y = ~chart.year,
                 type = "bar",
                 hovertext = ~paste0("State: ", StateName, "<br>$", chart.year,"M")) %>% 
      layout(title = paste(prop.name$names[name.code == energy.type], "by State, in", year),
             xaxis = list(title = "State"),
             yaxis = list(title = paste("Expenditures (Million Dollars)")),
             margin = c(b = 300))
  }
  
  return(p)
}


