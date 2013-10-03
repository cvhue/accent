library(thinkdata.accent)
require(RJSONIO)

setLogging("info", logger="dateLogger")


### SPLAN JSON
test.json <- system.file(package="thinkdata.accent", "examples", "splan_data.json")
input <- readSplanJSONInput(splanJSON=test.json)

### SIMPLE JSON
# test.json <- system.file(package="thinkdata.accent", "examples", "data.json")
# input <- readSimpleJSONModelInput(jsonFile=test.json) 

### EXCEL INPUT
test.xls <- system.file(package="thinkdata.accent", "examples", "data.xls")
input <- readXLSModelInput(xlsFile=test.xls) 

# str(input)
# str(splaninput)
# cat(toJSON(input))

solution <- optimizeAccentModel(input)

therapistList = c("All", unique(input$therapists$therapist))
patientList <- c("All", unique(input$patients$patient))
