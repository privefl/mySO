#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector  myg(NumericVector x) 
{
  NumericVector  out;
  out = x / sqrt(1 + pow(x,2.0) );
  return out;
}

// [[Rcpp::export]]
NumericVector myg2(const NumericVector& x_) {
  
  int n = x_.size();
  NumericVector out(n);
  double x;
  
  for (int i = 0; i < n; i++) {
    x = x_[i];
    out[i] = x / sqrt(1 + x*x);
  }
  
  return out;
}



/*** R
library(microbenchmark)

myf <- function(x){
  temp <- (x)/sqrt(1+x^2)
  return(temp)
}

x <- seq(from=-6, to = 6, by=1e-4)

microbenchmark::microbenchmark(
  myf(x), 
  myg(x),
  myg2(x)
)
*/
