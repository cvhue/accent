optimize <- function(excelfile) {
	require("Rglpk")
	# TODO: read xls file and split into several .csv files

	#x <- Rglpk_read_file( "math.mod", type = "MathProg")
	#sol <- Rglpk_solve_LP(x$objective, x$constraints[[1]], x$constraints[[2]], x$constraints[[3]], x$bounds, 
	#                     x$types, x$maximum)

	model = system.file( package="thinkdata.accent", "mathprog", "accent_mathprog.mod")
	system(sprintf("glpsol -m %s", model), intern=FALSE, wait=FALSE)
}