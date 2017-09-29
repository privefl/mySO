#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
bool isOneDiff(const StringVector& w1,
               const StringVector& w2) {
  
  int i, n = w1.size();
  
  for (i = 0; i < n; i++) if (w1[i] != w2[i]) break;
  for (     ; i < n; i++) if (w1[i] != w2[i+1]) return false;
  
  return true;
}


/*** R
isOneDiff(c("EY", "Z"), c("M", "EY", "Z"))
isOneDiff(c("EY", "Z"), c("EY", "D", "Z"))
isOneDiff(c("EY", "Z"), c("Z", "EY", "D"))
*/
