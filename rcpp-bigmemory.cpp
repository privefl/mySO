// [[Rcpp::depends(BH, bigmemory)]]
#include <bigmemory/MatrixAccessor.hpp>
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void fillBM(SEXP pBigMat) {
  
  XPtr<BigMatrix> xpMat(pBigMat);
  MatrixAccessor<double> macc(*xpMat);
  
  int n = macc.nrow();
  int m = macc.ncol();
  
  for (int j = 0; j < m; j++) {
    for (int i = j; i < n; i++) {
      macc[j][i] = pow(i - j, 5) + 2;
    }
  }
}

/*** R
library(bigmemory)
k <- big.matrix(nrow = 8000, ncol = 8000, type = 'double', init = 0)
k.mat <- k[]

system.time(
  fillBM(k@address)
)
k[1:5, 1:5]

system.time(
  k.mat <- ifelse(row(k.mat) < col(k.mat), 0, (row(k.mat)-col(k.mat))^5 + 2)
)
k.mat[1:5, 1:5]
all.equal(k.mat, k[])
*/
