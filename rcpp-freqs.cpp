#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
NumericVector get_freq(NumericVector x, NumericVector breaks) {
  int nbreaks = breaks.size();
  NumericVector out(nbreaks-1);
  for (int i=0; i<nbreaks-1; i++) {
    LogicalVector temp = (x>breaks(i)) & (x<=breaks(i+1));
    out[i] = sum(temp);
  }
  
  return(out);
}

/*** R
x <- 100
breaks <- seq(from=0, to=max(x)+1, length.out=101) 

get_freq_R <- function(x, breaks) {
  -diff(colSums(outer(x, breaks, '>')))
}
tmp <- runif(3000, 1, 100)
all.equal(get_freq(tmp, breaks), get_freq_R(tmp, breaks))

library(microbenchmark)
microbenchmark(get_freq(runif(100, 1, 100), breaks),
               get_freq(runif(1000, 1, 100), breaks),
               get_freq(runif(3000, 1, 100), breaks),
               get_freq_R(runif(100, 1, 100), breaks),
               get_freq_R(runif(1000, 1, 100), breaks),
               get_freq_R(runif(3000, 1, 100), breaks))
*/
