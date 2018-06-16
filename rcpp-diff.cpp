#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
NumericVector diff_sug(NumericVector x) {
  return Rcpp::diff(x);
}

/*** R
(tmp <- diff_sug(1:10 + 0))
length(tmp)
*/
