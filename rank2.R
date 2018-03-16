library(dplyr)
library(purrr)

N <- 2e4
id <- c(1:N)
X <- rnorm(N,mean = 5,sd=100)
DATA <- data.frame(ID =id,Var = X)

percentileCalc <- function(value){
  per_rank <- ((sum(DATA$Var < value)+(0.5*sum(DATA$Var == value)))/length(DATA$Var))
  return(per_rank)
}

res <- numeric(length = length(DATA$Var))
sta <- Sys.time()
for (i in seq_along(DATA$Var)) {
  res[i]<-percentileCalc(DATA$Var[i])
}
sto <- Sys.time()
sto - sta

all.equal(res * N, rank(DATA$Var) - 0.5)

plot(res * N, rank(res))
head(res * N)
head(rank(res))
head(dplyr::percent_rank(DATA$Var))
head(res)

DATA$Var2 <- sample(0:10, size = N, replace = TRUE)

head(rank(DATA$Var2))
percentileCalc2 <- function(value){
  per_rank <- ((sum(DATA$Var2 < value)+(0.5*sum(DATA$Var2 == value)))/length(DATA$Var2))
  return(per_rank)
}
res2 <- numeric(length = length(DATA$Var2))
for (i in seq_along(DATA$Var2)) {
  res2[i]<-percentileCalc2(DATA$Var2[i])
}
head(res2 * N)
all.equal(res2 * N, rank(DATA$Var2) - 0.5)
