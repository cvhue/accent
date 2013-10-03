.onAttach <- function(libname=.Library, pkgname="thinkdata.accent") {

  pkdesc <- utils::packageDescription(pkgname, lib.loc = libname, fields = "Version", drop = TRUE)

  packageStartupMessage("This is ", pkgname, " ", pkdesc, ".\n",
                        "For the package overview: type ", sQuote(paste("help(package = ", pkgname, ")", sep="")), ".\n",
                        "If you want to hop in immediately, you can start looking at the help of the main functions by typing:", "\n",
                        "?apply", "\n\n",
                        "For help contact christophe.vanhuele@gmail.com or kenny@thinkdata.be")
}

