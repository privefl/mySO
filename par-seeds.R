library(doSNOW)
library(rlecuyer)

nr.cores = 4
nr.simulations = 10 
sample.size = 100000

seed = 12345

cl = makeCluster(nr.cores)
registerDoSNOW(cl)
clusterExport(cl=cl, list=c('sample.size'), envir=environment())
clusterSetupRNGstream(cl,rep(seed,10))

result = foreach(i=1:nr.simulations, .combine = 'c', .inorder=T)%dopar%{
  tmp = rnorm(sample.size)
  tmp[sample.size]
}

stopCluster(cl)

print(paste0('nr.cores = ',nr.cores,'; seed = ',seed,'; time =',Sys.time()))
print(result)

cl = makeCluster(nr.cores)
registerDoSNOW(cl)
replicate(10, {
  foreach(ic = 1:8, .combine = 'c', .inorder = TRUE) %dopar% {
    Sys.sleep(runif(1))
    Sys.getpid()
  } 
})
stopCluster(cl)

library(doRNG)
cl = makeCluster(nr.cores)
registerDoSNOW(cl)
replicate(16, {
  set.seed(12345)
  sample.size = 100000
  foreach(ic = 1:8, .combine = 'c', .inorder = TRUE) %dorng% {
    Sys.sleep(runif(1))
    tmp = rnorm(sample.size)
    tmp[sample.size]
  } 
})
stopCluster(cl)

