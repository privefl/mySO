// [[Rcpp::depends(BH)]]
#include <Rcpp.h>
#include <boost/foreach.hpp>
using namespace Rcpp;

// the C-style upper-case macro name is a bit ugly
#define foreach BOOST_FOREACH

// [[Rcpp::export]]
ListOf<IntegerVector> new_vars(const IntegerVector& Var1,
                               const IntegerVector& Var2,
                               int n_Var,
                               ListOf<IntegerVector> ind_groups) {
  
  int nrow = Var1.size();
  IntegerVector new_var1a(nrow, NA_INTEGER); 
  IntegerVector new_var2a(nrow, NA_INTEGER); 
  
  for (int i = 0; i < ind_groups.size(); i++) {
    IntegerVector counts(n_Var);
    foreach(const int& j, ind_groups[i]) {
      new_var1a[j] = ++counts[Var1[j]];
      new_var2a[j] = ++counts[Var2[j]];
    }
  }
  
  return List::create(Named("new_var1a") = new_var1a, 
                      Named("new_var2a") = new_var2a);
}


/*** R
x <- expand.grid(letters[1:5],letters[1:5],
                 KEEP.OUT.ATTRS = FALSE, 
                 stringsAsFactors = FALSE)
x <- x[x[,1]!=x[,2],c(2,1)]
x <- data.frame(x,group=as.character(rep(letters[c(1,2,1,4,1)+5],each=4)))
x <- data.frame(x,new_var1 = c(1,2,3,4,1,2,3,4,2,3,4,5,1,2,3,4,3,4,5,6))
x <- data.frame(x,new_var2 = c(1,1,1,1,1,1,1,1,5,2,2,2,1,1,1,1,6,3,6,3))
  
  
getNewVars <- function(x) {
  
  Vars.levels <- unique(c(x$Var2, x$Var1))
  
  new_vars <- new_vars(
      Var1 = match(x$Var1, Vars.levels) - 1,
      Var2 = match(x$Var2, Vars.levels) - 1,
      n_Var = length(Vars.levels), 
      ind_groups = split(seq_along(x$group) - 1, x$group)
  )
  
  cbind(x, new_vars)
}

getNewVars(x)
*/
