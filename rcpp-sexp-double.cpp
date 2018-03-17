// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
using namespace Rcpp;


SEXP callFunction(Function func){
  SEXP res = func();
  return(res);
}

// [[Rcpp::export]]
NumericVector func1(Function func, is_float = false){
  for(int i=0; i<10; i++){
    NumericVector vect(10);
    vect[i] = callFunction(func);
  }
  return(vect);
}

/*** R
func1(mean)
*/
