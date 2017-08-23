test2 <- foreach::`%do%`(
  foreach::`%:%`(foreach::foreach(j = 1:20, .combine = c),
                 foreach::foreach(i = 1:10, .combine = c)), 
  {
    i * j 
  }
)

library(foreach)
test1 <- foreach::foreach (j = 1:20, .combine = c) %:%
  foreach::foreach(i = 1:10, .combine = c) %do% {
    i * j 
  }




all.equal(test1, test2)
