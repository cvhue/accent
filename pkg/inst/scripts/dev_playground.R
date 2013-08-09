# Read the data.xls file from the package examples
test.xls <- system.file(package="thinkdata.accent", "examples", "data.xls")
input <- readXLSModelInput(test.xls) 
isTRUE("AccentModelInput" %in% class(input))
str(input)

