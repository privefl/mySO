require(dplyr)
require(tidyr)
require(lubridate)

StartDate <- c("2017-01-01T01:36:17.000Z", "2017-01-01T01:36:17.000Z")
Num <- c(1,2)
DataFrame <- data_frame(Num, StartDate)

DataFrame <- DataFrame %>%
  separate(StartDate , into = c("NewDate", "tail"), sep = "T") %>%
  mutate(NewDate= ymd(NewDate)) %>%
  select(-tail)

ztime <- function(df, datecol, newcol) {
  df[[newcol]] <- lubridate::ymd_hms(df[[datecol]])
}

