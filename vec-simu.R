count <- 0

d <- 5
total <- sum(sample(1:6, d, replace = TRUE))

nreps <- 1e6
library(magrittr)
sample(1:6, nreps * d, replace = TRUE) %>%
  matrix(nrow = d) %>%
  colSums() %>%
  table() %>%
  divide_by(nreps)