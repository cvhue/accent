#' Mytitle
#' 
#' My description
#' 
#' @param data a data frame
#' @param ... passed on to other methods
#' @return 
#' A description of the return value
#' @export
#' @examples
#' data(iris)
#' myfunction(iris)
myfunction <- function(data, ...){
  result <- data
  class(result) <- c("myclassname","data.frame")
  result
}

#' Mytitle
#' 
#' My description
#' 
#' @param x an object of class myclassname
#' @param ... further arguments passed to or from other methods.
#' @return 
#' Nothing, prints
#' @method print myclassname
#' @export print.myclassname
#' @seealso \code{\link{print}}
#' @examples
#' data(iris)
#' myfunction(iris)
print.myclassname <- function(x, ...){
  print(sprintf("This data.frame has %s row and %s columns", nrow(x), ncol(x)))
}


