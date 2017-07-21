library(microbenchmark)

a <- replicate(250, 1:100, simplify = FALSE)
b <- replicate(250, sample(letters, 100, TRUE), simplify = FALSE)

microbenchmark(
  c(a, b),
  as.data.frame(c(a, b), stringsAsFactors = FALSE),
  as.data.frame(do.call(cbind, c(a, b)), stringsAsFactors = FALSE),
  times = 10
)
