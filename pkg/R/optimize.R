#' @title build a solution for the specified model  
#' 
#' @description desc
#' 
#' @param AccentModelInput
#' 
#' \itemize{
#'  \item{patients:}{Sepal width}
#'  \item{therapist:}{Sepal Length}
#' }
#' @export 
#' @return  AccentModelSolution instance. 
#' @example
#' test.xls <- system.file(package="thinkdata.accent", "examples", "data.xls")
#' input <- readXLSModelInput(xlsFile=test.xls) 
#' isTRUE("AccentModelInput" %in% class(input))
#' str(input)
#' result <- optimize(input)
optimize <- function(input) {
  if("AccentModelInput" %in% class(input) == FALSE){
    Log$info("input is not of type AccentModelInput. ")
    return(NA)
  }
  
	require("Rglpk")
	
  tmp <- list()
  tmp$folder <- tempdir()
  tmp$ts <- strftime(Sys.time(), "%s")
  
  # define the tmp file that we'll be using to generate the model
  tmpFile <- function(name){
    file.path(tmp$folder, name)
  }

  tmp$patients <- tmpFile(paste0(tmp$ts, "_", "patients.csv"))
  tmp$patientskills <- tmpFile(paste0(tmp$ts, "_", "patientskills.csv"))
  tmp$therapists <- tmpFile(paste0(tmp$ts, "_", "therapists.csv"))
  tmp$model <- tmpFile(paste0("accent_model_",tmp$ts,".mod"))
  tmp$solution <- tmpFile(paste0("accent_solution_",tmp$ts,".mod"))
  

  tmpWrite <- function(df, out){
    write.table(df, file=out, row.names=FALSE, sep=",", quote=FALSE)
  }
  tmpWrite(df=input$patients, out=tmp$patients)
  tmpWrite(df=input$patientskills, out=tmp$patientskills)
  tmpWrite(df=input$therapists, out=tmp$therapists)
  

  # Get the template for the accent model 
  tmp$model.template.file <- system.file( package="thinkdata.accent", "mathprog", "accent_mathprog_template.mod")
  tmp$model.template <- readLines(tmp$model.template.file)
  
  # Filter the template holders with the temp files
  tmp$model.filtered <- 
    do.call(c, lapply(tmp$model.template, FUN=function(line){
      line <- gsub(pattern="\\{\\{patients\\}\\}", replacement=tmp$patients, x=line)
      line <- gsub(pattern="\\{\\{therapists\\}\\}", replacement=tmp$therapists, x=line)
      line <- gsub(pattern="\\{\\{patientskills\\}\\}", replacement=tmp$patientskills, x=line)
      line <- gsub(pattern="\\{\\{solution\\}\\}", replacement=tmp$patientskills, x=line)
      line <- paste0(line, "\n")
      line
    }))
  
  # Write the filtered file into a MathProg compatible model file  
  cat(tmp$model.filtered, file=tmp$model, fill=TRUE)
  
  # Call the system glpsol process on the model   
  system(sprintf("glpsol -m %s", tmp$model), intern=FALSE, wait=TRUE)
  
  result <- list()
  class(result) <- c("AccentModelSolution")
  result$file <- tmp$solution
  
  tmp <- NULL
  return(result)
}