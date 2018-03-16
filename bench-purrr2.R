your_list <- rep(list(list(1,2,3,4), list(5,6,7), list(8,9)), 100)


library(purrr)

first <- your_list %>% map(1)
first

lapply(your_list, function(x) x[[1]])
your_list[[1]]


microbenchmark::microbenchmark(
  your_list %>% map(1),
  lapply(your_list, function(x) x[[1]])
)

microbenchmark::microbenchmark(
  your_list %>% map(. %>% .[-1]),
  lapply(your_list, function(x) x[-1])
)
