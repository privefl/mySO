// [[Rcpp::depends(RcppGSL)]]
#include <RcppGSL.h>
#include <gsl/gsl_matrix.h>

// [[Rcpp::export]]
gsl_matrix_const_view submatrix(RcppGSL::Matrix & X, int k1, int k2, int n1, int n2) {
  X(0, 0) = 1;
  return gsl_matrix_const_submatrix(X, k1, k2, n1, n2);
}

/*** R
M <- matrix(0, 1000, 1000)
test <- submatrix(M, 0, 0, 1000, 900)
M[1, 1]
# microbenchmark::microbenchmark(
#   M[, 1:900],
#   submatrix(M, 0, 0, 1000, 900)
# )
*/
