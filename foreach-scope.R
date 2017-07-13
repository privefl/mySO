library(foreach)
library(doParallel)
clusters =  makeCluster(4)
registerDoParallel(clusters)


fun1 <- function(param1, param2, param3, fun2)
{
  param4 = param1+param2
  param5 = param2+param3
  param6 = param3+param1
  mmm = foreach(i = 1:length(param1), .combine = rbind) %dopar% {
    fun2(i, param4, param5, param6)
  } 
  print(mmm)
}

fun2 <- function(i, param4, param5, param6)
{
  j = param4[i] * param5[i] * param6[i]
}

param1 = 1:10
param2 = 2:11
param3 = 3:12
fun1(param1, param2, param3, fun2)
