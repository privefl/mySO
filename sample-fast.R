N <- 23e4

dat <- data.frame(
  target = sample(0:1, size = N, replace = TRUE),
  x = rnorm(N)
)  


prb <- ifelse(dat$target==1, 1.0, 0.05)
# prb <- 0.05 + 0.95 * (dat$target == 1)


n <- 2e4

Rcpp::sourceCpp('sample-fast.cpp')
sample_fast <- function(N, n, prb) {
  get_first_unique(sample.int(N, size = 2 * n, prob = prb, replace = TRUE), N, n)
}

# Timing
system.time(ind <- sample_fast(N, n, prb))
# Check
length(unique(ind))
# Not the same I think
table(prb[ind])

N <- 23e4
n <- 2e4
prb <- ifelse(sample(0:1, size = N, replace = TRUE) == 1, 1.0, 0.05)
smpl <- UPrandomsystematic(n/sum(prb) * prb)
table(prb[as.logical(smpl)])
table(prb[sample.int(N, size = n, replace = FALSE, prob = prb)])



# table(sample.int(4, size = 10e6, replace = TRUE, prob = 1:4))
# table(sample(1:4, size = 10e6, replace = TRUE, prob = 1:4))

# ind <- sample.int(N, size = 2 * n, prob = prb, replace = TRUE)
# ind2 <- get_first_unique(ind, N, n)
# all(ind2 %in% ind)




library(sampling)

# Sample
system.time(smpl <- UPrandomsystematic(n/sum(prb) * prb))
# Check
sum(smpl)
table(prb[as.logical(smpl)])
