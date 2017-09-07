# devtools::install_github("jennybc/repurrrsive")
library(repurrrsive)
library(purrr)
library(microbenchmark)

f <- function(x) x[[2]]

mbm <- microbenchmark(
  lapply = lapply(got_chars[1:4], function(x) x[[2]]),
  map = map(got_chars[1:4], function(x) x[[2]]),
  map_2 = map(got_chars[1:4], 2),
  map_3 = map(got_chars[1:4], f),
  times = 1000
)
ggplot2::autoplot(mbm)
