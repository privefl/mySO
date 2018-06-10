// [[Rcpp::depends(BH, bigmemory)]]
#include <bigmemory/MatrixAccessor.hpp>
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void to_one(SEXP bm_addr) {
  
  XPtr<BigMatrix> xptr(bm_addr);
  MatrixAccessor<double> macc(*xptr);
  
  for (size_t j = 0; j < macc.ncol(); j++)
    for (size_t i = 0; i < macc.nrow(); i++)
      if (macc[j][i] != 0) macc[j][i] = 1;
}

/*** R
library(bigmemory)
r <- 100
c <- 10000
bm <- matrix(sample(0:4, r * c, replace = TRUE), r, c)
bm <- as.big.matrix(bm, type = "double")
bm[, 1]
to_one(bm@address)
bm[, 1]
*/
