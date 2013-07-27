library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Accent holiday scheduling"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    selectInput("variable", "Select physician:",
                list("Jan" = "jan", 
                     "Stan" = "stan", 
                     "Lien" = "lien")),
    
    
    submitButton("Schedule"),
    
    conditionalPanel(
      condition = "Patient.visible == true",
      checkboxInput("headonly", "Only use first 1000 rows"))
    
    ),
  

  
  # Begin main panel
  mainPanel(
    tabsetPanel(
      tabPanel("Therapist", plotOutput("plotT"),    downloadButton('downloadData', 'Download')), 
      tabPanel("Patient", plotOutput("plotP")),
      tabPanel("Summary", tableOutput("summary"))
    )
  )
  # End main panel
  
))