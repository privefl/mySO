#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
NumericMatrix compute_vcov2(const NumericMatrix& mat, int n_lags) {
  
  NumericMatrix vcov(n_lags + 1, n_lags + 1);
  double myCov;
  
  int i, j, k1, k2, l;
  int n = mat.nrow();
  int m = mat.ncol();
  
  for (i = 0; i <= n_lags; i++) {
    for (j = i; j <= n_lags; j++) {
      myCov = 0;
      for (k1 = j - i, k2 = 0; k2 < (m - j); k1++, k2++) {
        for (l = 0; l <= (n - 4); l += 4) {
          myCov += (mat(l, k1) * mat(l, k2) + mat(l+1, k1) * mat(l+1, k2)) +
            (mat(l+2, k1) * mat(l+2, k2) + mat(l+3, k1) * mat(l+3, k2)); 
        }
        for (; l < n; l++) {
          myCov += mat(l, k1) * mat(l, k2); 
        }
      }
      myCov /= n * (m - j) - 1;
      vcov(i, j) = vcov(j, i) = myCov;
    }
  }
  
  return vcov;
}
