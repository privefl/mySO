// [[Rcpp::depends(RcppArmadillo, RcppEigen)]]
#include <RcppArmadillo.h>
#include <RcppEigen.h>

// [[Rcpp::export]]
arma::sp_mat extractDiag(const arma::sp_mat& x) {
  
  int n = x.n_rows;
  arma::sp_mat res(n, n);
  
  for (int i = 0; i < n; i++)
    res(i, i) = x(i, i);
  
  return res;
}

// [[Rcpp::export]]
arma::sp_mat extractDiag3(const arma::sp_mat& x) {
  return arma::diagmat(x);
}

// [[Rcpp::export]]
Eigen::SparseMatrix<double> extractDiag2(Eigen::Map<Eigen::SparseMatrix<double> > &X){
  
  int n = X.rows();
  Eigen::SparseMatrix<double> res(n, n);
  double d;
  
  typedef Eigen::Triplet<double> T;
  std::vector<T> tripletList;
  tripletList.reserve(n);
  for (int i = 0; i < n; i++) {
    d = X.coeff(i, i);
    if (d != 0) tripletList.push_back(T(i, i, d));
  }
  res.setFromTriplets(tripletList.begin(), tripletList.end());
  
  return res;
}

/*** R
library(Matrix)
set.seed(42)
nc <- nr <- 5
(m  <- rsparsematrix(nr, nc, nnz = 10))
extractDiag(m)
extractDiag3(m)
extractDiag2(m)
*/
