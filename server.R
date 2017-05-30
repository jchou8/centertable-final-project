library(plotly)
library(shiny)

source('./scripts/Production.R')
source('./scripts/BuildPieChart.R')

energy.prod <- read.csv("./data/clean/prod_clean.csv", stringsAsFactors = FALSE)
energy.use <- read.csv("./data/clean/use_clean.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  
  # Production graph
  output$production.over.time <- renderPlotly(ProductionPlot(energy.prod, input$prod.state, input$prod.year.range[1], input$prod.year.range[2]))
  output$production.table <- renderTable(ProductionData(energy.prod, input$prod.state, input$prod.year.range[1], input$prod.year.range[2]))     
  
  output$distinct.energy.type <- renderPlotly(BuildPieChart(energy.use, input$distinct.state, input$distinct.year))
})
