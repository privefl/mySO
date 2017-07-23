df <- read.table(text = "    ID        EndDate  StartDate censor time       status
 1220 1915-03-01 1911-10-04      1 1244        Alive
            4599 1906-02-15 1903-05-16      1 1006        Alive
            6375 1899-04-10 1896-10-27      1  895        Alive
            6386 1929-10-05 1922-01-26      0 1826  Outmigrated
            6389 1933-12-08 1929-10-05      1 1525  Outmigrated
            6390 1932-01-17 1927-07-24      1 1638 Dead_0-4_yrs",
           header = TRUE)

library(tidyverse)
library(lubridate)

df %>%
  as_tibble() %>%
  mutate(
    RangeYear = map2(StartDate, EndDate, function(start, end) {
      start <- `if`(day(start) == 1 && month(start) == 1, 
                    year(start), 
                    year(start) + 1)
      seq(start, year(end))
    })
  ) %>%
  unnest(RangeYear)

