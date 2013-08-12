#' @title build a solution for the specified model  
#' 
#' @description desc
#' 
#' @param AccentModelInput
#' 
#' @export 
#' @return  starts a process with a Shiny web application  
#' @example
#' runShiny()
runShiny <- function(){
	require("shiny")
	tmp <- list()
  tmp$old.wd <- getwd()
  setwd(system.file(package="thinkdata.accent", "shiny/accent"))
	
  source("shiny/schedule.R")
	runApp("shiny")
	setwd(tmp$old.wd)
	
}