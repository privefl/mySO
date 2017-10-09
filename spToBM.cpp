// [[Rcpp::depends(bigmemory, BH)]]
#include <bigmemory/MatrixAccessor.hpp>
#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
void sp2BM(const S4& source,
           XPtr<BigMatrix> dest) {
  
  MatrixAccessor<double> macc(*dest);
  int _ncol = macc.ncol();
  
  NumericVector _pX = source.slot("x");
  NumericVector _pI = source.slot("i");
  double *_pI0 = &(_pI[0]);
  NumericVector _p  = source.slot("p");
  
  NumericVector res(_ncol);
  double *it, *lo, *up;
  
  for (int j = 0; j < _ncol; j++) {
    lo = &(_pI[_p[j]]);
    up = &(_pI[_p[j+1]]);
    for (it = lo; it < up; it++) {
      macc[j][(int)(*it)] = _pX[it - _pI0];
    }
  }
}
