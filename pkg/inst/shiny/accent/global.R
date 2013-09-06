library(thinkdata.accent)

setLogging("info", logger="dateLogger")

# Read model and optimize solution
# input <- randomAccentModelInput()

test.json <- system.file(package="thinkdata.accent", "examples", "data.json")
input <- readSimpleJSONModelInput(jsonFile=test.json) 
str(input)
cat(toJSON(input))
solution <- optimizeAccentModel(input)

therapistList = c("All", unique(input$therapists$therapist))
patientList <- c("All", unique(input$patients$patient))
