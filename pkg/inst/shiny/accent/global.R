library(thinkdata.accent)

setLogging("info", logger="dateLogger")

# Read model and optimize solution
input <- randomAccentModelInput()
solution <- optimizeAccentModel(input)

therapistList = c("All", unique(input$therapists$therapist))
patientList <- c("All", unique(input$patients$patient))
