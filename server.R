# include libraries
library(plotly)
library(shiny)

# Read in functions that build the visualizations
source('./scripts/Production.R')
source('./scripts/BuildPieChart.R')
source('./scripts/BuildMap.R')
source('./scripts/ExpenditureBarChart.R')

# Read in data
energy.prod <- read.csv("./data/clean/prod_clean.csv", stringsAsFactors = FALSE)
energy.use <- read.csv("./data/clean/use_clean.csv", stringsAsFactors = FALSE)
energy.expenditures <- read.csv("./data/clean/expense_clean.csv", stringsAsFactors = FALSE)

Consumption <- read.csv('./data/use_all_btu.csv', stringsAsFactors = FALSE)
Expenditure <- read.csv('./data/ex_all.csv', stringsAsFactors = FALSE)
Production <- read.csv('./data/prod_all.csv', stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  
  # Production graph
  output$production.over.time <- renderPlotly(ProductionPlot(energy.prod, input$prod.state, input$prod.year.range[1], input$prod.year.range[2]))
  output$production.table <- renderTable(ProductionData(energy.prod, input$prod.state, input$prod.year.range[1], input$prod.year.range[2]))     
  
  # Consumption pie chart
  output$distinct.energy.type <- renderPlotly(BuildPieChart(energy.use, input$distinct.state, input$distinct.year))
  output$consumption.table <- renderTable(ConsumptionData(energy.use, input$distinct.state, input$distinct.year))
  
  # Mp
  output$map <- renderPlotly(Build.Map(eval(parse(text = input$dataset)), input$select.year, input$dataset))
  
  # Expenditure bar chart
  output$bar <- renderPlotly(TotalBarChart(energy.expenditures, input$energy, input$year))
})
