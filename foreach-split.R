library(doMC)
library(foreach)
library(itertools)

num_cores <- 3
registerDoMC(num_cores)

predict.fake <- function(object, newdata) {
  rowSums(newdata)
}

cfModel <- structure(NULL, class = "fake")
test <- matrix(rnorm(2000), ncol = 2)
pred <- predict(cfModel, test)

test_prediction <-
  foreach(d=isplitRows(test, chunks = num_cores),
          .combine=c, 
          .packages=c("stats")) %dopar% {
            predict(cfModel, newdata=d)
          }

all.equal(test_prediction, pred)
