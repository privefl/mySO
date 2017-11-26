#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
CharacterMatrix dup_shift(CharacterMatrix& x) {
  
  int n = x.nrow();
  int m = x.ncol();
  int i, j, n2;
  
  CharacterVector col_unique;
  
  for (j = 0; j < m; j++) {
    col_unique = unique(x.column(j), false);
    n2 = col_unique.size();
    for (i = 0; i < n2; i++) x(i, j) = col_unique(i);
    for (     ; i < n;  i++) x(i, j) = NA_STRING;
  }
  
  return transpose(x);
}


/*** R
temp <- data.frame(list(col1 = c("424", "560", "557"), 
                        col2 = c("276", "427", "V46"), 
                        col3 = c("780", "V45", "584"), 
                        col4 = c("276", "V45", "995"), 
                        col5 = c("428", "799", "427")),
                   stringsAsFactors = FALSE)
(temp <- dup_shift(t(temp)))
*/
