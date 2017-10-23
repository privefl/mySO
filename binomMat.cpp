// [[Rcpp::depends(RcppArmadillo)]]
#include <RcppArmadillo.h>
using namespace Rcpp;
using namespace arma;

// [[Rcpp::export]]
mat binom1(mat& prob){
  int n=prob.n_rows;
  mat sample(n,n,fill::zeros);
  NumericVector temp(2);
  
  for(int i(0);i<n-1;++i){
    for(int j(i+1);j<n;++j){
      temp=rbinom(2,1,prob(i,j));
      sample(i,j)=temp(0); sample(j,i)=temp(1);
    }
  }
  return sample;
}

// [[Rcpp::export]]
mat binom2(mat& prob){
  int n=prob.n_rows;
  mat sample(n,n);
  
  for(int i(0);i<n;++i){
    for(int j(0);j<n;++j){
      sample(i,j)=as<double>(rbinom(1,1,prob(i,j)));
    }
  }
  return sample;
}

// [[Rcpp::export]]
mat binom3(const mat& prob) {
  int n = prob.n_rows;
  mat sample(n, n);
  
  std::transform(prob.begin(), prob.end(), sample.begin(), 
                 [=](double p){ return R::rbinom(1, p); });
  
  return sample;
}

/*** R
z=matrix(runif(1000^2),1000) #just an example for 1000x1000 matrix
microbenchmark::microbenchmark(
  rbinom(length(z), 1, z),
  binom1(z),
  binom2(z),
  binom3(z)
)

test <- binom3(z)
dim(test)
test[1:5, 1:5]
*/
