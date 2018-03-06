#include <Rcpp.h>
using namespace Rcpp;

#include <Rcpp.h>
using namespace Rcpp;

//
//' Add two numbers 
//'
//' @param x An integer.
//' @param y An integer
// [[Rcpp::export]]
int add(int x, int y) {
  return x + y;
}

/*** R
Numbers <- R6::R6Class(
  "Number",
  private = list(
    a = 6,
    b = 10
  ),
  public = list(
    add_ab = function() {
      add(private$a, private$b)
    }
  ) 
)
# Example
num <- Numbers$new()
num$add_ab()
*/
