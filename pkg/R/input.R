#' @title read accent model input from an XLS file	
#' 
#' @description desc
#' 
#' @param xlsFile
#' 
#' \itemize{
#'  \item{sheet patients:}{Sepal width}
#'  \item{sheet.therapist:}{Sepal Length}
#'  \item{sheet.links:}{Petal Width}
#' }
#' @export 
#' @return  AccentModelInput instance. This instance contains 3 data.frames extracted from the given XLS file.
readXLSModelInput <- function(xlsFile){
	require("xlsx")
	
	Log$info(sprintf("reading accent model input from %s ", xlsFile))

	this <- list()
	this$patients <- read.xlsx2(xlsFile, sheetName="patients")
	this$therapists <- read.xlsx2(xlsFile, sheetName="therapists")
	
	# TODO: this is not used? 
	# this$links <- read.xlsx2(xlsFile, sheetName="links")

	class(this) <- c("AccentModelInput")
	this
}