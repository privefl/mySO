#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double sumSub(const NumericMatrix& x,
              const IntegerVector& colInd) {
  
  double sum = 0;
  
  for (IntegerVector::const_iterator it = colInd.begin(); it != colInd.end(); ++it) {
    int j = *it - 1;
    for (int i = 0; i < x.nrow(); i++) {
      sum += x(i, j);
    }
  }
  
  return sum;
}
