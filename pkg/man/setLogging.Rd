\name{setLogging}
\alias{setLogging}
\title{sets the logging of thinkdata.accent package}
\usage{
  setLogging(level = c("info"),
    logger = if (interactive()) cat)
}
\arguments{
  \item{level}{logging level: info/debug}

  \item{logger}{to be called for logging statements:
  'emptylogger', 'datelogger'}
}
\description{
  sets the logging of thinkdata.accent package
}
\examples{
\dontrun{
# enable logging to info channel with prefixedDate
setLogging(level="info", logger='dateLogger')
Log$info("info level enabled")

# disable logging to info channel through emptyLogger
setLogging(level="info", logger='emptyLogger')
Log$info("info level enabled")

# enable/disable info/debug logging channels
setLogging(level="info", 'dateLogger')
setLogging(level="debug", 'emptyLogger')
Log$info("info level enabled")
Log$debug("debug level disabled")
}
}

