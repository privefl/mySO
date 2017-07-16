library(purrr)
f_map <- map(1:2, function(i) function(x) x + i) 
f_base <- lapply(1:2, function(i) function(x) x + i) 
testthat::expect_equal(f_map[[1]](0), f_base[[1]](0)) 
testthat::expect_equal(f_map[[2]](0), f_base[[2]](0))

f_base[[1]](0)
f_map[[1]](0)
