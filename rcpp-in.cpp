#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix cpp_eye(int n, const IntegerVector& v) {
  
  int i, j;
  
  NumericMatrix A(n, n);
  for (i = 0; i < n; i++) A(i, i) = 1;
  
  for (j = 0; j < v.size(); j++) {
    i = v[j] - 1;
    A(i, i) = 0;
  }
  
  return A;
}

/*** R
n <- 6; v = 1:3
cpp_eye(n, v)

library(microbenchmark)
microbenchmark(
  cpp_eye(n, v),
  {
    A <- diag(n)
    diag(A)[v] <- 0
  }
)
*/
