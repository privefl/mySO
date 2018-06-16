#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
double sum_mat(const NumericMatrix& x) {
  
  double sum = 0;
  for (int j = 0; j < x.ncol(); j++)
    for (int i = 0; i < x.nrow(); i++)
      sum += x(i, j);
  
  return sum;
}

// [[Rcpp::export]]
double sum_mat2(const NumericMatrix& x) {
  
  double sum = 0;
  for (int j = 0; j < x.ncol(); ++j)
    for (int i = 0; i < x.nrow(); ++i)
      sum += x(i, j);
  
  return sum;
}


/*** R
N <- 1e3
mat <- matrix(runif(N * N), N)
all.equal(sum_mat(mat), sum_mat2(mat))

microbenchmark::microbenchmark(
  sum_mat(mat),
  sum_mat2(mat)
)
# Unit: microseconds
#           expr     min       lq     mean   median       uq      max neval cld
#   sum_mat(mat) 792.956 815.1385 873.1816 837.4865 887.9780 2092.805   100   a
#  sum_mat2(mat) 793.287 815.3040 880.6643 842.4530 912.1475 1746.820   100   a
*/
