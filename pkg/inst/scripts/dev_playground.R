require(thinkdata.accent)
runShinyAccent()


test.json <- system.file(package="thinkdata.accent", "examples", "splan_data.json")
input <- readSplanJSONInput(splanJSON=test.json)
solution <- optimizeAccentModel(input)

drawSchedule(solution, type="patient", detail="D")


thinkdata.accent::startService()
req <- thinkdata.accent::getLastRequest()


### Examples code

solutionFile <- system.file(package="thinkdata.accent", "examples", "solution.csv")
solution <- parseSolution(solutionFile=solutionFile) 

drawSchedule(solution=solution,detail="A", type="patient")
cat(toSplanSolution(solution))
