#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::List buildFacts(DataFrame  dt) {
  
  int rows             = dt.nrow();
  NumericVector dpid   = dt["id"];
  for (int idx = 0; idx < rows; idx++) {
    int pos = dpid[idx];
    
    //DataFrame time = dt[id == pos]$B // this is where the error comes
    DataFrame position = dt["id"][pos]$PositionDimension;
  }
  return Rcpp::List::create(Named("result") = 1);
}


/*** R
dt = data.table(id = c(1,2,3), A = c('A', 'B', 'C'),
                B = c('Yesterday', 'Today', 'Tomorrow'))
*/
