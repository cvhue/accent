library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #

  
  # 1. check data
  
  # 2. make model
  
  # 3. 
  
  source("schedule.R")
  
  output$summary <- renderTable({
    accent
  })
  
  output$plotT <- renderPlot({
    print(schedule(accent))
  })
  
  
  output$plotP <- renderPlot({
    print(schedule(accent,reverse= TRUE))
    
  })
  
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
})