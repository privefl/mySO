// Adapted from https://privefl.github.io/blog/performance-when-algorithmics-meets-mathematics/

#include <Rcpp.h>
using namespace Rcpp;

inline double compute_d2(double x1, double y1, double x2, double y2) {
  
  double dx = x2 - x1;
  double dy = y2 - y1;
  
  return dx * dx + dy * dy;
}

double find_min(const NumericMatrix& points, int i, int m) {
  
  double x_i = points(i, 0), y_i = points(i, 1), id_i = points(i, 2);;
  
  double x_k, x_min, x_max, d, d0 = R_PosInf;
  int k;
  
  // Search before i
  x_min = R_NegInf;
  for (k = i - 1; k >= 0; k--) {
    if (points(k, 2) == id_i) continue;  
    x_k = points(k, 0);
    if (x_k > x_min) {
      d = compute_d2(x_i, y_i, x_k, points(k, 1));
      if (d < d0) {
        d0 = d;
        x_min = x_i - ::sqrt(d0);
      }
    } else {
      // No need to search further
      break;
    }
  }
  // Search after i
  x_max = R_PosInf;
  for (k = i + 1; k < m; k++) {
    if (points(k, 2) == id_i) continue;  
    x_k = points(k, 0);
    if (x_k < x_max) {
      d = compute_d2(x_i, y_i, x_k, points(k, 1));
      if (d < d0) {
        d0 = d;
        x_max = x_i + ::sqrt(d0);
      }
    } else {
      // No need to search further
      break;
    }
  }
  
  return ::sqrt(d0);
} 

// [[Rcpp::export]]
NumericVector rcpp_get_nearest_neighbor(const NumericMatrix& points) {
  
  int nrows = points.nrow();
  NumericVector distances(nrows);
  
  for (int i = 0; i < nrows; i++) {
    distances[i] = find_min(points, i, nrows);
  }
  
  return distances;
}

/*** R
# devtools::install_github("marcosci/landscapemetrics")
X <- readRDS("points_class.rds")
X2 <- as.matrix(X)

res <- landscapemetrics:::rcpp_get_nearest_neighbor(X2)

find_closest <- function(X) {
  
  ord <- order(X[, 1])
  num <- seq_along(ord)
  rank <- match(num, ord)
  
  res <- rcpp_get_nearest_neighbor(X[ord, ])
  
  unname(cbind(num, res[rank], X[, 3]))
}
res2 <- find_closest(X2)
stopifnot(identical(res[, 2], res2[, 2]))

microbenchmark::microbenchmark(
  landscapemetrics:::rcpp_get_nearest_neighbor(X2),
  find_closest(X2)
)

X3 <- X2[rep(seq_len(nrow(X2)), 50), ]
microbenchmark::microbenchmark(
  landscapemetrics:::rcpp_get_nearest_neighbor(X3),
  find_closest(X3), 
  times = 20
)
stopifnot(identical(
  landscapemetrics:::rcpp_get_nearest_neighbor(X3),
  find_closest(X3)
))

# compute_d2(X2[1, 1], X2[1, 2], X2[1, 1], X2[1, 2])
# compute_d2(X2[2, 1], X2[2, 2], X2[1, 1], X2[1, 2])
*/
