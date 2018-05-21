#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
double pow2(double x) {
  return pow(x, 2);
}

/*** R
pow2(4.2)
*/
