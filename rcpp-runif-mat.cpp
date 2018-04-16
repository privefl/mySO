#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix mu(int n, int m) { 
  NumericVector v = runif(n*m); 
  return NumericMatrix(n, m, v.begin()); 
}

// [[Rcpp::export]]
NumericVector mu2(int n, int m) { 
  NumericVector v = runif(n * m);
  v.attr("dim") = Dimension(n, m);
  return v; 
}

// [[Rcpp::export]]
NumericMatrix rngCpp(const int n,const int m) {
  NumericMatrix X(n, m);
  
  for(int i = 0; i < m; i++){
    X(_,i) = runif(n);
  }
  return X;
}

/*** R
set.seed(1); mu(4, 5)
set.seed(1); mu2(4, 5)

N <- 1000; M <- 1000
microbenchmark::microbenchmark(
  mu(N, M),
  mu2(N, M),
  rngCpp(N, M)
)
*/
