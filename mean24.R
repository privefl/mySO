A <- array(1:192, c(2, 2, 48))
 
apply(A, c(1, 2), mean)
 
x <- 1:48

mean24 <- function(x) {
  dim(x) <- c(24, length(x) / 24)
  colMeans(x)
}

apply(A, c(1, 2), mean24)
