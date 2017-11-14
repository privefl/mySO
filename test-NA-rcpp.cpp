#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int nb_na(const NumericVector& x) {
  int n = x.size();
  int c = 0;
  for (int i = 0; i < n; i++) if (R_IsNA(x[i])) c++;
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

// [[Rcpp::export]]
int nb_na4(const NumericVector& x) {
  int n = x.size();
  int c = 0;
  for (int i = 0; i < n; i++) c += NumericVector::is_na(x[i]) ;
  return c;
}

// [[Rcpp::export]]
int nb_na5(const NumericVector& x) {
  return std::count_if(x.begin(), x.end(), NumericVector::is_na ) ;
}

// [[Rcpp::export]]
int nb_na7( const NumericVector& x){
  const long long* p = reinterpret_cast<const long long*>(x.begin()) ;
  long long na = *reinterpret_cast<long long*>(&NA_REAL) ;
  
  return std::count(p, p + x.size(), na ) ;
  
}


// // [[Rcpp::export]]
// int nb_na6(const NumericVector& x) {
//   return tbb::parallel_reduce( 
//     tbb::blocked_range<const double*>(x.begin(), x.end()),
//     0, 
//     [](const tbb::blocked_range<const double*>& r, int init) -> int {
//       return init + std::count_if( r.begin(), r.end(), NumericVector::is_na );
//     }, 
//     []( int x, int y){ return x+y; }
//   ) ;
// }

/*** R
x <- rep(c(1, 2, NA), 1e5)
x2 <- replace(x, is.na(x), 3)
microbenchmark::microbenchmark(
  nb_na(x),
  nb_na4(x),
  nb_na5(x),
  nb_na7(x),
  # nb_na6(x),
  nb_na3(x2)
)
all.equal(nb_na(x), nb_na3(x2))
all.equal(nb_na9(x), nb_na3(x2))

na_real(x[1:3])
*/
