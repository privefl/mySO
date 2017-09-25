K <- 1 
N <- 100 
Hstar <- 10 
perms <- 10000
specs <- 1:N 
pop <- array(dim = c(N, perms, K))
haps <- 1:Hstar
probs <- rep(1/Hstar, Hstar) 

for(j in 1:perms){
  for(i in 1:K){ 
    if(i == 1){
      pop[, j, i] <- sample(haps, size = N, replace = TRUE, prob = probs)
    }
    else{
      pop[, j, 1] <- sample(haps[s1], size = N, replace = TRUE, prob = probs[s1])
      pop[, j, 2] <- sample(haps[s2], size = N, replace = TRUE, prob = probs[s2])
    }
  }
}

Rcpp::sourceCpp('cube-sample.cpp')

system.time(
  HAC.mat2 <- fillCube(pop, specs, perms, K)
)
HAC.mat2[1, , ]
HAC.mat2[, 50, ]

print(system.time({
  HAC.mat <- array(dim = c(c(perms, N), K))
  
  for(k in specs){
    for(j in 1:perms){
      for(i in 1:K){ 
        ind.index <- sample(specs, size = k, replace = FALSE) 
        hap.plot <- pop[ind.index,
                        sample.int(n = perms, size = 1, useHash = TRUE), 
                        sample.int(n = K, size = 1, useHash = FALSE)] 
        HAC.mat[j, k, i] <- length(unique(hap.plot))  
      }
    }
  }
}))
HAC.mat[1, , ]
HAC.mat[, 50, ]

means <- apply(HAC.mat, MARGIN = 2, mean)
lower <- apply(HAC.mat, MARGIN = 2, function(x) quantile(x, 0.025))
upper <- apply(HAC.mat, MARGIN = 2, function(x) quantile(x, 0.975))

par(mfrow = c(1, 2))

plot(specs, means, type = "n", xlab = "Specimens sampled", ylab = "Unique haplotypes", ylim = c(1, Hstar))
polygon(x = c(specs, rev(specs)), y = c(lower, rev(upper)), col = "gray")
lines(specs, means, lwd = 2)
HAC.bar <- barplot(N*probs, xlab = "Unique haplotypes", ylab = "Specimens sampled", names.arg = 1:Hstar)