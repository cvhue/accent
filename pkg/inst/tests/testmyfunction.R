library(testthat)
context("een beschrijving")

test_that("myfunction works",{
	data(iris)
	expect_equal(iris$Species, myfunction(iris)$Species)
})


# load example accent model input from package  
# input <- test_exampleInput()
# test_exampleInput <- function(){ 
# Read the data.xls file from the package examples
#   test.xls <- system.file(package="thinkdata.accent", "examples", "data.xls")
#   input <- readXLSModelInput(test.xls) 
#   isTRUE("AccentModelInput" %in% class(input))
#   return(input)
# }

# optimize example accent data from package examples  
# solution <- test_exampleOptimization()
test_exampleOptimization <- function(){
  # Read solution file and wrap in a class
  isTRUE("AccentModelInput" %in% class(input))
  result <- optimizeAccentModel(input) 
}

# load example accent model solution from package examples
# solution <- test_exampleSolution()
# test_exampleSolution <- function(){
#   solutionFile <- system.file(package="thinkdata.accent", "examples", "solution.csv")
#   solution <- parseSolution(solutionFile=solutionFile) 
# }

