compute.in.parallel <- function(i, global.variable, global.function) {
  global.function(i + global.variable)
}

do <- function(pop, fun, ncores = parallel::detectCores() - 1, ...) {
  require(foreach)
  cl <- parallel::makeCluster(ncores)
  on.exit(parallel::stopCluster(cl), add = TRUE)
  doParallel::registerDoParallel(cl)
  foreach(i = pop) %dopar% fun(i, ...)
}

do(seq(10), compute.in.parallel, 
   global.variable = 3, 
   global.function = function(j) j^2)