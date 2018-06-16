#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::NumericVector hawk_process_org(Rcpp::NumericVector x, double beta = 3) {
  
  int n = x.size();
  Rcpp::NumericVector B = Rcpp::no_init( n - 1);
  
  for (int i = 1; i < n; i++) {
    
    double temp = 0;
    
    for (int j = 0; j <= i - 1; j++) {
      temp += (x[i] - x[j]) * exp(-beta * (x[i] - x[j]));
    }
    
    B(i - 1) = temp;
  }
  
  return B;
}

// [[Rcpp::export]]
Rcpp::NumericVector hawk_process_cache(Rcpp::NumericVector x, double beta = 3) {
  
  int n = x.size();
  Rcpp::NumericVector B = Rcpp::no_init( n - 1);
  
  double x_i;
  for (int i = 1; i < n; ++i) {
    
    double temp = 0;
    x_i = x[i];
    
    for (int j = 0; j <= i - 1; ++j) {
      temp += (x_i - x[j]) * 1 / exp(beta * (x_i - x[j]));
    }
    
    B(i - 1) = temp;
  }
  
  return B;
}

// [[Rcpp::export]]
Rcpp::NumericVector hawk_process_cache_2(Rcpp::NumericVector x, 
                                         double beta = 3) {
  
  int i, j, n = x.size();
  Rcpp::NumericVector B(n);
  Rcpp::NumericVector x_exp = exp(beta * x);
  
  double temp;
  for (i = 1; i < n; i++) {
    
    temp = 0;
    for (j = 0; j < i; j++) {
      temp += (x[i] - x[j]) * x_exp[j] / x_exp[i];
    }
    
    B[i] = temp;
  }
  
  return B;
}

// [[Rcpp::export]]
Rcpp::NumericVector hawk_process_cache_3(Rcpp::NumericVector x, 
                                         double beta = 3) {
  
  int i, j, n = x.size();
  Rcpp::NumericVector B(n);
  Rcpp::NumericVector x_exp = exp(beta * x);
  
  double temp;
  for (i = 1; i < n; i++) {
    
    temp = 0;
    for (j = 0; j < i; j++) {
      temp += (x[i] - x[j]) * x_exp[j];
    }
    
    B[i] = temp / x_exp[i];
  }
  
  return B;
}

// [[Rcpp::export]]
Rcpp::NumericVector hawk_process_cache_4(Rcpp::NumericVector x, 
                                         double beta = 3) {
  
  Rcpp::NumericVector exp_pre = exp(beta * x);
  Rcpp::NumericVector exp_pre_cumsum = cumsum(exp_pre);
  Rcpp::NumericVector x_exp_pre_cumsum = cumsum(x * exp_pre);
  return (x * exp_pre_cumsum - x_exp_pre_cumsum) / exp_pre;
}

// [[Rcpp::export]]
Rcpp::NumericVector hawk_process_cache_5(Rcpp::NumericVector x, 
                                         double beta = 3) {
  
  int n = x.size();
  NumericVector B(n);
  double exp_pre, exp_pre_cumsum = 0, x_exp_pre_cumsum = 0;
  
  for (int i = 0; i < n; i++) {
    exp_pre = exp(beta * x[i]);
    exp_pre_cumsum += exp_pre;
    x_exp_pre_cumsum += x[i] * exp_pre;
    B[i] = (x[i] * exp_pre_cumsum - x_exp_pre_cumsum) / exp_pre;
  }
  
  return B;
}

// [[Rcpp::export]]
Rcpp::NumericVector hawk_process_cache_6(Rcpp::NumericVector x, 
                                         double beta = 3) {
  
  int n = x.size();
  NumericVector B(n);
  double x_i, exp_pre, exp_pre_cumsum = 0, x_exp_pre_cumsum = 0;
  
  for (int i = 0; i < n; ++i) {
    x_i = x[i];
    exp_pre = exp(beta * x_i);
    exp_pre_cumsum += exp_pre;
    x_exp_pre_cumsum += x_i * exp_pre;
    B[i] = (x_i * exp_pre_cumsum - x_exp_pre_cumsum) / exp_pre;
  }
  
  return B;
}


/*** R
set.seed(111)

x = rnorm(1e3)

all.equal(
  hawk_process_org(x),
  hawk_process_cache(x)
)
all.equal(
  hawk_process_org(x),
  hawk_process_cache_2(x)[-1]
)
all.equal(
  hawk_process_org(x),
  hawk_process_cache_3(x)[-1]
)

all.equal(
  hawk_process_org(x),
  hawk_process_cache_4(x)[-1]
)

all.equal(
  hawk_process_org(x),
  hawk_process_cache_5(x)[-1]
)

microbenchmark::microbenchmark(
  hawk_process_org(x),
  hawk_process_cache(x),
  hawk_process_cache_2(x),
  hawk_process_cache_3(x),
  hawk_process_cache_4(x),
  hawk_process_cache_5(x),
  hawk_process_cache_6(x)
) 



x = rnorm(1e6)

all.equal(
  hawk_process_cache_5(x),
  hawk_process_cache_6(x)
)

microbenchmark::microbenchmark(
  hawk_process_cache_5(x),
  hawk_process_cache_6(x),
  times = 100
) 
*/
