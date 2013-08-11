Accent
======
R shiny app for the Accent holiday scheduling case

### Make the package
Run `./build.bash`

### Install the package from source
Run in **output** folder: `R CMD INSTALL thinkdata.accent_0.1.1.tar.gz`

### Schedule test data
Load accent library by `library("thinkdata.accent")`

Read sample data from excel into model:

    test.file <- system.file(file.path("examples","data.xls"),package="thinkdata.accent")
    model <- readXLSModelInput(test.file)

Optimize the model and show the resulting schedule

    solution <- optimize(model)
    schedule(read.csv(solution$file))
