# simulate data
set.seed(1)
periods <-150L
ind <- 90000L
mat <- sapply(rep(ind, periods), rnorm)

n_lags <- 5L # Number of lags
system.time({
  vcov <- matrix(0, nrow = n_lags + 1L, ncol = n_lags + 1)
  for (i in 0L:n_lags) {
    for (j in i:n_lags) {
      vcov[j + 1L, i + 1L] <- 
        sum(mat[, (1L + (j - i)):(periods - i)] *
              mat[, 1L:(periods - j)]) /
        (ind * (periods - j) - 1)
    }
  }
})


Rcpp::sourceCpp('vcov.cpp')

system.time(
  test <- compute_vcov(mat, n_lags)
)

vcov / test

Rcpp::sourceCpp('vcov_opt.cpp')

system.time(
  test2 <- compute_vcov2(mat, n_lags)
)

all.equal(test2, test)

