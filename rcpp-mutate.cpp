#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector fill_y(const NumericVector& x) {
  
  int n = x.length();
  NumericVector y(n); y[0] = 1;
  for (int i = 1; i < n; i++) {
    y[i] = pow(y[i - 1], 2) + x[i];
  }
  return y;
}

/*** R
# function to generate testdata

genDat <- function(id){
  
# observations per id, fixed or random
  n <- 50
#n <- round(runif(1,5,1000))
  
  return(
    
    data.frame(
      id = id,
      month=rep(1:12,ceiling(n/12))[1:n],x=round(rnorm(n,2,5)),y=rep(0,n))
  
  )
}

#generate testdata

testdat <- do.call(rbind,lapply(1:90000,genDat))
  
length(unique(testdat$id))
head(testdat)
str(testdat)
system.time(
  test <- testdat %>%
    group_by(id) %>%
    mutate(y2 = fill_y(x))
)
*/
