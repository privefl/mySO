// [[Rcpp::depends(RcppArmadillo)]]
#define ARMA_DONT_PRINT_OPENMP_WARNING
#include <RcppArmadillo.h>
#include <RcppArmadilloExtensions/sample.h>
#include <set>
using namespace Rcpp;


int sample_one(int n) {
  return n * unif_rand();
} 

int sample_n_distinct(const IntegerVector& x, 
                      int k,
                      const int * pop_ptr) {
  
  IntegerVector ind_index = RcppArmadillo::sample(x, k, false); 
  std::set<int> distinct_container;
  
  for (int i = 0; i < k; i++) {
    distinct_container.insert(pop_ptr[ind_index[i]]);
  }
  
  return distinct_container.size();
}

// [[Rcpp::export]]
arma::Cube<int> fillCube(const arma::Cube<int>& pop,
                         const IntegerVector& specs,
                         int perms,
                         int K) {
  
  int N = specs.size();
  arma::Cube<int> res(perms, N, K);
  
  IntegerVector specs_C = specs - 1;
  const int * pop_ptr;
  int i, j, k;
  
  for (i = 0; i < K; i++) {
    for (k = 0; k < N; k++) {
      for (j = 0; j < perms; j++) {
        pop_ptr = &(pop(0, sample_one(perms), sample_one(K)));
        res(j, k, i) = sample_n_distinct(specs_C, k + 1, pop_ptr);
      }
    }
  }
  
  return res;
}
