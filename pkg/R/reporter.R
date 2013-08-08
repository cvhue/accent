#' @title build a configuration report
#'
#' @description report description
#'
#' @param input object
#' @param report chr path of the markdown report to build.
#' @param path chr target folder to generate the report in
#' @param browse logical if TRUE opens the generated report in a browser
#' @return path to html report
#' @export
#'
buildReport <- function(input,
                                report = system.file(
                                  package="thinkdata.accent",
                                  "rmd",
                                  "report.Rmd"),
                                  path=getwd(), 
                                  browse=TRUE){

  if(inherits(input, "list")){
    input <- input[[1]]
  }

  # prepare all data needed for the report in a separate environment
  reportdata <- list()
  reportdata$input <- input

  # create new base environment, and assign the reporting data list
  env.knit <- new.env()
  assign("reportdata", reportdata, envir=env.knit)

  file.rmd <- tail(strsplit(report, "[/\\\\]")[[1]], 1)
  doc.md <- sub("Rmd$","md", file.rmd)

  # knit the document
  doc.md <- knit(report,
              output=doc.md,
              envir=env.knit)

  doc.html <- sub("md$","html",doc.md)

  css <- system.file(package="thinkdata.accent", "rmd", "bootstrap.css")
  markdownToHTML(doc.md, output=doc.html, stylesheet=css)

  # If browsing is requested, open the generated html report
  if(browse){
    browseURL(doc.html)
  }

  Log$info(sprintf("Created report at '%s'",doc.html))
  doc.html
}
