library(dplyr)

var <- c("wt", "mpg")
mtcars %>% select(!!!var) -> df1
mtcars %>% select(!!!var) -> df2
all.equal(
  bind_rows(df1, df2),
  bind_rows(
    UQ(mtcars %>% select(var)),
    UQ(mtcars %>% select(var))
  )
)


