library(testthat)


context("een beschrijving")
test_that("myfunction works",{
	data(iris)
	expect_equal(iris$Species, myfunction(iris)$Species)
})
