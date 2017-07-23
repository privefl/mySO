library(dplyr)

df <- read.table(text = "Number      ship_no
4432          1
4432          2
4564          1
4389          5
6578          6
4389          3", header = TRUE)

df %>%
  group_by(Number) %>%
  filter(n() > 1) %>%
  summarize(ship_no = paste0(unique(ship_no), collapse = ','))

df %>%
  group_by(Number) %>%
  filter(n() == 2) %>%
  summarize(
    N = length(unique(ship_no)),
    ship_no = paste0(unique(ship_no), collapse = ','),
  )
