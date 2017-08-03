NCORES <- 6
library(doParallel)
cl <- makeCluster(6); registerDoParallel(cl)
# clusterExport(cl, varlist=c("arg1","arg2","inner_fun"))

inner_fun <- function(i, arg1, arg2, list_elem) {
  c(list_elem + i, arg1, arg2)
}

huge_list <- as.list(seq_len(1e5))

library(foreach)

dummy_fun<-function(arg1, arg2, huge_list, inner_fun) {
  foreach(i = seq_along(huge_list), .combine=rbind) %dopar% {
    inner_fun(i, arg1, arg2, huge_list[[i]])
  }
} # 80 sec pour dire qu'il connait pas inner_fun

library(doParallel)
cl <- makeCluster(6); registerDoParallel(cl)
system.time(
  tmp <- dummy_fun(2, 3, huge_list, inner_fun)
) # 78 sec with 6 cores
parallel::stopCluster(cl)



dummy_fun2 <- function(arg1, arg2, huge_list, inner_fun, ncores) {
  
  cl <- parallel::makeCluster(ncores)
  doParallel::registerDoParallel(cl)
  on.exit(parallel::stopCluster(cl), add = TRUE)
  
  L <- length(huge_list)
  inds <- split(seq_len(L), sort(rep_len(seq_len(NCORES), L)))
  
  foreach(l = seq_along(inds), .combine = rbind) %dopar% {
    ab1 <- lapply(inds[[l]], function(i) {
      inner_fun(i, arg1, arg2, huge_list[[i]])
    })
    do.call(rbind, ab1)
  }
}
system.time(
  tmp2 <- dummy_fun2(2, 3, huge_list, inner_fun, 6)
) # 78 sec with 6 cores
all.equal(tmp2, tmp, check.attributes = FALSE)


registerDoSEQ()
system.time(
  tmp <- dummy_fun(2, 3, huge_list, inner_fun)
) # 69 sec with 1 cores

library(bigstatsr)
dummy_fun_seq <- function(desc, ind, arg1, arg2, huge_list, inner_fun) {
  foreach(i = ind, .combine=rbind) %do% {
    inner_fun(i, arg1, arg2, huge_list[[i]])
  }
}

system.time(
  test <- big_parallelize(big.matrix(1, 1), p.FUN = dummy_fun_seq, p.combine = "rbind",
                          ncores = 2, ind = seq_along(huge_list),
                          arg1 = 2, arg2 = 3, huge_list = huge_list, inner_fun = inner_fun)
) 
# 69 sec with 1 core
# 13 sec with 2 cores
# 7 sec wiih 6 cores 

all.equal(test, tmp, check.attributes = FALSE)

dummy_fun_seq2 <- function(desc, ind, arg1, arg2, huge_list, inner_fun) {
  tmp <- lapply(ind, function(i) {
    inner_fun(i, arg1, arg2, huge_list[[i]])
  })
  do.call(rbind, tmp)
}

system.time(
  test2 <- big_parallelize(big.matrix(1, 1), p.FUN = dummy_fun_seq2, p.combine = "rbind",
                          ncores = 1, ind = seq_along(huge_list),
                          arg1 = 2, arg2 = 3, huge_list = huge_list, inner_fun = inner_fun)
) 
all.equal(test2, tmp, check.attributes = FALSE)
