library(thinkdata.accent)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  
  # Application title
  headerPanel("Accent holiday scheduling"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    tags$head(tags$style(type='text/css', ".span4 { max-width: 250px; }") ),
    
    img(src="http://www.revaccent.be/images/Logo%20ACCENT%20klein.jpg",height=164,width=164),
    
    h4("Scheduling"),
    sliderInput("preference", "Preference:", 
                min = 0, max = 1, value = 0.5, step= 0.1,animate=TRUE),

    h4("Vizualisation"),
    conditionalPanel(
      condition = "input.tabs == 'Therapist'",
      selectInput("sel_ther", "Select therapist:",
                  therapistList)
    ),
    
    conditionalPanel(
      condition = "input.tabs == 'Patient'",
      selectInput("sel_pat", "Select patient:",
                  patientList)
    ) 
    
    
  ),
  

  
   # submitButton("Schedule"),

    
  

  
  # Begin main panel
  mainPanel(
    tabsetPanel(
      id="tabs",
      tabPanel("Therapist", plotOutput("plotT")), 
      tabPanel("Patient", plotOutput("plotP")),
      tabPanel("Summary", 
               h4("Therapist objectives:"),
               textOutput("ther_obj"),
               h4("Patient objectives:"),
               textOutput("pat_obj"),
               h4("Assignments:"),
               tableOutput("summary"))
    )
  )
  # End main panel
  
))