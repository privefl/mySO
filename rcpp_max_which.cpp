#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector min_ind_which(const NumericVector& x, double thr) {
  
  double sum = 0;
  
  for (int i = 0; i < x.size(); i++) {
    sum += x[i];
    if (sum >= thr) return IntegerVector::create(i + 1);
  }
  
  return IntegerVector::create();
}

/*** R
x <- runif(100)
min(which(cumsum(x) > 10))
min_ind_which(x, 10)
min(which(cumsum(x) > 100))
min_ind_which(x, 100)
*/
