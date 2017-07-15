a <- c(1,2,3,4)
b <- c(2,3,4,5)
c <- c(5,6,7,8)
d <- c(10,11)
vec_list = list(a = a, b = b, c = c, d = d)
xx = unlist(vec_list, use.names = TRUE)

df_list <- reshape2::melt(vec_list)
df <- read.table(text = "No
1
2
3
4
5
6 
7
8
10
11 ", header = TRUE)

library(dplyr)

left_join(df, df_list, by = c("No" = "value"))
