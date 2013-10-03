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
#' @examples 
#' \dontrun{
#'   test.xls <- system.file(package="thinkdata.accent", "examples", "data.xls")
#'   input <- readXLSModelInput(xlsFile=test.xls) 
#'   isTRUE("AccentModelInput" %in% class(input))
#'   str(input)
#' }
readXLSModelInput <- function(xlsFile){
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


#' @title read accent model input from an JSON input file  
#' 
#' @description the simple JSON Model input has therapists, patients, patientskills and parameters.
#' This information is sufficient for the accent problem.
#' 
#' @param jsonFile
#' 
#' @export 
#' @return  AccentModelInput instance. This instance contains data.table instances extracted from the JSON file.
#' @examples 
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
#' @examples 
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
  
  groups <- list()
  groups$subject <- as.data.table(t(as.data.table(tmp$json$subject)))
  groups$subject <- data.table(uid=unlist(groups$subject$V1), name=unlist(groups$subject$V2))
  setnames(groups$subject, c("uid", "name"))
  setkey(groups$subject, "uid")
  
  groups$lead <- as.data.table(t(as.data.table(tmp$json$lead)))
  groups$lead <- data.table(uid=unlist(groups$lead$V1), name=unlist(groups$lead$V2))
  setnames(groups$lead, c("uid", "name"))
  setkey(groups$lead, "uid")
  
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
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_yes", group="subject", person="patient", mapping=groups)
  
  this$patientunavailabilities <- 
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_no", group="subject", person="patient", mapping=groups)

  this$therapistpreferences <- 
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_yes", group="lead", person="therapist", mapping=groups)
  
  this$therapistunavailabilities <-
    extractSplanTimeConstraints(splanJSON=tmp$json, constraint.type="time_no", group="lead", person="therapist", mapping=groups)
  
    
  class(this) <- c("AccentModelInput")
  this
}

