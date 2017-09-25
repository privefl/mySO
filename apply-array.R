w <- array(rnorm(12), c(2, 3, 2))
w

apply(w, 1:2, sum)
colSums(w, dims = 1:2) 
w