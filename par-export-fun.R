mydata <- matrix(data = 1:9, 3, 3)

perfFUN <- function(x) 2*x

opt_perfFUN <- function(y) max(perfFUN(y))

avg_perfFUN <- function(w) perfFUN(mean(w))

myFUN <- function(data, yourFUN, n_cores = 1) {
  
  cl <- parallel::makeCluster(n_cores)
  on.exit(parallel::stopCluster(cl), add = TRUE)
  
  envir <- environment(yourFUN)
  parallel::clusterExport(cl, varlist = ls(envir), envir = envir)
  
  parallel::parApply(cl, data, 1, yourFUN)
  
}

myFUN(data = mydata, yourFUN = opt_perfFUN)
myFUN(data = mydata, yourFUN = avg_perfFUN)




