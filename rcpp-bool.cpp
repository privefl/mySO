#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector rowsums_bool(const LogicalMatrix& x,
                           const IntegerVector& ind_col) {
  
  int i, j, j2, n = x.nrow(), m = ind_col.size();
  IntegerVector res(n);
  
  
  for (j = 0; j < m; j++) {
    j2 = ind_col[j] - 1;
    for (i = 0; i < n; i++) {
      if (x(i, j2)) res[i]++;
    } 
  }
  
  return res;
}

/*** R
toymat <- matrix(sample(c(F,T),50,rep=T),5,10)
toymat[,c(1,5,6)]
(tmp <- rowsums_bool(toymat, c(1,5,6)))
tmp == 3  ## ALL
tmp != 0  ## ANY
*/
