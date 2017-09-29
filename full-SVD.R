N <- 70
M <- 50
mat <- matrix(0, N, M)
mat[] <- rnorm(length(mat))

str(test1 <- svd(mat))
str(test2 <- svd(mat, nu = nrow(mat), nv = ncol(mat)))
test2$u
test1$u
all.equal(test1$v, test2$v)
