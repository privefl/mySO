#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector rngCppScalar() {
  NumericVector x(4);
  x[0] = R::runif(0,1.2);
  x[1] = R::rnorm(0,1.2);
  x[2] = R::rt(5);
  x[3] = R::rbeta(1,1.2);
  return(x);
}

// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically 
// run after the compilation.
//

/*** R
set.seed(42)
v1 <- rngCppScalar()
v1
set.seed(42)
v2 <-c(runif(1, max = 1.2), rnorm(1,0,1.2), rt(1,5), rbeta(1,1,1.2))
v2
*/
