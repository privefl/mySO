df <- read.table(text = "time1 time2                              B    1second  3second
2008-01-14 09:29:59           10    0.7      1.5        
2008-01-14 09:29:59           0.1   0.7      1.5
2008-01-14 09:30:00           0.9   NA       1.5
2008-01-14 09:30:00           0.1   NA       1.5
2008-01-14 09:30:00           0.2   NA       1.5
2008-01-14 09:30:00           0.4   NA       1.5
2008-01-14 09:30:00           0.6   NA       1.5
2008-01-14 09:30:00           0.7   NA       1.5
2008-01-14 09:30:02           1.5   NA       NA
2008-01-14 09:30:06           0.1   0.2      0.2
2008-01-14 09:30:06           0.1   0.2      0.2
2008-01-14 09:30:07           0.9   NA       0.3
2008-01-14 09:30:07           0.2   NA       0.3
2008-01-14 09:30:10           0.4   NA       0.3
2008-01-14 09:30:10           0.3   NA       NA
2008-01-14 09:30:25           1.5   NA       NA", header = TRUE) 
df$TimeStmp <- as.POSIXct(paste(df$time1, df$time2))

