
library(shiny)

source('./scripts/Production.R')
energy.prod <- read.csv("./data/clean/prod_clean.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  
  # Production graph
  output$production.over.time <- renderPlotly(ProductionPlot(energy.prod, input$prod.state, input$prod.year.range[1], input$prod.year.range[2]))     
})
