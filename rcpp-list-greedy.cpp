#include <Rcpp.h>
#include <time.h>
using namespace Rcpp;

// [[Rcpp::export]]
List create_groups2(const NumericVector& x, double thr) {
  
  int n = x.size();
  List res(n);
  int c = 0;
  double sum;
  
  std::list<double> x2(n);
  std::copy(x.begin(), x.end(), x2.begin()); // copy x in x2
  x2.sort(std::greater<double>()); // sort in descending order
  std::list<double>::iterator it;
  
  while (x2.size()) {
    sum = 0;
    std::vector<double> x3;
    for (it = x2.begin(); it != x2.end();) {
      if ((sum + *it) <= thr) {
        sum += *it;
        x3.push_back(*it);
        it = x2.erase(it);
        if (sum >= thr) break;
      } else {
        it++;
      }
    }
    NumericVector x4(x3.size());
    std::copy(x3.begin(), x3.end(), x4.begin());
    res[c] = x4;
    c++; 
  }
  
  return res[seq_len(c) - 1];
}

// [[Rcpp::export]]
List create_groups3(const NumericVector& x, double thr) {
  
  time_t time1 = time(NULL), time2; Rcout << time1 << std::endl;
  double seconds;
  
  int n = x.size();
  List res(n);
  int c = 0;
  double sum;
  
  std::list<double> x2(n);
  std::copy(x.begin(), x.end(), x2.begin()); // copy x in x2
  // x2.sort(std::greater<double>()); // sort in descending order
  std::list<double>::iterator it;
  NumericVector x3(n);
  int i = 0, c2;
  
  time(&time2);
  seconds = difftime(time2, time1); Rcout << seconds << std::endl;
  
  while (x2.size()) {
    sum = 0; c2 = 0;
    for (it = x2.begin(); it != x2.end();) {
      if ((sum + *it) <= thr) {
        sum += *it;
        x3[i] = *it;
        i++; c2++;
        it = x2.erase(it);
        if (sum >= thr) break;
      } else {
        it++;
      }
    }
    res[c] = x3[seq(i - c2, i - 1)];
    c++; 
  }
  
  return res[seq_len(c) - 1];
}

/*** R
# y <- c(18, 15, 11, 9, 8, 7)
# create_groups2(sample(y), 34)
# 
# create_groups <- function(input, threshold) {
#   input <- sort(input, decreasing = TRUE)
#   result <- vector("list", length(input))
#   sums <- rep(0, length(input))
#   for (k in input) {
#     i <- match(TRUE, sums + k <= threshold)
#     if (!is.na(i)) {
#       result[[i]] <- c(result[[i]], k)
#       sums[i] <- sums[i] + k
#     }
#   }
#   result[sapply(result, is.null)] <- NULL
#   result
# }
# 
# x_big <- round(runif(1e4, min = 1, max = 34))
# all.equal(create_groups(x_big, 34), create_groups2(x_big, 34)) 
# all.equal(create_groups(x_big, 34), create_groups3(sort(x_big, decreasing = TRUE), 34))
# microbenchmark::microbenchmark(
#   R = create_groups(x_big, 34), 
#   RCPP = create_groups2(x_big, 34),
#   RCPP2 = create_groups3(sort(x_big, decreasing = TRUE), 34),
#   times = 10
# )
x_big <- round(runif(1e6, min = 1, max = 34))
create_groups3(sort(x_big, decreasing = TRUE), 34)
*/
