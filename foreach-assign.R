library(plyr); library(doParallel); library(foreach)

cs <- makeCluster(2)
registerDoParallel(cs)

sfor_start <- Sys.time()
s_for = double(1000)
for (i in 1:1000) {
  s_for[i] = sqrt(i)
}
print(Sys.time() - sfor_start)

sdopar_start <- Sys.time()
sdopar <- foreach(k=1:1000, .combine = 'c') %dopar% {
  sqrt(k)
}
print(Sys.time() - sdopar_start)

sdopar <- foreach(k=1:1000) %do% {
  sdopar <- sqrt(k) ^2
} 
