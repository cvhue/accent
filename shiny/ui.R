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
                     "Lien" = "lien"))),

  
  # Begin main panel
  mainPanel(
    tabsetPanel(
      tabPanel("Therapist", plotOutput("plot")), 
      tabPanel("Patient", tableOutput("table")),
      tabPanel("Summary", verbatimTextOutput("summary"))
    )
  )
  # End main panel
  
))