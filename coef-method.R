mydata <- readr::read_table("to  RealAge
513 59.608
513 84.18
0   85.23
119 74.764
116 65.356
0   89.03
513 92.117
69  70.243
253 88.482
88  64.23
513 64
4   84.03
65  65.246
69  81.235
513 87.663
513 81.21
17  75.235
117 49.112
69  59.019
20  90.03")[rep(1:20, 3000), ]

mylogit <- nnet::multinom(to ~ RealAge, mydata)
system.time(output <- summary(mylogit))
all.equal(output$coefficients, coef(mylogit))
Coef<-t(as.matrix(output$coefficients))

str(mylogit)
nnet:::summary.multinom
