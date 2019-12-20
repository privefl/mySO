#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix init(int n) {
  
  NumericMatrix res(n);
  for (int j = 0; j < n; j++)
    for (int i = 0; i < n; i++)
      res(i, j) = i;
  return res;
}


// [[Rcpp::export]]
NumericMatrix noinit(int n) {
  
  NumericMatrix res = no_init_matrix(n, n);
  for (int j = 0; j < n; j++)
    for (int i = 0; i < n; i++)
      res(i, j) = i;
  return res;
}

/*** R
init(2)
noinit(2)
microbenchmark::microbenchmark(
  init(1000), 
  noinit(1000)
)
# Unit: milliseconds
#         expr      min       lq     mean   median       uq      max neval
#   init(1000) 4.834564 5.286996 12.92024 5.333042 5.760279 66.90539   100
# noinit(1000) 4.823406 4.869625 11.15181 4.917239 4.978591 62.49238   100
*/
