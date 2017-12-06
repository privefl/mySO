#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix to_col_cumsum(const NumericVector& step1,
                            const NumericVector& A,
                            int n) {
  
  int m = step1.length();
  NumericMatrix tau(n + 1, m);
  int i, j;
  
  NumericVector pows(n + 1);
  for (i = 1; i < (n + 1); i++) pows[i] = pow(1.0025, i - 1);
  
  for (j = 0; j < m; j++) {
    tau(0, j) = A[j];
    for (i = 1; i < (n + 1); i++) {
      tau(i, j) = tau(i - 1, j) + step1[j] * pows[i];
    }
  }
  
  return tau;
}

