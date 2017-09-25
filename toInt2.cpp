#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector fprive(const RObject & x) {
  NumericVector nv(x);
  IntegerVector iv(x);
  if (is_true(any(nv != NumericVector(iv)))) warning("Uh-oh");
  return(iv);
}

// [[Rcpp::export]]
IntegerVector toInt2(const NumericVector& x) {
  for (int i = 0; i < x.size(); i++) {
    if (x[i] != (int)x[i]) {
      warning("Uh-oh");
      break;
    }
  }
  return as<IntegerVector>(x);
}

// [[Rcpp::export]]
IntegerVector toInt3(const RObject& x) {
  NumericVector nv(x);
  for (int i = 0; i < nv.size(); i++) {
    if (nv[i] != (int)nv[i]) {
      warning("Uh-oh");
      break;
    }
  }
  return as<IntegerVector>(x);
}

// [[Rcpp::export]]
SEXP toInt4(const RObject& x) {
  if (TYPEOF(x) == INTSXP) return x;
  
  NumericVector nv(x);
  int i, n = nv.size();
  IntegerVector res(n);
  for (i = 0; i < n; i++) {
    res[i] = nv[i];
    if (nv[i] != res[i]) {
      warning("Uh-oh");
      break;
    }
  }
  for (; i < n; i++) res[i] = nv[i];
  
  return res;
}

/*** R
fprive(c(1.5, 2))
fprive(c(1L, 2L))

toInt2(c(1.5, 2))
toInt2(c(1L, 2L))

x <- seq_len(1e7)
x2 <- x; x2[1] <- 1.5
x3 <- x; x3[length(x3)] <- 1.5
microbenchmark::microbenchmark(
  fprive(x),  toInt2(x),  toInt3(x),  toInt4(x),
  fprive(x2), toInt2(x2), toInt3(x2), toInt4(x2),
  fprive(x3), toInt2(x3), toInt3(x3), toInt4(x3),
  times = 20
)

identical(toInt3(x), fprive(x))
identical(toInt3(x2), fprive(x2))
identical(toInt3(x3), fprive(x3))

# system.time(x2 <- fprive(x))
# system.time(x3 <- toInt2(x))
# identical(x3, x2)
# system.time(x4 <- toInt3(x))
# identical(x4, x2)
# 
# x[1] <- 1.5
# 
# system.time(x2 <- fprive(x))
# system.time(x3 <- toInt2(x))
# identical(x3, x2)
# system.time(x4 <- toInt3(x))
# identical(x4, x2)
*/