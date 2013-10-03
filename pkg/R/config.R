#' @title read accent model default configuration
#' 
#' @description reads the default configuration embedded in the package (pkg/inst/extdata/baseconfig.json),
#' this file can be modified locally and passed via the function argument file
#' 
#' 
#' @param file the JSON configuration file. Default loads the "pkg/inst/extdata/baseconfig.json".
#' 
#' @export 
#' @return  AccentModelConfig instance. This instance contains 2 data.table instances extracted from the given XLS file.
#' @examples 
#' config <- AccentConfig()
#' print(config$service)
AccentConfig <- function(file = system.file(package="thinkdata.accent", "extdata", "baseconfig.json")){
  json.file <- "~/accent/pkg/inst/extdata/baseconfig.json"
  this <- fromJSON(json.file)
  class(this) <- c("AccentConfig", "list")
  return(this)
}
