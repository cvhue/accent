#' Extract JSON body from a POST call on a Rook service
#' 
#' Convenience function to extract the JSON body returned by a Rook service.
#' 
#' @param x the object returned by req$POST()
#' @return String with content of JSON file, parseable by RJSONIO
#' 
extractJSONPOST <- function(x){
  result <- names(x)[1]
#   result <- substr(result, 1, (nchar(result)-1))
  return(result)
}



#' Helper function to convert time constraints from Splan JSON into a tabular format
#'  
#' @param splanJSON : the raw JSON formatted SPLAN input
#' @param mapping : a 2 columns data.table/frame to map userids [colname:uid] to user names [colname:name]
#' @param constraint.type : either time_yes or time_no
#' @param group : input domain splan group, either subject or lead
#' @param person : output domain for accent, either patient or therapist
#' @return String with content of JSON file, parseable by RJSONIO
#' 
extractSplanTimeConstraints <- function(
  splanJSON,
  mapping,
  constraint.type="time_yes",
  group="subject",
  person="patient"
  ){
  
  inner <- list()
  inner$data <- 
    data.table(
      do.call(rbind, lapply(splanJSON$constraint[[group]], FUN=function(x){
        if(x[["type"]] == constraint.type){
          expand.grid(x[["uid"]], x[["day"]], x[["block"]])
        } else{
          c(NA,NA)
        }
      })
      )
    )
  
  setnames(inner$data, c("uid", "day","time"))
  setkey(inner$data, "uid")
  inner$data <- na.omit(inner$data)
  inner$data <- merge(inner$data, mapping[[group]])
  inner$data$uid <- NULL
  setnames(inner$data, c("name"), c(person))
  inner$data <- inner$data[,c(3,1,2), with=FALSE]
  inner$data
}



#' @title convenience function to wrap a mathprog solution outputFile into a AccentModelOutput instance.
#' 
#' @description desc
#' 
#' @param solutionFile CSV export of an AccentModelSolution data.frame
#' 
#' @return  AccentModelSolution instance.
#' @export 
#' @examples
#' solutionFile <- system.file(package="thinkdata.accent", "examples", "solution.csv")
#' solution <- parseSolution(solutionFile=solutionFile) 
#' str(solution)
#' isTRUE("AccentModelSolution" %in% class(solution))
parseSolution <- function(solutionFile){
  if(file.exists(solutionFile) == FALSE){
    Log$info(sprintf("%s is not an existing file", solutionFile))
  }
  solution <- data.table(read.table(solutionFile, sep=",",header=TRUE)) 
  setnames(solution, c("therapist", "patient", "day", "time"))
  this <- list()
  class(this) <- "AccentModelSolution"
  
  this$file <- solutionFile
  this$data <- solution
  return(this)  
}



#' @title convenience function to wrap a mathprog solution outputFile into a AccentModelOutput instance.
#' 
#' @description desc
#' 
#' @param solution instance of AccentModelSolution
#' 
#' @return  RJSONIO instance representation of the AccentModelSolution 
#' @export 
#' @examples
#' solutionFile <- system.file(package="thinkdata.accent", "examples", "solution.csv")
#' solution <- parseSolution(solutionFile=solutionFile) 
#' cat(toSplanSolution(solution))
toSplanSolution <- function(solution){
  tmp <- solution$data
  result <- toJSON(apply(tmp, MARGIN=1, FUN=as.list))
  return(result)  
}



