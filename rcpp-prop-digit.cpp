#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double prop_top_digit(const RawVector& x, int top_n_digits) {
  
  // counts occurence of each character
  IntegerVector counts(256);
  RawVector::const_iterator it;
  for(it = x.begin(); it != x.end(); ++it) counts[*it]--;
  // partially sort first top_n_digits (negative -> decreasing)
  IntegerVector::iterator it2 = counts.begin() + 48, it3;
  std::partial_sort(it2, it2 + top_n_digits, it2 + 10);
  // sum the first digits
  int top = 0;
  for(it3 = it2; it3 != (it2 + top_n_digits); ++it3) top += *it3;
  // add the rest -> sum all
  int div = top;
  for(; it3 != (it2 + 10); ++it3) div += *it3;
  // return the proportion
  return div == 0 ? 1 : top / (double)div;
}

/*** R
prop_top_digit(charToRaw('twos:22-222222222'), 2)
prop_top_digit(charToRaw(paste(sample(0:9, size = 1e4, replace = TRUE), collapse = "")), 3)
*/
