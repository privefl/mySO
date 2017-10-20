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


// [[Rcpp::export]]
IntegerVector noDynProg2(const NumericVector& S,
                         NumericVector& D, 
                         double min0, int p0, int q0) {
  
  int n = S.size(), p, q, ind;
  int my_p = p0 - 1, my_q = q0 - 1;
  
  double S_star = S[n-1] / 3, S1, S2, S3;
  double min = min0;
  
  int c = 0;
  
  for (q = 1; q < (n-1); q++) {
    S3 = S[n-1] - S[q] - S_star;
    if (S3*S3 < min) {
      c++;
      for (p = 0; p < q; p++) {
        S1 = S[p] - S_star;
        S2 = S[q] - S[p] - S_star;
        D[p] = S1*S1 + S2*S2 + S3*S3;
      }
      ind = which_min(D);
      if (D[ind] < min) {
        my_p = ind;
        my_q = q;
        min = D[ind];
      }
    }
  }
  
  Rcout << c << std::endl;
  
  IntegerVector res(2);
  res(0) = my_p;
  res(1) = my_q;
  
  return res + 1;
}
