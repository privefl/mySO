mean.test <- function(x, y, B=10000,
                      alternative=c("two.sided","less","greater"))
{
  p.value <- 0
  alternative <- match.arg(alternative)
  s <- replicate(B, (mean(sample(c(x,y), B, replace=TRUE))-mean(sample(c(x,y), B, replace=TRUE))))
  return(s)
  t <- mean(x) - mean(y) 
  p.value <- 2*(1- pnorm(abs(quantile(s,0.01)), mean = 0, sd = 1, lower.tail = 
                           TRUE, log.p = FALSE))   #try to calculate p value 
  data.name <- deparse(substitute(c(x,y)))
  names(t) <- "difference in means"
  zero <- 0
  names(zero) <- "difference in means"
  return(structure(list(statistic = t, p.value = p.value,
                        method = "mean test", data.name = data.name,
                        observed = c(x,y), alternative = alternative,
                        null.value = zero),
                   class = "htest"))
}

s <- mean.test(rnorm(1000,3,2),rnorm(2000,4,3))
boxplot(list(rnorm(1000,3,2),rnorm(2000,4,3)))
        
m1 <- replicate(1000, {
  mean(rnorm(1000,3,2))
})

m2 <- replicate(1000, {
  mean(rnorm(2000,4,3))
})
