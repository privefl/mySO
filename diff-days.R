df <- read.table(text = "
customer_id Last_city    First_city       recent_date
1020         Jaipur       Gujarat         20130216
1021         Delhi        Lucknow         20130129
1022         Mumbai       Punjab          20130221", header = TRUE)


library(lubridate)
today() - ymd(df[["recent_date"]])

Sys.Date() - as.Date(as.character(df$recent_date), format = "%Y%m%d") 
