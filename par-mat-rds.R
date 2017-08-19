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
bm <- matrix(1, 10e3, 1e3)
ncores <- 3
intervals <- CutBySize(ncol(bm), ncores)
# Save each part in a different file
tmpfile <- tempfile()
for (ic in seq_len(ncores)) {
  saveRDS(bm[, seq2(intervals[ic, ])], 
          paste0(tmpfile, ic, ".rds"))
}
# Parallel computation with reading one part at the beginning
cl <- parallel::makeCluster(ncores)
doParallel::registerDoParallel(cl)
library(foreach)
colsums <- foreach(ic = seq_len(ncores), .combine = 'c') %dopar% {
  bm.part <- readRDS(paste0(tmpfile, ic, ".rds"))
  colSums(bm.part)
}
parallel::stopCluster(cl)
# Checking results
all.equal(colsums, colSums(bm))
