#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector test_names(int N, bool name){
  
  RNGScope scope;
  NumericVector data = runif(N, 1, 100);
  
  if(name)data.attr("names")=seq(1,N);
  
  return data;
}

/*** R
N <- 1e6
system.time(test_names(N, FALSE))
system.time(test_names(N, TRUE))
system.time(setNames(test_names(N, FALSE), seq_len(N)))
system.time(seq_len(N))
system.time(as.character(seq_len(N)))
*/
