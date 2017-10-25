#include <Rcpp.h>
using namespace Rcpp;

#include <Rcpp.h>

using namespace Rcpp;

/******************************************************************************/

// [[Rcpp::export]]
NumericVector pMatVec4_2(const NumericMatrix& macc, const NumericVector& x) {
  
  int n = macc.nrow();
  int m = macc.ncol();
  
  IntegerVector m_nona(n, m);
  NumericVector res(n);
  int i, j;
  double y;
  
  for (j = 0; j < m; j++) {
    for (i = 0; i < n; i++) {
      y = macc(i, j);
      if (R_IsNA(y)) {
        m_nona[i]--;
      } else {
        res[i] += x[j] * y;
      }
    }
  }
  for (i = 0; i < n; i++) res[i] /= m_nona[i];
  
  return res;
}

// [[Rcpp::export]]
NumericVector pMatVec4(const NumericMatrix& macc, const NumericVector& x) {
  
  int n = macc.nrow();
  int m = macc.ncol();
  
  IntegerVector m_nona(n, m);
  NumericVector res(n);
  int i, j;
  double y;
  
  for (j = 0; j < m; j++) {
    for (i = 0; i < n; i++) {
      y = macc(i, j);
      if (R_IsNA(y)) {
        m_nona[i]--;
      } else {
        res[i] += x[j] * y;
      }
    }
  }
  for (i = 0; i < n; i++) res[i] /= sqrt(m_nona[i]);
  
  return res;
}

/******************************************************************************/

// [[Rcpp::export]]
NumericVector cpMatVec4_2(const NumericMatrix& macc, const NumericVector& x) {
  
  int n = macc.nrow();
  int m = macc.ncol();
  
  NumericVector res(m);
  double tmp, y;
  int i, j, n_nona;
  
  // WARNING: do not use std::size_t because of `n - 4`
  for (j = 0; j < m; j++) {
    tmp = 0;
    n_nona = n;
    for (i = 0; i < n; i++) {
      y = macc(i, j);
      if (R_IsNA(y)) {
        n_nona--;
      } else {
        tmp += y * x[i];
      }
    }
    res[j] = tmp / n_nona;
  }
  
  return res;
}
// [[Rcpp::export]]
NumericVector cpMatVec4(const NumericMatrix& macc, const NumericVector& x) {
  
  int n = macc.nrow();
  int m = macc.ncol();
  
  NumericVector res(m);
  double tmp, y;
  int i, j, n_nona;
  
  // WARNING: do not use std::size_t because of `n - 4`
  for (j = 0; j < m; j++) {
    tmp = 0;
    n_nona = n;
    for (i = 0; i < n; i++) {
      y = macc(i, j);
      if (R_IsNA(y)) {
        n_nona--;
      } else {
        tmp += y * x[i];
      }
    }
    res[j] = tmp / sqrt(n_nona);
  }
  
  return res;
}
