set.seed(1)
mat <- replicate(1000, sample(c(letters, LETTERS), size = 100, replace = TRUE))

library(dplyr)


columnsID <- function(mat) {
  df <- df0 <- as_data_frame(mat)
  vars <- c()
  while(nrow(df) > 0) {
    var_best <- names(which.max(lapply(df, n_distinct)))[[1]]
    vars <- append(vars, var_best)
    df <- group_by_at(df0, vars) %>% filter(n() > 1)
  }
  vars
}

columnsID(mat)
