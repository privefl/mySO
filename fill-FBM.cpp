// [[Rcpp::depends(bigstatsr, BH)]]
#include <bigstatsr/BMAcc.h>
#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
void fillMat(Environment BM,
             const NumericVector& limits,
             const NumericVector& simulation) {
  
  XPtr<FBM> xpBM = BM["address"];
  BMAcc<double> macc(xpBM);
  
  int n = macc.nrow();
  int m = macc.ncol();
  
  for (int i = 0; i < m; i++)
    for (int j = 0; j < n; j++)
      macc(j, i) = std::min(limits[i], simulation[j]);
}

/*** R
simulation <- structure(list(simulation = c(124786.7479,269057.2118,80432.47896,119513.0161,660840.5843,190983.7893)), .Names = "simulation", row.names = c(NA,6L), class = "data.frame")
limits <- structure(list(limits = c(5000L,10000L,15000L, 20000L,25000L,30000L)), .Names = "limits", row.names = c(NA, 6L), class = "data.frame")

library(bigstatsr)
mat <- FBM(nrow(simulation), nrow(limits))
fillMat(mat, limits[[1]], simulation[[1]])  
mat[]
mat[, 1:3]
*/
