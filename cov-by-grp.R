library(dplyr)

iris %>%
  group_by(Species) %>%
  summarise(
    sample_cor = cov()
  )

library(purrr)
iris %>%
  slice("Species")


library(reshape2)

df_melt <- melt(iris, id = c("Species"))
df_melt
dcast(iris, Species ~ ., cov)

aggregate(iris, by = list(iris$Species), FUN = cov)

aggregate(Species ~ ., data = iris, FUN = function(x) cov(as.matrix(x)))


tapply(seq_along(iris[[5]]), iris[[5]], FUN = function(ind) {
  cov(iris[ind, -5])
})
