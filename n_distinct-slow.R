
N  <- 1e7 
therapyDF <- data.frame(patid = sample.int(N/2, size = N, replace = TRUE),
                        prodcode = sample(LETTERS, size = N, replace = TRUE), 
                        stringsAsFactors = FALSE)
library(dplyr)
system.time(test <- therapyDF %>% 
              group_by(prodcode) %>% 
              summarize(count = n_distinct(patid)))
test


system.time(test2 <- therapyDF %>% 
              group_by(prodcode) %>% 
              summarize(count = length(unique(patid))))
system.time(test3 <- therapyDF %>% 
              group_by(prodcode) %>% 
              summarize(count = data.table::uniqueN(patid)))

registerDoSEQ()
# cl <- parallel::makeForkCluster(2)
# doParallel::registerDoParallel(cl)
system.time(therapyDF %>%
              group_by(prodcode) %>%
              summarize_par(count = n_distinct(patid)))

system.time(therapyDF %>%
              group_by(prodcode) %>%
              summarize_par(count = data.table::uniqueN(patid)))

therapyDF2 <- therapyDF 
therapyDF2[1, ] <- 1

x <- sample(1:10, 1e5, rep = TRUE)
length(unique(x))
n_distinct(x)
microbenchmark::microbenchmark(
  length(unique(x)),
  n_distinct(x)
)
