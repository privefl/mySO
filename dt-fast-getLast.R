library(dplyr)
library(microbenchmark)
library(Rcpp)
n <- 5000
df <- data.frame(
  grp = factor(rep(1:n, 2)), 
  valn = rnorm(2L*n), 
  stringsAsFactors = FALSE
)

last_r <- function(x) {
  tail(x, 1)
}

cppFunction('double last_rcpp(NumericVector x) {
            int n = x.size();
            return x[n-1];
            }')

dplyr_num_last_element <- function() df %>% group_by(grp) %>% summarise(valn = dplyr::last(valn))
dplyr_num_last_element_r <- function() df %>% group_by(grp) %>% summarise(valn = last_r(valn))
dplyr_num_last_element_rcpp <- function() df %>% group_by(grp) %>% summarise(val = last_rcpp(valn))
tapply_num_last_element <- function() tapply(df$valn, df$grp, FUN = dplyr::last)
tapply_num_last_element_r <- function() tapply(df$valn, df$grp, FUN = last_r)
tapply_num_last_element_rcpp <- function() tapply(df$valn, df$grp, FUN = last_rcpp)


library(data.table) 
dt <- data.table(df)
DT_num_last_element_r <- function() {
  setkey(dt, grp)
  dt[, last_r(valn), grp]
}
microbenchmark(
  DT_num_last_element_r(), 
  dplyr_num_last_element(), 
  dplyr_num_last_element_r(), 
  dplyr_num_last_element_rcpp(), 
  tapply_num_last_element(), 
  tapply_num_last_element_r(), 
  tapply_num_last_element_rcpp(), 
  times = 20
) 

