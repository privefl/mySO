// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix cosine_similarity(NumericMatrix x) {                                                             
  
  arma::mat X(x.begin(), x.nrow(), x.ncol(), false);
  arma::mat rowSums = sum(X % X, 0);
  arma::mat res;
  
  res = X.t() * X / sqrt(rowSums.t() * rowSums);
  
  return(wrap(res));
}

// [[Rcpp::export]]
NumericMatrix& toCosine(NumericMatrix& mat,
                        const NumericVector& diag) {
  
  int n = mat.nrow();
  int i, j;
  
  for (j = 0; j < n; j++) 
    for (i = 0; i < n; i++) 
      mat(i, j) /= diag(i) * diag(j);
  
  return mat;
}

/*** R
coss <- function(x) { 
  crossprod(x)/(sqrt(crossprod(x^2)))
}

coss2 <- function(x) {
  cross <- crossprod(x)
  toCosine(cross, sqrt(diag(cross)))
}

XX <- matrix(rnorm(120*1600), ncol = 1600)

microbenchmark::microbenchmark(
  cosine_similarity(XX), 
  coss(XX), 
  coss2(XX),
  times = 20
)

coss(XX)[1:5, 1:5]
*/
