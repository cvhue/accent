\name{buildReport}
\alias{buildReport}
\title{build a configuration report}
\usage{
  buildReport(input,
    report = system.file(package = "thinkdata.accent", "rmd", "report.Rmd"),
    path = getwd(), browse = TRUE)
}
\arguments{
  \item{input}{object}

  \item{report}{chr path of the markdown report to build.}

  \item{path}{chr target folder to generate the report in}

  \item{browse}{logical if TRUE opens the generated report
  in a browser}
}
\value{
  path to html report
}
\description{
  report description
}

