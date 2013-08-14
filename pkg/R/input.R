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
#' \dontrun{
#'   test.xls <- system.file(package="thinkdata.accent", "examples", "data.xls")
#'   input <- readXLSModelInput(xlsFile=test.xls) 
#'   isTRUE("AccentModelInput" %in% class(input))
#'   str(input)
#' }
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
  
	class(this) <- c("AccentModelInput")
	this
}


#' @title generate a random accent model input
#' @return  AccentModelInput instance. This instance contains 2 data.table instances extracted from the given XLS file.
#' @export 
#' @examples
#' input <- randomAccentModelInput() 
#' isTRUE("AccentModelInput" %in% class(input))
#' str(input)
randomAccentModelInput <- function(){
  Log$info("creating random AccentModelInput instance")
  patients <- data.table(patient=paste0("P", 1:as.integer(runif(n=1,min=5,max=10))))
  patientskills <- data.table(
    patient=paste0("P", as.integer(runif(n=nrow(patients),min=1,max=10))),
    skill=as.integer(runif(n=nrow(patients)*2, min=1, max=4))
    )
  patientskills <- unique(patientskills)

# FIXME: therapist can now only have one skill, this randomizer has multiple skills per therapist.
#   therapists <- data.table(
#     therapist=paste0("Therapist-", rep(LETTERS[1:3],3)),
#     skill=as.integer(runif(9, 1,100)%%3)+1
#   )  
#   therapists <- unique(therapists)
#   
  therapists <- data.table(
        therapist=LETTERS[1:3],
        skill=1:3
 )  
    
  
  parameters <- data.table(
    parameter=c("minhours", "preference"),
    value=c(1, 0.5)
  ) 

  this <- list()
  
  this$patients <- patients
  this$patientskills <- patientskills
  this$therapists <- therapists
  this$parameters <- parameters
  class(this) <- c("AccentModelInput")
  this
}
