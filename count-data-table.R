require(data.table)

N <- 1e6
mydt <- data.table(x = sample(letters, size = N, replace = TRUE),
                   y = sample(1:26, size = N, replace = TRUE),
                   z = sample(LETTERS, size = N, replace = TRUE))

system.time({
  mydt.colnames = colnames(mydt)
  mydt.fweighted = mydt[,
                        list(fweight = .N),
                        by = mydt.colnames]
})

library(dplyr)
system.time({
  res <- mydt %>% 
    group_by_all() %>%
    count()
})




mydt.fweighted
res
