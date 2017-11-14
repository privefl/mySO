#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
LogicalVector fastMove(const NumericVector& time,
                       const NumericVector& value,
                       double nsec = 60,
                       double nval = 5) {
  
  int n = time.size();
  LogicalVector fast_move(n);
  
  int i, j;
  double tmin, vmin, vmax;
  
  for (i = n - 1; i > 0; i--) {
    tmin = time[i] - nsec;
    vmin = value[i] - nval;
    vmax = value[i] + nval;
    for (j = i - 1; j > 0; j--) {
      if (time[j] < tmin) break;
      if (value[j] < vmin || value[j] > vmax) {
        fast_move[i] = true;
        break;
      }
    }
  }
  
  return fast_move;
}


/*** R

*/
