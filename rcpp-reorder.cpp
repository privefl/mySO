#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector reorder(const NumericVector& x,
                      const NumericVector& y) {
  Rcpp::
  return order(y);
}


/*** R
A=c(0.5,0.4,0.2,0.9)
B=c(9,1,3,5)
C=A[order(B)]
reorder(A, B)
*/
