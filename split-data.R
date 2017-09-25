data <- mtcars
n <- nrow(data)
K <- 5
ind <- integer(n)
new <- rep(1:K, each = 0.1 * n)
ind[sample(n, size = length(new))] <- new
split(data, ind)
