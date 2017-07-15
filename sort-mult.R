dt <- structure(list(
  name1          =  c("C","C","C","C","C","C","B","B","B","B","B","B"),
  name2          =  c("D","E","A","D","E","A","D","E","A","D","E","A"),  
  year           =  c(2012, 2012, 2012, 2010, 2010, 2010, 2012, 2012, 2012, 2010, 2010, 2010 ),
  quarter        =  c(4,4,4,1,1,1,4,4,4,1,1,1),
  time           =  c("2012q4", "2012q4","2012q4","2010q1", "2010q1","2010q1","2012q4", "2012q4","2012q4","2010q1", "2010q1","2010q1")),
  .Names         =  c("name1","name2","year", "quarter", "time"),
  row.names      =  c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"), class =("data.frame")) 

library(dplyr)

arrange(dt, name1, name2, year, quarter)
