#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector genExp(int N) {
  
  NumericVector res(N);
  double prev;
  
  res[0] = unif_rand();
  for (int i = 1; i < N; i++) {
    prev = res[i-1];
    res[i] = prev + exp_rand() / prev;
  }
  
  return res;
}

/*** R
genExp(1e7)

OP <- function(N) {
  #Preallocate
  x <- rep(0, times=N)
  
#Set a starting seed
  x[1] <- runif(1)
  
  for(i in 2:N) {
#Do some calculations
    x[i] <- x[i-1] + rexp(1, x[i-1])  #Bottleneck
#Do some more calculations
  }
  x
}

gregor <- function(N) {
  draws = rexp(N)
  x <- numeric(N)
  x[1] <- runif(1)
  for(i in 2:N) {
#Do some calculations
    x[i] <- x[i-1] + draws[i] / x[i-1] 
#Do some more calculations
  }
  x
}

N <- 1e7
microbenchmark::microbenchmark(
  draw_up_front = gregor(N),
  # draw_one_at_time = OP(N),
  rcpp = genExp(N),
  times = 20
)
*/
