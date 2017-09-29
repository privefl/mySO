N <- 1e4
DATA <- data.frame(
  ID = 1:N, 
  Var = rnorm(N, mean = 5, sd = 100),
  Var2 = sample(0:10, size = N, replace = TRUE)
)

percentileCalc <- function(value) {
  (sum(DATA$Var < value) + 0.5 * sum(DATA$Var == value)) / length(DATA$Var)
}

percentileCalc2 <- function(value) {
  (sum(DATA$Var2 < value) + 0.5 * sum(DATA$Var2 == value)) / length(DATA$Var2)
}

all.equal((rank(DATA$Var) - 0.5) / length(DATA$Var),
          sapply(DATA$Var, percentileCalc))
all.equal((rank(DATA$Var2) - 0.5) / length(DATA$Var2),
          sapply(DATA$Var2, percentileCalc2))


simpleOperation <- function(value) {
  sum(DATA$Var < value)
}
simpleOperation2 <- function(value) {
  sum(DATA$Var2 < value)
}

all.equal(rank(DATA$Var, ties.method = "min") - 1,
          sapply(DATA$Var, simpleOperation))
all.equal(rank(DATA$Var2, ties.method = "min") - 1,
          sapply(DATA$Var2, simpleOperation2))

head(r)

