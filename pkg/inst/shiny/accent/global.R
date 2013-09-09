library(thinkdata.accent)

setLogging("info", logger="dateLogger")

### RANDOM DATA
# Read model and optimize solution
# input <- randomAccentModelInput()

### SPLAN JSON
# test.json <- system.file(package="thinkdata.accent", "examples", "splan_data.json")
# input <- readSplanJSONInput(jsonFile=test.json)

### SIMPLE JSON
test.json <- system.file(package="thinkdata.accent", "examples", "data.json")
input <- readSimpleJSONModelInput(jsonFile=test.json) 

# str(input)
# str(splaninput)
# cat(toJSON(input))

solution <- optimizeAccentModel(input)

therapistList = c("All", unique(input$therapists$therapist))
patientList <- c("All", unique(input$patients$patient))
