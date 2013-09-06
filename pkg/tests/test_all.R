library(thinkdata.accent)

if (require(testthat)){
   print("testing...")
   #test_package("thinkdata.accent")
   test.file <- system.file(file.path("examples","data.xls"),package="thinkdata.accent")
   model <- thinkdata.accent::readXLSModelInput(test.file)
   solution <- thinkdata.accent::optimize(model)
   thinkdata.accent::schedule(read.csv(solution$file))
}
