# create a private DEBUG environment
DEBUG <- new.env()


### splan/solution app
rookSplan <- function(env){
  req <- Rook::Request$new(env)
  DEBUG$last.req <- req    
  
  res <- Rook::Response$new()
  
  if(req$post()){
    splanJSON <- extractJSONPOST(req$POST())
    input <- readSplanJSONInput(splanJSON)
    solution <- optimizeAccentModel(input)
    
    res$write(toJSON.AccentModelSolution(solution))
  
  }else{
    res$write(c('only supports POST splanJSON!','\n'))
  }
  
  res$finish()
}

### hello world rook
rookHello <- function(env){
  req <- Rook::Request$new(env)
  res <- Rook::Response$new()

  DEBUG$last.req <- req
  friend <- 'World'
  if (!is.null(req$GET()[['friend']]))
    friend <- req$GET()[['friend']]
  res$write(paste('<h1>Hello',friend,'</h1>\n'))
  res$write('What is your name?\n')
  res$write('<form method="GET">\n')
  res$write('<input type="text" name="friend">\n')
  res$write('<input type="submit" name="Submit">\n</form>\n<br>')
  res$finish()
}


SERVICE <- new.env()
SERVICE$apps <- list()
SERVICE$apps$hello <- rookHello
SERVICE$apps$splan <- rookSplan


#' @title start all configured splan Rook services, if any.  
#' 
#' @description this method starts all Rook apps
#' @param myPort int port to run the sevice on
#' @param myInterface char interface on which the service listens
#' @param serviceApp char the app that needs to be run.   
#' @export
#' @examples
#' config <- AccentConfig()
#' config$service$app <- "splan"
#' \dontrun{
#' startService(config)
#' }  
startService <- function(config = AccentConfig()){
  
  myPort <- config$service$port
  myInterface <- config$service$interface
  serviceApp <- config$service$app
  
  app <- list(call = SERVICE$apps[[serviceApp]])
  
  browseURL(sprintf("http://localhost:%s/", myPort))
  runServer(myInterface, myPort, app, 250)

}


#' @title print the last request send to the webapp  
#' 
#' @description print the last request send to the webapp 
#' 
#' @export  
getLastRequest <- function(){
  DEBUG$last.req
}

