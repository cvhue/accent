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
#' input <- randomAccentModelInput()
#' isTRUE("AccentModelInput" %in% class(input))
#' str(input)
#' result <- optimize(input)
optimizeAccentModel <- function(input) {
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
  tmp$parameters <- tmpFile(paste0(tmp$ts, "_", "parameters.csv"))
  tmp$patientpreferences <- tmpFile(paste0(tmp$ts, "_", "PP.csv"))
  tmp$patientunavailabilities <- tmpFile(paste0(tmp$ts, "_", "PU.csv"))
  tmp$therapistpreferences <- tmpFile(paste0(tmp$ts, "_", "TP.csv"))
  tmp$therapistunavailabilities <- tmpFile(paste0(tmp$ts, "_", "TU.csv"))
  
  
  tmp$model <- tmpFile(paste0("accent_model_",tmp$ts,".mod"))
  tmp$solution <- tmpFile(paste0("accent_solution_",tmp$ts,".csv"))
  
  tmpWrite <- function(df, out){
    write.table(df, file=out, row.names=FALSE, sep=",", quote=FALSE)
  }

  tmpWrite(df=input$patients, out=tmp$patients)
  tmpWrite(df=input$patientskills, out=tmp$patientskills)
  tmpWrite(df=input$therapists, out=tmp$therapists)
  tmpWrite(df=input$parameters, out=tmp$parameters)
  tmpWrite(df=input$patientpreferences, out=tmp$patientpreferences)
  tmpWrite(df=input$patientunavailabilities, out=tmp$patientunavailabilities)
  tmpWrite(df=input$therapistpreferences, out=tmp$therapistpreferences)
  tmpWrite(df=input$therapistunavailabilities, out=tmp$therapistunavailabilities)
  

  # Get the template for the accent model 
  tmp$model.template.file <- system.file( package="thinkdata.accent", "mathprog", "accent_mathprog_template.mod")
  tmp$model.template <- readLines(tmp$model.template.file)
  
  # Filter the template holders with the temp files
  tmp$model.filtered <- 
    do.call(c, lapply(tmp$model.template, FUN=function(line){
      line <- gsub(pattern="\\{\\{patients\\}\\}", replacement=tmp$patients, x=line)
      line <- gsub(pattern="\\{\\{therapists\\}\\}", replacement=tmp$therapists, x=line)
      line <- gsub(pattern="\\{\\{patientskills\\}\\}", replacement=tmp$patientskills, x=line)
      line <- gsub(pattern="\\{\\{solution\\}\\}", replacement=tmp$solution, x=line)
      line <- gsub(pattern="\\{\\{parameters\\}\\}", replacement=tmp$parameters, x=line)
      line <- gsub(pattern="\\{\\{patientpreferences\\}\\}", replacement=tmp$patientpreferences, x=line)
      line <- gsub(pattern="\\{\\{patientunavailabilities\\}\\}", replacement=tmp$patientunavailabilities, x=line)
      line <- gsub(pattern="\\{\\{therapistpreferences\\}\\}", replacement=tmp$therapistpreferences, x=line)
      line <- gsub(pattern="\\{\\{therapistunavailabilities\\}\\}", replacement=tmp$therapistunavailabilities, x=line)
      
      line <- paste0(line, "\n")
      line
    }))
  
  # Write the filtered file into a MathProg compatible model file  
  cat(tmp$model.filtered, file=tmp$model, fill=TRUE)
  
  
  # Call the system glpsol process on the model   
  system(sprintf("glpsol -m %s", tmp$model), intern=FALSE, wait=TRUE)
  
  solution <- parseSolution(tmp$solution)
#   solution$input <- input
  
  tmp <- NULL
  return(solution)
}

#' @title convenience function to wrap a mathprog solution outputFile into a AccentModelOutput instance.
#' 
#' @description desc
#' 
#' @param AccentModelResult
#' 
#' @return  AccentModelSolution instance.
#' @export 
#' @example
#' solutionFile <- system.file(package="thinkdata.accent", "examples", "solution.csv")
#' solution <- parseSolution(solutionFile=solutionFile) 
#' str(solution)
#' isTRUE("AccentModelSolution" %in% class(input))
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


