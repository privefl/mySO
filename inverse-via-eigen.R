mat <- G[, c(1, 1:10)]
K <- cor(mat)
eigs <- eigen(K, symmetric = TRUE)
vals <- eigs$values
thr <- 1e-10
ind <- which(vals > thr * max(vals))
K.inv <- tcrossprod(sweep(eigs$vectors[, ind, drop = FALSE], 
                          2, sqrt(eigs$values[ind]), '/'))

K %*% K2
