#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector toInt(RObject x) {
  return as<IntegerVector>(x);
}

/*** R
toInt(c(1.5, 2.4))
toInt(1:2 + 1)
*/
