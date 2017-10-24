multiSVD <- function(a, k = 10, niter = 50) {
  
  indNA <- which(is.na(a), arr.ind = TRUE)
  G <- mat_to_geno(a)
  p <- colMeans(a, na.rm = TRUE) / 2
  pNA <- p[indNA[, 2]]
  
  repl <- replicate(niter, simplify = FALSE, {
    G[indNA] <- as.raw(rbinom(nrow(indNA), size = 2, prob = pNA))
    svd <- big_SVD(G, snp_scaleBinom(), k = k)
    tcrossprod(sweep(svd$u, 2, svd$d, "*"), svd$v)
  })
  
  big_SVD(big_copy(do.call("cbind", repl)), 
          fun.scaling = big_scale(F, F), k = k)
}

library(bigsnpr)

popres <- snp_attach("backingfiles/popres.rds")
G <- popres$genotypes
G2 <- G[1:500, popres$map$chromosome == 6][, 1:5000]
dim(G2)
n <- nrow(G2)

nbNA <- VGAM::rbetabinom.ab(ncol(G2), size = n, shape1 = 0.6, shape2 = 10)
sum(nbNA) / length(G2)

p <- colMeans(G2) / 2
G.scale <- sweep(sweep(G2, 2, 2 * p, '-'), 2, sqrt(2 * p * (1 - p)), '/')

svd0 <- RSpectra::svds(G.scale, 10)


# Generate indices of missing values
indNA <- cbind(
  unlist(lapply(nbNA, function(nb) {
    `if`(nb > 0, sample(n, size = nb), NULL)
  })), 
  rep(cols_along(G2), nbNA)
)

# Fill a copy of the matrix with NAs (coded as 03)
G2[indNA] <- NA

p2 <- colMeans(G2, na.rm = TRUE) / 2
G.scale2 <- sweep(sweep(G2, 2, 2 * p2, '-'), 
                  2, sqrt(2 * p2 * (1 - p2)), '/')

A <- function(x, args) {
  pMatVec4(G.scale2, x)
}

Atrans <- function(x, args) {
  cpMatVec4(G.scale2, x)
}

Rcpp::sourceCpp('test-prodNA.cpp')
test <- RSpectra::svds(A, 10, Atrans = Atrans, dim = dim(G2))
Metrics::rmse(test$u, svd0$u) / Metrics::rmse(test2$vectors, svd0$u)
PC <- 6; plot(test$u[, PC], svd0$u[, PC])


test2 <- flashpcaR::flashpca(G2)
PC <- 6; plot(test2$vectors[, PC], svd0$u[, PC])
Metrics::rmse(test$u, svd0$u) / Metrics::rmse(test2$vectors, svd0$u)

# test3 <- multiSVD(G2)
# Metrics::rmse(test$u, svd0$u) / Metrics::rmse(test3$u, svd0$u)
# PC <- 6; plot(test3$u[, PC], svd0$u[, PC])
