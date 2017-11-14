#include <RcppArmadillo.h>
using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
double kaiser(arma::mat A) {
  int n_count = A.n_rows;
  std::vector<double> w(n_count);
  int n_neigh = 0;
  
  for(int i = 0; i < n_count; i++) {
    arma::rowvec bla = A.row(i) + A.col(i).t();
    arma::uvec n = unique(find(bla > 0));
    int n_e = 0;
    int l_n = n.n_elem;
    for(int j = 0; j < l_n; j++) {
      arma::colvec vec = A.row(n(j)).t();
      arma::uvec n_v = unique(find(vec > 0));
      IntegerVector uni = union_(as<IntegerVector>(wrap(n)), as<IntegerVector>(wrap(n_v)));
      n_e = n_e + l_n + n_v.n_elem - uni.size();
      // Rcout << n_e << std::endl;
    }
    if(l_n > 1) {
      w[i] =  (double)n_e / (l_n * (l_n - 1));
      n_neigh++;
    }
  }
  double s = std::accumulate(w.begin(), w.end(), 0.0);
  double cl = s / n_neigh;
  
  // Rcout << as<NumericVector>(wrap(w)) << std::endl;
  
  return(cl);
}


/*** R
# R equivalent of MATLAB find function
# Find indices of nonzero elements in a vector
rfind <- function(adj) seq(along = adj)[adj != 0]

# Main function
cc_kaiser <- function(adj) {
  n_count <- nrow(adj)
  w <- rep(0, n_count)
  # Number of nodes with at least two neighbors
  n_neigh = 0
  for (i in 1:n_count) {
    n <- rfind(adj[i, ] + t(adj[, i]))
    n_e <- 0
    l_n <- length(n)
    for (j in 1:l_n) {
      vec <- t(as.matrix(adj[n[j], ]))
      n_v <- rfind(vec)
      n_e <- n_e + l_n + length(n_v) - length(union(n, n_v))
    }
    if (l_n > 1) {
      w[i] <- n_e / (l_n * (l_n - 1))
      n_neigh <- n_neigh + 1
    }
  }
  print(w)
  cl <- sum(w) / n_neigh
  return(cl)
}

A <- matrix(c(0,1,1,0,1,0,1,1,1,1,0,0,0,1,0,0), 4, 4)
cc_kaiser(A)
kaiser(A)
*/
