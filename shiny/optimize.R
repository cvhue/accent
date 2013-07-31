library("Rglpk")
optimize <- function(excelfile) {
  # TODO: read xls file and split into several .csv files
  
  #x <- Rglpk_read_file( "math.mod", type = "MathProg")
  #sol <- Rglpk_solve_LP(x$objective, x$constraints[[1]], x$constraints[[2]], x$constraints[[3]], x$bounds, 
   #                     x$types, x$maximum)
  
  system("glpsol -m math.mod",intern=FALSE,wait=FALSE)
  
  #return(sol)
}