// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>

// [[Rcpp::export]]
arma::sp_mat mult_sp_den_to_sp(arma::sp_mat& a, arma::mat& b)
{
  // sparse x dense -> sparse
  arma::sp_mat result(a * b);
  return result;
}

// [[Rcpp::export]]
arma::sp_mat mult_den_sp_to_sp(arma::mat& a, arma::sp_mat& b)
{
  // dense x sparse -> sparse
  arma::sp_mat result(a * b);
  return result;
}

// [[Rcpp::export]]
arma::sp_mat mult_sp_den_to_sp2(arma::sp_mat& a, arma::mat& b)
{
  int m = a.n_cols;
  arma::sp_mat result(a.col(0) * b.row(0));
  
  for (int j = 1; j < m; j++) {
    result += a.col(j) * b.row(j);
  }
  
  return result;
}


/*** R
library(Matrix)
N <- 3e3
set.seed(98765)
# 10000 x 10000 sparse matrices, 99% sparse
a <- rsparsematrix(N, N, 0.01, rand.x=function(n) rpois(n, 1) + 1)
b <- rsparsematrix(N, N, 0.01, rand.x=function(n) rpois(n, 1) + 1)

# dense copies
a_den <- as.matrix(a)
b_den <- as.matrix(b)

system.time(tmp1 <- mult_sp_den_to_sp(a, b_den))
system.time(tmp1.2 <- a %*% b_den)

system.time(tmp2 <- mult_den_sp_to_sp(a_den, b))
system.time(tmp2.2 <- a_den %*% b)
*/
