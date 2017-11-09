#include <Rcpp.h>
using namespace Rcpp;

inline bool myisna(const double * x, const double * na) {
  return memcmp(x, na, 4) == 0;
}

// [[Rcpp::export]]
int nb_na(const NumericVector& x) {
  int n = x.size();
  int c = 0;
  for (int i = 0; i < n; i++) if (R_IsNA(x[i])) c++;
  return c;
}

// [[Rcpp::export]]
int nb_na2(const NumericVector& x) {
  double na = NA_REAL;
  const double * na_ptr = &na;
  const double * test = &(x[0]);
  int n = x.size();
  int c = 0;
  
  for (int i = 0; i < n; i++) if (myisna(test, na_ptr)) c++;
  return c;
}

// [[Rcpp::export]]
int nb_na2_2(const NumericVector& x) {
  double na = NA_REAL;
  const double * na_ptr = &na;
  int c = 0;
  const double * it = reinterpret_cast<const double *>(x);
  for (it = x.begin(); it != x.end(); ++it) 
    if (myisna(it, na_ptr)) c++;
  return c;
}

// [[Rcpp::export]]
int nb_na3(const NumericVector& x) {
  int n = x.size();
  int c = 0;
  for (int i = 0; i < n; i++) if (x[i] == 3) c++;
  return c;
}

// [[Rcpp::export]]
LogicalVector na_real(NumericVector x) {
  return x == NA_REAL;
}


/*** R
x <- rep(c(1, 2, NA), 1e4)
x2 <- replace(x, is.na(x), 3)
microbenchmark::microbenchmark(
  nb_na(x),
  nb_na2(x),
  nb_na2_2(x),
  nb_na3(x2)
)
all.equal(nb_na(x), nb_na3(x2))
all.equal(nb_na(x), nb_na2(x))
all.equal(nb_na(x), nb_na2_2(x))
*/
