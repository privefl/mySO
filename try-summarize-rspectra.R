mat <- matrix(0, 15, 20); mat[] <- rnorm(length(mat))

true <- RSpectra::svds(mat, 10)

toPrint1 <- toPrint2 <- FALSE
res1 <- res2 <- 0

A <- function(x, args) {
  cat("A\n")
  print(all.equal(x, drop(get("res2"))))
  if (toPrint1) {
    print(x)
    print(drop(mat %*% x))
    toPrint1 <<- FALSE
  } 
  res1 <<- crossprod(mat, x)
} 

Atrans <- function(x, args) {
  cat("Atrans\n")
  if (toPrint2) {
    print(x)
    print(drop(crossprod(mat, x)))
    toPrint2 <<- FALSE
  } 
  print(all.equal(x, drop(get("res1"))))
  res2 <<- mat %*% x
} 

test1 <- RSpectra::svds(A, 10, Atrans = Atrans, dim = rev(dim(mat)))
all.equal(test1, true)


x <- rnorm(ncol(mat))
crossprod(mat, mat %*% x)[1]
# first element
(mat %*% x)[1]
mat[1, , drop = FALSE] %*% x
crossprod(mat, mat %*% x)[1]
crossprod(mat[, 1, drop = FALSE], mat %*% x)
