#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix gibbsC(int n, double mu1, double mu2, double s1, double s2, double rho) {
  
  NumericMatrix res(n, 2);
  double x, y, rho2;
  x = R::rnorm(mu1,s1);
  for(int i=0; i<n; i++){
    rho2 = 1 - rho * rho;
    res(i, 1) = y = R::rnorm(mu2+(s2/s1)*rho*(x-mu1),sqrt(rho2*s2*s2)); // Y|X
    res(i, 0) = x = R::rnorm(mu1+(s1/s2)*rho*(y-mu2),sqrt(rho2*s1*s1)); // X|Y
  }
  
  return res;
}

/*** R
gibbsR <- function(n,mu1,mu2,s1,s2,rho){
  X <- numeric() ; Y <- numeric()
  X[1] <- rnorm(1,mu1,s1) #init value for x_0
  for(i in 1:n){
    Y[i]   <- rnorm(1,mu2+(s2/s1)*rho*(X[i]-mu1),sqrt((1-rho^2)*s2^2)) # Y|X
    X[i+1] <- rnorm(1,mu1+(s1/s2)*rho*(Y[i]-mu2),sqrt((1-rho^2)*s1^2)) # X|Y
  }
  cbind(x=X[-1],y=Y)}

N <- 1e5

set.seed(1)
system.time(resR <- gibbsR(n=N,mu1=170,mu2=70,s1=10,s2=5,rho=0.8))
#colMeans(resR);apply(resR, 2, sd);cor(resR)
head(resR)

set.seed(1)
system.time(resC <- gibbsC(n=N,mu1=170,mu2=70,s1=10,s2=5,rho=0.8))
#colMeans(resR);apply(resR, 2, sd);cor(resR)
head(resC)
*/