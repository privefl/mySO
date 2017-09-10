#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector sumByPart(const NumericVector& x, int size) {
  
  int n = x.size();
  int K = ceil((double)n / size); // DO NOT USE INTEGERS WITH CEIL
  IntegerVector res(K);
  int i, k, offset = 0;
  
  for (k = 0; k < K-1; k++) {
    for (i = 0; i < size; i++) {
      res[k] += x[offset + i];
    }
    offset += size;
  }
  
  for (i = offset; i < n; i++) {
    res[k] += x[i];
  }
  
  return res;
}


/*** R
sumByPart(rep(1, 500), 1330)
sumByPart(rep(1, 1300), 1330)
sumByPart(rep(1, 5612), 1330)
*/
