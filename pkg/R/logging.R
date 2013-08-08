# empty logger that will be truncated
# @param ... statements to log
emptyLogger <- function(...){ 
  invisible()
}

# date logger that will prefix the statements with a timestamp
# @param ... statements to log
dateLogger <- function(...){
  cat(sprintf("%s :: %s\n", format(Sys.time(), ("%Y-%m-%d %H:%M:%S")), ...))
}

Log <- new.env()
Log$info <- if (interactive()) cat else emptyLogger
Log$debug <- if (interactive()) cat else emptyLogger

#' sets the logging of thinkdata.accent package
#' @param level logging level: info/debug
#' @param logger to be called for logging statements: 'emptylogger', 'datelogger'
#' @export
#' @examples
#' \dontrun{
#' # enable logging to info channel with prefixedDate
#' setLogging(level="info", logger='dateLogger')
#' Log$info("info level enabled")
#' 
#' # disable logging to info channel through emptyLogger
#' setLogging(level="info", logger='emptyLogger')
#' Log$info("info level enabled")
#' 
#' # enable/disable info/debug logging channels
#' setLogging(level="info", 'dateLogger')
#' setLogging(level="debug", 'emptyLogger')
#' Log$info("info level enabled")
#' Log$debug("debug level disabled")
#' }
setLogging <- function(level = c("info"), logger=if (interactive()) cat){
  if (!is.function(logger)){
    if(is.character(logger)){
      if(logger == "dateLogger"){
        logger <- dateLogger
      }else if(logger == "emptyLogger"){
        logger <- emptyLogger
      }
      else{
        stop("logger needs to be a function or either 'dateLogger' or 'emptyLogger'")
      }
    }else{
      logger <- emptyLogger
    }
  }
  assign(level, logger, Log)
}
