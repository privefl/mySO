# devtools::install_github("privefl/bigstatsr")
library(bigstatsr)

# Data example
cond <- logical(1e6)
cond[sample(length(cond), size = 1)] <- TRUE
cond[] <- TRUE

ind.block <- bigstatsr:::CutBySize(length(cond), block.size = 1000)
cl <- parallel::makeCluster(nb_cores())
doParallel::registerDoParallel(cl)

# This value (in an on-disk matrix) is shared by processes
found_it <- FBM(1, 1, type = "integer", init = 0L)

library(foreach)
res <- foreach(ic = sample(rows_along(ind.block)), .combine = 'c') %dopar% {
  if (found_it[1]) return(NULL)
  ind <- bigstatsr:::seq2(ind.block[ic, ])
  find <- which(cond[ind])
  if (length(find)) {
    found_it[1] <- 1L
    return(ind[find[1]])
  } else {
    return(NULL)
  }
}

parallel::stopCluster(cl)

# Verification
all.equal(res, which(cond))