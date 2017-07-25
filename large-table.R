library(pander)
dat <- data.frame(a = rep(1:2, 13), b = paste0(LETTERS, "longtext"))
pander(table(dat$a, dat$b), keep.line.breaks = TRUE)
