// [[Rcpp::depends(BH, bigmemory)]]
#include <bigmemory/MatrixAccessor.hpp>
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
LogicalVector to_keep(SEXP bm_addr) {
  
  XPtr<BigMatrix> xptr(bm_addr);
  MatrixAccessor<double> macc(*xptr);
  
  size_t n = macc.nrow();
  size_t m = macc.ncol();
  
  double first_val;
  
  LogicalVector keep(m, false);
  
  for (size_t j = 0; j < m; j++) {
    first_val = macc[j][0];
    for (size_t i = 1; i < n; i++) {
      if (macc[j][i] != first_val) {
        keep[j] = true;
        break;
      }
    }
  }
  
  return keep;
}

/*** R
library(bigmemory)
r <- 100
c <- 10000
m4 <- matrix(sample(0:1,r*c, replace=TRUE),r,c)
m4 <- cbind(m4, 1)
m4 <- as.big.matrix(m4)
m4[, 1] <- 1
m4[, 2] <- 0

keep <- to_keep(m4@address)
m4.keep <- deepcopy(m4, cols = which(keep))
*/
