#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
LogicalVector timesTwo(NumericVector x) {
  return x == NA_REAL;
}


/*** R
timesTwo(c(1, 2, NA, NA_real_))
*/
