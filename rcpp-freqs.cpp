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
x <- sample(10, size = 1e5, replace = TRUE)
breaks <- c(0.5, 1, 3, 9, 9.5, 10)
microbenchmark::microbenchmark(
  # hist(x, breaks)$counts, 
  table(cut(x, breaks)),
  -diff(colSums(outer(x, breaks, '>'))),
  get_freq(x, breaks)
)
table(cut(x, breaks))
-diff(colSums(outer(x, breaks, '>')))
get_freq(x, breaks)
*/
