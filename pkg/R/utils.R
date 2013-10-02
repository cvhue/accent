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
#' @param constraint.type : either time_yes or time_no
#' @param group : input domain splan group, either subject or lead
#' @param person : output domain for accent, either patient or therapist
#' @return String with content of JSON file, parseable by RJSONIO
#' 
extractSplanTimeConstraints <- function(
  splanJSON,
  constraint.type="time_yes",
  group="subject",
  person="patient"){
  
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
  inner$data <- merge(inner$data, tmp[[group]])
  inner$data$uid <- NULL
  setnames(inner$data, c("name"), c(person))
  inner$data <- inner$data[,c(3,1,2), with=FALSE]
  inner$data
  
}
