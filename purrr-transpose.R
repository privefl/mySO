N <- 1e4
example_list <-
  lapply(
    X = 1:2,
    FUN = function(X) {
      setNames(data.frame(X * c(1:N), -X * c(1:N), X * 100 * c(1:N)), c("C1", "C2", "C3"))
    }
  )

example_list
important_cols <- c("C1", "C2")



system.time({
  result <- array(0, c(N, 2, length(important_cols)))
  for(i in 1:N){
    for(j in 1:2){
      result[i,j,] <- c(example_list[[j]][i,important_cols], recursive=T)
    }
  }
})

library(magrittr)

system.time({
  result3 <- example_list %>%
    purrr::map(~ .x[important_cols]) %>%
    purrr::transpose() %>%
    purrr::map(~ do.call(cbind, .x))
})

system.time({
  result2 <- example_list %>%
    lapply(function(df) df[important_cols]) %>%
    purrr::transpose() %>%
    lapply(function(l) do.call(cbind, l))
})

all.equal(result[, , 1], result3[[1]])
all.equal(result[, , 2], result3[[2]])
