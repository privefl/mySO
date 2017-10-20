#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
void list_remove_element(List x, int i) {
  Rcout << "Size before : " << x.size() << std::endl;
  // x.erase(i);
  x[i] = R_NilValue;
  Rcout << "Size after : " <<x.size() << std::endl;
}

// [[Rcpp::export]]
void list_remove_element2(List& x, int i) {
  Rcout << "Size before : " << x.size() << std::endl;
  x[i] = R_NilValue;
  Rcout << "Size after : " << x.size() << std::endl;
  // return x;
}



/*** R
u = list(a=1:5, b=3:4, c=5:6)
list_remove_element(u, 1)
str(u)
list_remove_element2(u, 1)
str(u)
*/
