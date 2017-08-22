test <- function(i) {
  tryCatch({
    if (runif(1) < 0.8) {
      return(rnorm(i))
    } else {
      stop("Error!")
    } 
  }, error = function(e) print(e))
}
test(1)

lapply(1:10, test)

cl <- parallel::makeCluster(3)
dat <- parallel::parLapply(cl, 1:10, test)

doParallel::registerDoParallel(cl)
res <- foreach(i = 1:100, .errorhandling = "pass") %dopar% {
  test(i)
}


test1 <- function(i) {
  dat <- NA
  try({
    if (runif(1) < 0.8) {
      dat <- rnorm(i)
    } else {
      stop("Error!")
    } 
  })
  return(dat)   
}
dat <- parallel::parLapply(cl, 1:100, test1)
plyr::llply(1:100, test1, .parallel = TRUE)
