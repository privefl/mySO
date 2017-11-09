#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector self(NumericVector x) {
  return x;
}

// [[Rcpp::export]]
double self2(double x) {
  return x;
}

/*** R
self(42)
self(NA)
# devtools::install_github("ThinkR-open/seven31")
library(seven31)
reveal(NA, NA_integer_, NA_real_,
       self(NA), self(NA_integer_), self(NA_real_),
       self2(NA), self2(NA_integer_), self2(NA_real_))
*/
