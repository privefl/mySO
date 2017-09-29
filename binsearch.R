

l = ceiling(runif(100000, min = 0, max = 19999))
l = sort(l, decreasing = T)

df = data.frame(l = l)
df$cs = cumsum(df$l)

t = 18000

res <- integer(nrow(df))

system.time({
  for(i in 1:nrow(df)){
    n = df$l[min(which(df$cs>df$cs[i]/2))]
    res[i] <- n
    if(n < t){ break }
  }
})

test <- sapply(1:nrow(df), function(i) df$l[min(which(df$cs>df$cs[i]/2))])
plot(test) # n is strinctly decreasing with i

binSearch <- function(min, max) {
  print(mid <- floor(mean(c(min, max))))
  if (mid == min) {
    if (df$l[min(which(df$cs>df$cs[min]/2))] < t) {
      return(min - 1)
    } else {
      return(max - 1)
    }
  }
  
  n = df$l[min(which(df$cs>df$cs[mid]/2))]
  if (n >= t) {
    return(binSearch(mid, max))
  } else {
    return(binSearch(min, mid))
  }
}


(test <- binSearch(1, nrow(df)))
debug(binSearch)

result = as.integer(i-1)



