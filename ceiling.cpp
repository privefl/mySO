#include <Rcpp.h>
using namespace Rcpp;
using std::size_t;

// [[Rcpp::export]]
inline size_t my_ceil(size_t n) {
  return (n + 3) / 4;
}

/*** R
all.equal(sapply(0:10, my_ceil), ceiling(0:10 / 4))
*/
