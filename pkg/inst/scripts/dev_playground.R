require(thinkdata.accent)
runShinyAccent()


test.json <- system.file(package="thinkdata.accent", "examples", "splan_data.json")
input <- readSplanJSONInput(jsonFile=test.json)
solution <- optimizeAccentModel(input)

drawSchedule(solution, type="therapist")


startService()
req <- getLastRequest()