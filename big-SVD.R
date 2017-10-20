library(bigstatsr)
options(bigstatsr.block.sizeGB = 0.5)

a <- FBM(1e6, 1e3)
big_apply(a, a.FUN = function(X, ind) {
  X[, ind] <- rnorm(nrow(X) * length(ind))
  NULL
}, a.combine = 'c')

K <- big_crossprodSelf(a, big_scale(center = FALSE, scale = FALSE))

eig <- eigen(K[])
v <- eig$vectors
d <- sqrt(eig$values)

u <- FBM(nrow(a), ncol(a))
big_apply(u, a.FUN = function(X, ind, a, v, d) {
  X[ind, ] <- sweep(a[ind, ] %*% v, 2, d, "/")
  NULL
}, a.combine = 'c', block.size = 50e3, ind = rows_along(u),
a = a, v = v, d = d)

all.equal(a[1:1000, ], tcrossprod(sweep(u[1:1000, ], 2, d, "*"), v))


test <- big_SVD(a, big_scale(center = FALSE, scale = FALSE))
ind <- sample(nrow(a), 1000)
plot(test$u[ind, 1:10], u[ind, 1:10])
