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
    int n_e = 0;
    int l_n = sum(bla > 0);
    for(int j = 0; j < l_n; j++) {
      arma::colvec vec = A.row(n(j)).t();
      int l_n_v = sum(vec > 0)
      int uni = sum(bla > 0 & vec > 0);
      n_e = n_e + l_n + l_n_v - uni;
    }
    if(l_n > 1) {
      w.at(i) =  (double)n_e / (l_n * (l_n - 1));
      n_neigh++ ;
    }
  }
  double s = std::accumulate(w.begin(), w.end(), 0.0);
  double cl = s / n_neigh;
  
  return(cl);
}

/*** R
library(igraph)

g <- erdos.renyi.game(1000, 0.2)
adj <- get.adjacency(g, sparse = FALSE)
kaiser(adj)
*/
