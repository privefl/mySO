library(lubridate)
library(dplyr)

a <- c("2014-01-29", "2015-04-07", "2015-04-10", "2025-04-10")
b <- c(NA, "2014-01-29", "2015-04-07", "2015-04-07")
intervals <- 12 * 1:7

get_recency <- function(last_gift_date, refresh_date, intervals) {
  
  
  last_gift_date <- as.Date(last_gift_date)
  refresh_date <- as.Date(refresh_date)
  
  intervals_chr <- c(
    "ERROR",
    paste(c(0, intervals[-length(intervals)] + 1), intervals, sep = "-"), 
    paste0(tail(intervals, 1) + 1, "+")
  )
  
  code <- sapply(c(0, intervals), function(n) {
    last_gift_date %m+% months(n) < refresh_date
  }) %>%
    rowSums()
  
  if_else(condition = is.na(code), true = "ERROR", 
          false = intervals_chr[code + 1])
}

get_recency(b, a, intervals)
