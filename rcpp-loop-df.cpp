#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector name_me(List df, double nsec) {
  
  NumericVector TimeStmp = df["TimeStmp"];
  NumericVector B        = df["B"];
  int n = B.size();
  int i, j, k, ndup;
  double time;
  
  NumericVector res(n);
  
  for (i = 0; i < n; i++) {
    
    // get last for same second
    for (ndup = 0; (i+1) < n; i++, ndup++) {
      if (TimeStmp[i+1] != TimeStmp[i]) break;
    }
    
    // get last value within nsec
    time = TimeStmp[i] + nsec;
    for (j = i+1; j < n; j++) {
      if (TimeStmp[j] > time) break;
    }
    
    // fill all previous ones with same value
    res[i] = (j == (i+1)) ? NA_REAL : B[j-1];
    for (k = 1; k <= ndup; k++) res[i-k] = res[i];
  }
  
  return res;
}


/*** R
name_me(df, 1)
name_me(df, 3)
*/
