#include <RcppEigen.h>
// [[Rcpp::depends(RcppEigen)]]

using Eigen::Map;
using Eigen::MatrixXd;
using Eigen::VectorXd;
using Eigen::SparseMatrix;
using Eigen::MappedSparseMatrix;
using Eigen::SparseVector;
using Eigen::Triplet;
using namespace Rcpp;
using namespace Eigen;

// [[Rcpp::export]]
Eigen::SparseVector<double> getSparseVec(const Eigen::SparseMatrix<double>& X) {
  return *(X.row(1));
}

/*** R
library(Matrix)
mat <- rsparsematrix(100, 100, 0.2)

getSparseVec(mat)
*/
