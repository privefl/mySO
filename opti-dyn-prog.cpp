#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector dynProg(const NumericVector& v,
                      const NumericVector& S,
                      NumericVector& D,
                      const NumericVector& D_init) {
  
  int n = v.size(), p, q, ind;
  
  double min = R_PosInf;
  int my_p = -1, my_q = -1;
  
  for (q = 1; q < (n-1); q++) {
    D[0] = D_init[q];
    for (p = 1; p < q; p++) {
      D[p] = D[p-1] + 2 * v[p] * (v[p] + 2 * S[p-1] - S[q]);
    }
    ind = which_min(D);
    if (D[ind] < min) {
      my_p = ind;
      my_q = q;
      min = D[ind];
    }
  }
  
  IntegerVector res(2);
  res(0) = my_p;
  res(1) = my_q;
  
  return res + 1;
}
