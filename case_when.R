library(dplyr)

require(dplyr)    
t1 <- mtcars %>%
  mutate(
    mpg_interval = if_else(mpg < 15, "<15",
                           if_else(mpg < 20, "15-19",
                                   if_else(mpg < 25, "20-24", 
                                           ">24")))
  )

t2 <- mtcars %>%
  mutate(
    mpg_interval = case_when(
      mpg < 15 ~ "<15",
      mpg < 20 ~ "15-19",
      mpg < 25 ~ "20-24", 
      TRUE     ~ ">24"
    )
  )

all.equal(t1, t2)