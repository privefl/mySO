#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix test(NumericMatrix& M, int col, IntegerVector& rand) {
  NumericMatrix M2(col,col);
  for(int a=0;a<col;a++){
    for(int b=a+1;b<col;b++){
      M2(b,a)=M(rand(b),rand(a));
      M2(a,b)=M(rand(a),rand(b));
    }
  }
  return M2;   
}

// [[Rcpp::export]]
NumericMatrix test2(const NumericMatrix& M, const IntegerVector& ind) {
  
  int col = M.ncol();
  NumericMatrix M2(col, col);
  
  for (int j = 0; j < col; j++)
    for (int i = 0; i < col; i++)
      M2(i, j) = M(ind[i], ind[j]);
  
  return M2;   
}


/*** R
N <- 500
m <- matrix(sample(c(0:9), N * N, TRUE), ncol = N, nrow = N)
diag(m) <- 0
rand <- sample(N)

all.equal(test(m, ncol(m), rand - 1), m[rand, rand], test2(m, rand - 1))

microbenchmark::microbenchmark(
  test(m, ncol(m), rand - 1),
  m[rand, rand],
  test2(m, rand - 1)
)
*/
