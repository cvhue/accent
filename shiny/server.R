library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {

    
  
  # 1. check data
  
  # 2. make model
  
  # 3. 
  
  source("schedule.R")
  
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
    source("optimize.R")
    optimize()
    if(therapistInput() == "All") print(schedule(accent))
    else print(schedule(accent[accent$therapist == therapistInput(),]))
  })
  
  
  output$plotP <- renderPlot({
    if(patientInput() == "All") print(schedule(accent,reverse=TRUE))
    else print(schedule(accent[accent$patient == patientInput(),],reverse=TRUE))
  })
  
  
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
})