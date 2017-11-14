#include <Rcpp.h>
#include <algorithm>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector test(NumericVector x, NumericVector y) {
  int n = x.size() + y.size();
  std::vector<int> v(n);
  std::vector<int>::iterator it;
  
  std::sort(x.begin(), x.end());
  std::sort(y.begin(), y.end());
  
  it=std::set_union(x.begin(), x.end(), y.begin(), y.end(), v.begin());
  v.resize(it-v.begin());
  
  return wrap(v);
}

/*** R
x <- sample(20000)
y <- sample(20000)
test(x, y)

for (i in rep(20e3, 100)) {
  print(i)
  Sys.sleep(0.1)
  test(sample(i), sample(i))
}
*/
