df<-as.matrix(mtcars)
result<-apply(df,1,prod)

Rfast::rowprods(df)

matrixStats::rowProds(df)

library(bigstatsr)
fbm <- FBM(10e6, 100)
# inialize with random numbers
system.time(
  big_apply(fbm, a.FUN = function(X, ind) {
    print(min(ind))
    X[, ind] <- rnorm(nrow(X) * length(ind))
    NULL
  }, a.combine = 'c')
) # 78 sec

# compute row prods, possibly in parallel
system.time(
  prods <- big_apply(fbm, a.FUN = function(X, ind) {
    print(min(ind))
    matrixStats::rowProds(X[ind, ])
  }, a.combine = 'c', ind = rows_along(fbm),
  block.size = 100e3, ncores = nb_cores())  
) # 22 sec
