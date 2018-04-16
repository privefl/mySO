#include <Rcpp.h>
using namespace Rcpp;

double compute_a(double lat1, double long1, double lat2, double long2) {
  
  double sin_dLat = ::sin((lat2 - lat1) / 2);
  double sin_dLon = ::sin((long2 - long1) / 2);
  
  return sin_dLat * sin_dLat + ::cos(lat1) * ::cos(lat2) * sin_dLon * sin_dLon;
}

int find_min(double lat1, double long1,
             const NumericVector& lat2,
             const NumericVector& long2,
             int current0) {
  
  int m = lat2.size();
  double lat_k, lat_min, lat_max, a, a0;
  int k, current = current0;

  a0 = compute_a(lat1, long1, lat2[current], long2[current]);
  // Search before current0
  lat_min = lat1 - 2 * ::asin(::sqrt(a0));
  for (k = current0 - 1; k >= 0; k--) {
    lat_k = lat2[k];
    if (lat_k > lat_min) {
      a = compute_a(lat1, long1, lat_k, long2[k]);
      if (a < a0) {
        a0 = a;
        current = k;
        lat_min = lat1 - 2 * ::asin(::sqrt(a0));
      }
    } else {
      // No need to search further
      break;
    }
  }
  // Search after current0
  lat_max = lat1 + 2 * ::asin(::sqrt(a0));
  for (k = current0 + 1; k < m; k++) {
    lat_k = lat2[k];
    if (lat_k < lat_max) {
      a = compute_a(lat1, long1, lat_k, long2[k]);
      if (a < a0) {
        a0 = a;
        current = k;
        lat_max = lat1 + 2 * ::asin(::sqrt(a0));
      }
    } else {
      // No need to search further
      break;
    }
  }
  
  return current;
} 

// [[Rcpp::export]]
IntegerVector find_closest_point(const NumericVector& lat1,
                                 const NumericVector& long1,
                                 const NumericVector& lat2,
                                 const NumericVector& long2) {
  
  int n = lat1.size();
  IntegerVector res(n);
  
  int current = 0;
  for (int i = 0; i < n; i++) {
    res[i] = current = find_min(lat1[i], long1[i], lat2, long2, current);
  }
  
  return res; // need +1
}


/*** R
N <- 2000  # 2e6
M <- 2e4

pixels.latlon=cbind(runif(N,min=-180, max=-120), runif(N, min=50, max=85))
grwl.latlon=cbind(runif(M,min=-180, max=-120), runif(M, min=50, max=85))
# grwl.latlon <- grwl.latlon[order(grwl.latlon[, 2]), ]

library(geosphere)
system.time({
  #calculate the distance matrix
  dist.matrix = distm(pixels.latlon, grwl.latlon, fun=distHaversine)
  #Pick out the indices of the minimum distance
  rnum=apply(dist.matrix, 1, which.min)
})


find_closest <- function(lat1, long1, lat2, long2) {
  
  toRad <- pi / 180
  lat1  <- lat1  * toRad
  long1 <- long1 * toRad
  lat2  <- lat2  * toRad
  long2 <- long2 * toRad
  
  ord1  <- order(lat1)
  rank1 <- match(seq_along(lat1), ord1)
  ord2  <- order(lat2)
  
  ind <- find_closest_point(lat1[ord1], long1[ord1], lat2[ord2], long2[ord2])
  
  ord2[ind + 1][rank1]
}

system.time(
  test <- find_closest(pixels.latlon[, 2], pixels.latlon[, 1], 
                       grwl.latlon[, 2], grwl.latlon[, 1])
)
all.equal(test, rnum)

N <- 2e5
M <- 2e4
pixels.latlon=cbind(runif(N,min=-180, max=-120), runif(N, min=50, max=85))
grwl.latlon=cbind(long = runif(M,min=-180, max=-120), lat = runif(M, min=50, max=85))
system.time(
  test <- find_closest(pixels.latlon[, 2], pixels.latlon[, 1], 
                       grwl.latlon[, 2], grwl.latlon[, 1])
)
*/
