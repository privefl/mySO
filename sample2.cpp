#include <RcppArmadilloExtensions/sample.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;

bool contains(const IntegerVector& X, int j) { 
  return std::find(X.begin(), X.end(), j) != X.end(); 
}

// [[Rcpp::export]]
IntegerMatrix sample2(int N) {
  IntegerVector frame = seq_len(N);
  IntegerMatrix res(2 * N, 2);
  IntegerVector cols(2);
  for (int j = 0; j < N; j++) {
    res(2 * j, 0) = res(2 * j + 1, 0) = j + 1;
    
    cols = RcppArmadillo::sample(frame, 2, FALSE, 
                                 NumericVector::create());
    while (contains(cols, j + 1)) {
      // Rcout << "j = " << j << " , cols = " << cols << std::endl;
      cols = RcppArmadillo::sample(frame, 2, FALSE);
    }
    
    res(2 * j, 1) = cols[0];
    res(2 * j + 1, 1) = cols[1];
  }
  
  return res;
}



/*** R
library(Matrix)
N <- 20e3
m <- Matrix(0, nrow = N, ncol = N)
test <- sample2(N)
m[test[order(test[, 2], test[, 1]), ]] <- 1

microbenchmark::microbenchmark(
  # OP = {
  #   desired_output <- Matrix(0, nrow = N, ncol = N)
  #   set.seed(1)
  #   for(j in 1:N) {
  #     cols <- sample((1:N)[-j], 2) #Choose 2 columns not equal to the 
  #     desired_output[j, cols] <- 1
  #   }
  # },
  Aurele = {
    res <- Matrix(0, nrow = N, ncol = N)
    set.seed(1)
    ind <- cbind(rep(1:N, each = 2), c(sapply(1:N, function(j) sample((1:N)[-j], 2))))
    res[ind] <- 1
  },
  privefl = {
    m <- Matrix(0, nrow = N, ncol = N)
    test <- sample2(N)
    m[test[order(test[, 2], test[, 1]), ]] <- 1
  },
  privefl2 = {
    m <- Matrix(0, nrow = N, ncol = N)
    m[sample2(N)] <- 1
  },
  times = 20
)
*/
