step1 <- c(0.0013807009, 0.0005997510, 0.0011314072, 0.0016246001, 0.0014240778)
A <- c( 34.648458,  1.705335,  0.000010, 11.312707,  9.167534)
n <- 10

# OP
f1 <- function(step1, A, n) {
  m <- length(step1)
  tau <- matrix(0,nrow=n+1,ncol=m)
  tau[1,] <- A
  for(j in 1:m){
    for(i in 2:nrow(tau)){
      tau[i,j] <- tau[i-1,j] + step1[j]*1.0025^(i-2)
    }
  }
  tau
}

# Hayden
f2 <- function(step1, A, n) {
  calc_next_row <- function(tau, row_idx) {
    tau + step1 * 1.0025 ^ row_idx
  }
  do.call(rbind, Reduce(calc_next_row, 
                        init = A, 
                        x = 0:(n - 1), 
                        accumulate = TRUE))
}
all.equal(f2(step1, A, n), f1(step1, A, n))
all.equal(to_col_cumsum(step1, A, n), f1(step1, A, n))

step1 <- runif(1000)
A <- rnorm(1000)
n <- 2000
microbenchmark::microbenchmark(
  HR = f2(step1, A, n), 
  FP = to_col_cumsum(step1, A, n), 
  times = 100
)
