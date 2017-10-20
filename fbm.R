X <- matrix(0, 10, 20)
as.FBM <- function(X) {
  tmp <- tempfile()
  as.big.matrix(X, backingfile = basename(tmp), 
                backingpath = dirname(tmp),
                descriptorfile = paste0(basename(tmp), ".desc"))
}