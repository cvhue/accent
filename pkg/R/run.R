#' @title Run Shiny app
#'
#' @description Sets current working directory to package dir and runs shiny app
#'
#' @param df dataframe consisting of lead, subject, day and time
#' @return ggplot schedule
#' @export
#' @examples
#' \dontrun{
#' runShinyAccent()	
#' }
#'
runShinyAccent <- function(){
	library("shiny")
	require("thinkdata.accent")
  dir <- system.file(package="thinkdata.accent", "shiny/accent")
	shiny::runApp(dir)
}