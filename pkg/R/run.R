#' @title Run Shiny app
#'
#' @description Sets current working directory to package dir and runs shiny app
#'
#' @return ggplot schedule
#' @export
#' @examples
#' \dontrun{
#' runShinyAccent()	
#' }
#'
runShinyAccent <- function(){
	require("thinkdata.accent")
  	dir <- system.file(package="thinkdata.accent", "shiny/accent")
		shiny::runApp(dir)
}