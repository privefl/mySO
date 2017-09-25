library(foreach)
library(doParallel)

doWork <- function(data,weights) {
  
  # setup parallel backend to use many processors
  cores=detectCores()
  number_of_cores_to_use = cores[1]-1 # not to overload the computer
  cat(paste('number_of_cores_to_use:',number_of_cores_to_use))
  cl <- makeCluster(number_of_cores_to_use) 
  clusterExport(cl=cl, varlist=c('weights'))
  registerDoParallel(cl)
  cat('...Starting foreach initialization')
  
  output <- foreach(i=1:nrow(data), .combine=rbind) %dopar% {
    x = sort(data[i,])
    fit = lm(x[1:(length(x)-1)] ~ poly(x[-1], degree = 2,raw=TRUE), na.action=na.omit, weights=weights)
    return(fit$coef)
  }
  # stop cluster
  cat('...Stop cluster')
  stopCluster(cl)
  
  return(output)
}

r = 10000 
c = 10
weights=runif(c-1)
data = matrix(runif(r*c), nrow = r, ncol=c)
system.time(
  output <- doWork(data,weights)
)


library(bigstatsr)
options(bigstatsr.ncores.max = parallel::detectCores())

doWork2 <- function(data, weights, ncores = parallel::detectCores() - 1) {
  
  big_parallelize(data, p.FUN = function(X.desc, ind, weights) {
    
    X <- bigstatsr::attach.BM(X.desc)
    
    output.part <- matrix(0, 3, length(ind))
    for (i in seq_along(ind)) {
      x <- sort(X[, ind[i]])
      fit <- lm(x[1:(length(x)-1)] ~ poly(x[-1], degree = 2, raw = TRUE), 
               na.action = na.omit, weights = weights)
      output.part[, i] <- fit$coef
    }
    
    t(output.part)
  }, p.combine = "rbind", ncores = ncores, weights = weights)
}

system.time({
  data.bm <- as.big.matrix(t(data))
  output2 <- doWork2(data.bm, weights, 1)
})

all.equal(output, output2, check.attributes = FALSE)
