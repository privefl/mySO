# Functions for splitting
CutBySize <- function(m, nb) {
  int <- m / nb
  
  upper <- round(1:nb * int)
  lower <- c(1, upper[-nb] + 1)
  size <- c(upper[1], diff(upper))
  
  cbind(lower, upper, size)
}
seq2 <- function(lims) seq(lims[1], lims[2])

# The matrix
bm <- matrix(1, 300e3, 1e3)
system.time(true <- colSums(bm))
ncores <- 3
intervals <- CutBySize(ncol(bm), ncores)
# Save each part in a different file
tmpfile <- tempfile()
for (ic in seq_len(ncores)) {
  saveRDS(bm[, seq2(intervals[ic, ])], 
          paste0(tmpfile, ic, ".rds"))
}
rm(bm); gc()
# Parallel computation with reading one part at the beginning
system.time({
  cl <- parallel::makeCluster(ncores)
  doParallel::registerDoParallel(cl)
  library(foreach)
  colsums <- foreach(ic = seq_len(ncores), .combine = 'c') %dopar% {
    bm.part <- readRDS(paste0(tmpfile, ic, ".rds"))
    colSums(bm.part)
  }
  parallel::stopCluster(cl)
})
# Checking results
all.equal(colsums, true)
