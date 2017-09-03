library(microbenchmark)
library(ref)

m0 <- matrix(rnorm(10^6), 10^3, 10^3)
r0 <- refdata(m0)
microbenchmark(m0[, 1:900], sum(m0[, 1:900]), sum(r0[,1:900]), sum(m0),
               sum(colSums(m0)[1:900]),
               sumSub(m0, 1:900))


