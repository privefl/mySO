#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector f_Rcpp(List data) {
  
  StringVector      x1 = data["x1"]; 
  StringVector      x2 = data["x2"]; 
  NumericVector     x3 = data["x3"];
  NumericVector     x4 = data["x4"];
  NumericVector value1 = data["value1"];
  NumericVector value2 = data["value2"];
  
  int n = value1.size();
  NumericVector diff(n, NA_REAL);
  
  int i, j;
  
  for (i = 0; i < n; i++) {
    Rprintf("%d\n", i);
    if (x4[i] != NA_REAL) {
      if (x4[i] == x3[i]) {
        diff[i] = value1[i] - value2[i];
      } else {
        Rprintf("I am in else\n");
        for (j = 0; j < n; j++) {
          Rprintf("%d %d\n", i, j);
          if (x4[i] == x3[j] && x1[i] == x1[j] && x2[i] == x2[j]) {
            diff[i] = value1[j] - value2[i];
            break;
          }
        }
      }
    }
  }
  
  return diff;
}

/*** R
data <- data.frame(x1=c(rep('a',12)),
                   x2=c(rep('b',12)),
                   x3=c(rep(as.Date('2017-03-09'),4),rep(as.Date('2017-03-10'),4),rep(as.Date('2017-03-11'),4)),
                   value1= seq(201,212),
                   x4=c(as.Date('2017-03-09'),as.Date('2017-03-10'),as.Date('2017-03-11'),as.Date('2017-03-12')
                          ,as.Date('2017-03-10'),as.Date('2017-03-11'),as.Date('2017-03-12'),as.Date('2017-03-13')
                          ,as.Date('2017-03-11'),as.Date('2017-03-12'),as.Date('2017-03-13'),as.Date('2017-03-14')),
                          value2= seq(101,112), stringsAsFactors = FALSE)
  
f_Rcpp(data)
*/
