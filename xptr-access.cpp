#include <Rcpp.h>
using namespace Rcpp;

class myclass {
private:
  int k;
public:
  myclass(int n) : k(n){}
  int getk() const {return k;}
};

// [[Rcpp::export]]
SEXP new_myclass(int n) {
  XPtr<myclass> ptr(new myclass(n), true);
  return ptr;
}

// [[Rcpp::export]]
int getk(SEXP xpsexp){
  XPtr<myclass> xp(xpsexp);
  return xp->getk();
}


/*** R
library(Rcpp)

ptr <- new_myclass(11)

getk(ptr)
*/
