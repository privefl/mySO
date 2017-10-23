library(bigstatsr)

m1 <- FBM(1e4, 5e3)

big_apply(m1, a.FUN = function(X, ind) {
  X[, ind] <- runif(nrow(X) * length(ind))
  NULL
}, a.combine = 'c', block.size = 500)
plot(m1[, 5e3])
