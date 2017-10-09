#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double maxllC3(const double mu){
  double result;
  result= R::dgamma(mu,0.1,1,0.1);
  return result;
}
