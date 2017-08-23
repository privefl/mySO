a <- array(1:100, c(2, 3, 4))

library(foreach)
result <- foreach(i = 1:ncol(a), .final = simplify2array) %dopar% {
  apply(a[,i,], 1, identity)
} 
all.equal(result, apply(a, c(1, 2), identity))
