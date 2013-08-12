#' @title read accent model input from an XLS file	
#' 
#' @description desc
#' 
#' @param xlsFile
#' 
#' \itemize{
#'  \item{sheet patients:}{Sheet with patient information}
#'  \item{sheet.therapist:}{Sheet with therapist information}
#'  \item{sheet.links:}{Petal Width}
#' }
#' @export 
#' @return  AccentModelInput instance. This instance contains 2 data.table instances extracted from the given XLS file.
#' @example
#' test.xls <- system.file(package="thinkdata.accent", "examples", "data.xls")
#' input <- readXLSModelInput(xlsFile=test.xls) 
#' isTRUE("AccentModelInput" %in% class(input))
#' str(input)
readXLSModelInput <- function(xlsFile){
	require("xlsx")
	
	Log$info(sprintf("reading accent model input from %s ", xlsFile))

	this <- list()
	
	this$patients <- data.table(read.xlsx2(xlsFile, sheetName="patients"))
	setnames(this$patients, c("patient"))
	
	this$patientskills <- data.table(read.xlsx2(xlsFile, sheetName="patientskills"))
	setnames(this$patientskills, c("patient", "skill"))
	
	this$therapists <- data.table(read.xlsx2(xlsFile, sheetName="therapists"))
	setnames(this$therapists, c("therapist", "skill"))
  
	this$parameters <- data.table(read.xlsx2(xlsFile, sheetName="parameters"))
	setnames(this$parameters, c("parameter", "value"))
  
	# TODO: this is not used? 
	# this$links <- read.xlsx2(xlsFile, sheetName="links")

	class(this) <- c("AccentModelInput")
	this
}


