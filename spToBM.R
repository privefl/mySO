spToBM <- function(x, ...) {
  res <- bigmemory::big.matrix(x@Dim[1], x@Dim[2], init = 0, ...)
  sp2BM(x, res@address)
  res
}

test[]

library(Matrix)
x <- Matrix(0, 100, 100)
x[sample(length(x), 400)] <- 1
test <- spToBM(x)
all.equal(test[], as.matrix(x), check.attributes = FALSE)
