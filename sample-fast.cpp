#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
IntegerVector get_first_unique(const IntegerVector& ind_sample, int N, int n) {
  
  LogicalVector is_chosen(N);
  IntegerVector ind_chosen(n);
  
  int i, k, ind;
  
  for (k = 0, i = 0; i < n; i++) {
    do { // rejection sampling
      ind = ind_sample[k++];
    } while (is_chosen[ind-1]);
    is_chosen[ind-1] = true;
    ind_chosen[i] = ind;
  }
  
  return ind_chosen;
}

