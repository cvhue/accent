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


