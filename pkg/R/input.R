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
  
	this$therapistpreferences <- data.table(read.xlsx2(xlsFile, sheetName="therapistpreferences"))
	setnames(this$therapistpreferences, c("therapist", "day","time"))
	
	this$patientpreferences <- data.table(read.xlsx2(xlsFile, sheetName="patientpreferences"))
	setnames(this$patientpreferences, c("patient", "day","time"))
	
	this$therapistunavailabilities <- data.table(read.xlsx2(xlsFile, sheetName="therapistunavailabilities"))
	setnames(this$therapistunavailabilities, c("therapist", "day","time"))
	
	this$patientunavailabilities <- data.table(read.xlsx2(xlsFile, sheetName="patientunavailabilities"))
	setnames(this$patientunavailabilities, c("patient", "day","time"))

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


#' @title read accent model input from an JSON input file  
#' 
#' @description the simple JSON Model input has therapists, patients, patientskills and parameters.
#' This information is sufficient for the accent problem.
#' 
#' @param jsonFile
#' 
#' @export 
#' @return  AccentModelInput instance. This instance contains data.table instances extracted from the JSON file.
#' @example 
#' \dontrun{
#'   test.json <- system.file(package="thinkdata.accent", "examples", "data.json")
#'   input <- readSimpleJSONModelInput(jsonFile=test.json) 
#'   isTRUE("AccentModelInput" %in% class(input))
#'   str(input)
#' }
readSimpleJSONModelInput <- function(jsonFile){
  Log$info("creating AccentModelInput instance from SimpleJSON")
  
  json <- fromJSON(test.json)
  tmp <- list()

# Simple validation
  tmp$simple.json.types <- c(
    "patients",
    "patientskills",
    "therapists",
    "parameters",
    "patientpreferences",
    "therapistpreferences",
    "patientunavailabilities",
    "therapistunavailabilities"
  )

  tmp$simple.json.intersect <- intersect(tmp$simple.json.types, names(json))
  
  if(length(tmp$simple.json.intersect) != 8){
    Log$info("input json does not have all required Splan types")
    return(NA)
  }
  

  this <- list()
  this$patients <- as.data.table(json$patients)
  this$therapists <- as.data.table(json$therapists)
  this$patientskills <- as.data.table(json$patientskills)
  this$parameters <- as.data.table(json$parameters)
  
  this$patientpreferences <- as.data.table(json$patientpreferences)
  this$therapistpreferences <- as.data.table(json$therapistpreferences)
  this$patientunavailabilities <- as.data.table(json$patientunavailabilities)
  this$therapistunavailabilities <- as.data.table(json$therapistunavailabilities)
  class(this) <- c("AccentModelInput")
  this
}




#' @title read accent model input from an SPLAN JSON input file  
#' 
#' @description the SPLAN JSON file can describe any Input Model.
#' For the AccentInputModel, onlythe therapists, patients, patientskills and parameters
#' are extracted from the SPLAN descriptor
#' @param splanJSON path to JSON file, or String with JSON content
#' 
#' @export 
#' @return  AccentModelInput instance. This instance contains data.table instances extracted from the JSON file.
#' @example 
#' \dontrun{
#'   test.json <- system.file(package="thinkdata.accent", "examples", "splan_data.json")
#'   input <- readSplanJSONInput(splanJSON=test.json) 
#'   isTRUE("AccentModelInput" %in% class(input))
#'   str(input)
#' }
readSplanJSONInput <- function(splanJSON){
  Log$info("creating AccentModelInput from SpanJSON")
  
  tmp <- list()
  tmp$json <- fromJSON(splanJSON)
#   tmp$json <- fromJSON("/Users/kennyhelsens/accent/pkg/inst/examples/splan_data.json")
  
  
  if(("accent" %in% tmp$json$general) == FALSE){
    Log$info("Splan JSON problem is not of type accent!")
    return(NA)
  }
  
  # Simple validation
  splan.types <- c("general", "goal","location","lead","skill","constraint","subject")
  tmp$splan.types <- intersect(splan.types, names(tmp$json))
  
  if(length(tmp$splan.types) != 7){
    Log$info("input json does not have all required Splan types")
    return(NA)
  }
  
  this <- list()
  
  tmp$subject <- as.data.table(t(as.data.table(tmp$json$subject)))
  tmp$subject <- data.table(uid=unlist(tmp$subject$V1), name=unlist(tmp$subject$V2))
  setnames(tmp$subject, c("uid", "name"))
  setkey(tmp$subject, "uid")
  
  tmp$lead <- as.data.table(t(as.data.table(tmp$json$lead)))
  tmp$lead <- data.table(uid=unlist(tmp$lead$V1), name=unlist(tmp$lead$V2))
  setnames(tmp$lead, c("uid", "name"))
  setkey(tmp$lead, "uid")
  
  # extract the patients from the subjects
  this$patients <- data.table(patient = sapply(tmp$json$subject, function(x){x[["name"]]}))
  
  # extract the therapists from the leads
  this$therapists <- 
    data.table(do.call(rbind, 
                       lapply(tmp$json$lead, 
                              function(x){expand.grid(x[["name"]], x[["skills"]])}
                       )
    )
  )
  setnames(this$therapists, c("therapist", "skill"))
  
  
  
  # extract the patientskills from the subjects
  this$patientskills <- 
    data.table(do.call(rbind, 
           lapply(tmp$json$subject, 
                  function(x){expand.grid(x[["name"]], x[["skills"]])}
                  )
           )
       )
  setnames(this$patientskills, c("patient", "skill"))

  # extract the parameters from the goals
  this$parameters <-
    data.table(do.call(rbind,
             lapply(tmp$json$goal, 
                    function(x){expand.grid(x[["type"]], x[["value"]])}
                    )
             )
     )
  setnames(this$parameters, c("parameter", "value"))

    
  this$patientpreferences <- 
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_yes", group="subject", person="patient")
  
  this$patientunavailabilities <- 
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_no", group="subject", person="patient")

  this$therapistpreferences <- 
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_yes", group="lead", person="therapist")
  
  this$therapistunavailabilities <-
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_no", group="lead", person="therapist")
  
    
  class(this) <- c("AccentModelInput")
  this
}

