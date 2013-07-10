library("xlsx")

patients <- read.xlsx2("data.xls", sheetName="patients", header=TRUE,as.data.frame=TRUE)
therapists <- read.xlsx2("data.xls", sheetName="therapists", header=TRUE,as.data.frame=TRUE)
links <- read.xlsx2("data.xls", sheetName="links", header=TRUE,as.data.frame=TRUE)
