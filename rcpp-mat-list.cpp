#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
ListOf<IntegerMatrix> test_list(int J, int nmax) {
  
  ListOf<IntegerMatrix> zb_list(3);
  IntegerMatrix tb(J,nmax), zb(J,nmax);
  
  for (int itr = 0; itr < 3; itr++) {
    // zb_list[itr] = zb;
    // Rcout <<  zb_list[itr] << "\n";
    Rcout <<  zb << "\n\n";
  }
  
  return zb_list;
}

/*** R
test_list(4, 5)
*/
