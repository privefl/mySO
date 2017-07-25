#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix rcppFun(const NumericMatrix& x,
                      const NumericVector& lastCol) {
  
  int n = x.nrow();
  int m = x.ncol();
  
  NumericMatrix res(n, m);
  int i, j;
  
  for (j = 0; j < m; j++) {
    for (i = 0; i < n; i++) {
      res(i, j) = 10 * x(i, j) * lastCol[j];
    }
  }
  
  return res;
}

