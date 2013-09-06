test <- function(){
	library("shiny")
	setwd("~/src/accent/")
	source("shiny/schedule.R")
	runApp("shiny")
  
	library("thinkdata.accent")
	test.file <- system.file(file.path("examples","data.xls"),package="thinkdata.accent")
	model <- readXLSModelInput(test.file)
	solution <- optimize(model)
	schedule(read.csv(solution$file))
  
}