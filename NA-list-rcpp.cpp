#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
bool checkNa(int i, List elemInCluster){
  
  try {
    return R_IsNA(elemInCluster[i]);
  } catch(...) {
    return false;
  }
}

/*** R
listToCheck <- list(NA, matrix(0,nrow = 2, ncol = 2))
checkNa(0, listToCheck)
checkNa(1, listToCheck)
*/
