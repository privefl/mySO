x.all <- array(dim=c(20,2,2))
no_cores <- 3

tmpfile <- tempfile()

range.parts <- bigstatsr:::CutBySize(nrow(x.all), nb = no_cores)
library(foreach)
cl <- parallel::makeCluster(no_cores)
doParallel::registerDoParallel(cl)
foreach(ic = 1:no_cores) %dopar% {
  
  ind <- bigstatsr:::seq2(range.parts[ic, ])
  x <- array(dim = c(length(ind), 2, 2))
  
  for (i in seq_along(ind)){
    for (j in 1:2){
      for (k in 1:2){
        x[i,j,k] <- ind[i]+j+k
      }
    }
  }
  
  saveRDS(x, file = paste0(tmpfile, "_", ic, ".rds"))
}
parallel::stopCluster(cl)

for (ic in 1:no_cores) {
  ind <- bigstatsr:::seq2(range.parts[ic, ])
  x.all[ind, , ] <- readRDS(paste0(tmpfile, "_", ic, ".rds"))
}

print(x.all)