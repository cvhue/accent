library(shiny)
library(thinkdata.accent)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  # Read model and optimize solution
  test.file <- system.file(file.path("examples","data.xls"),package="thinkdata.accent")
  model <- readXLSModelInput(test.file)
  solution <- thinkdata.accent::optimize(model)
  solution.csv <- read.csv(solution$file)
  plot <- schedule(solution.csv)

  
  therapistInput <- reactive({
    input$sel_ther
  })
  
  patientInput <- reactive({
    input$sel_pat
  })
  
  # display dataframe from accent
  output$summary <- renderTable({
    accent
  })
  
  output$plotT <- renderPlot({

    if(therapistInput() == "All") print(schedule(solution.csv))
    else print(schedule(solution.csv[solution.csv$therapist == therapistInput(),]))
  })
  
  
  output$plotP <- renderPlot({
    if(patientInput() == "All") print(schedule(solution.csv,reverse=TRUE))
    else print(schedule(solution.csv[solution.csv$patient == patientInput(),],reverse=TRUE))
  })
  
  
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
})