#include <Rcpp.h>

using namespace Rcpp;
// [[Rcpp::export]]
IntegerVector fibo_sam(int n) {
  IntegerVector x;
  x.push_back(1);
  x.push_back(2);
  for(int i =2; i < n; i++){
    x.push_back(x[i - 2] + x[i-1]);
  }
  return(x);
}

// [[Rcpp::export]]
IntegerVector fibo_sam2(int n) {
  IntegerVector x(n);
  x[0] = 1;
  x[1] = 2;
  for (int i = 2; i < n; i++){
    x[i] = x[i-2] + x[i-1];
  }
  return(x);
}


/*** R
fibo = function (n){
  x = rep(0, n)
  x[1] = 1
  x[2] = 2
  
  for(i in 3:n){
    x[i] = x[i-2] + x[i-1]
  }
  return(x)
}

microbenchmark::microbenchmark(
  fibo(1000),
  fibo_sam(1000),
  fibo_sam2(1000)
)
*/
