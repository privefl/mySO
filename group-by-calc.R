info <- read.table(text = "C1     C2       near
a      5        0
                   a      25       1
                   a      27       1
                   b      8        1
                   b      12       2
                   b      20       1
                   c      10       0", header = TRUE, stringsAsFactors = FALSE)

info

for (f in 1:5) {
  n <- info$C2[f]
  info$near[f] <- nrow(subset(info, info$C1 == info$C1[f] & info$C2 >= n-10 & info$C2 <= n+10))-1
}

info
library(dplyr)
info %>% 
  group_by(C1) %>% 
  mutate(near = colSums(abs(outer(C2, C2, "-")) <= 10) - 1)
