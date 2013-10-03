require(thinkdata.accent)
runShinyAccent()


test.json <- system.file(package="thinkdata.accent", "examples", "splan_data.json")
input <- readSplanJSONInput(splanJSON=test.json)
solution <- optimizeAccentModel(input)

drawSchedule(solution, type="therapist")


thinkdata.accent::startService()
req <- thinkdata.accent::getLastRequest()