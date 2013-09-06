# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {
  
  therapistInput <- reactive({
    input$sel_ther
  })
  
  patientInput <- reactive({
    input$sel_pat
  })
  
  # display solution dataframe from accent
  output$summary <- renderTable({
    solution$data
  })

  
  output$plotT <- renderPlot({

    if(therapistInput() == "All"){
      print(drawSchedule(solution, type="therapist"))
    } else {
      print(drawSchedule(solution, type="therapist", subset=therapistInput()))
    }
    
  })
  
  
  output$plotP <- renderPlot({
    
    if(patientInput() == "All"){
      print(drawSchedule(solution, type="patient"))
    } else {
      print(drawSchedule(solution, type="patient", subset=patientInput()))
    }
    
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
})