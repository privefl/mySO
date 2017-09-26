df <- data.frame(values = c(1,1,2,2,3,4,5,6,6,7))
v <- df$values

S.star <- sum(v / 3) 
n <- length(v)


test <- function(p, q, S) {
  n <- length(S)
  S.star <- tail(S, 1)
  if (p < q) {
    (S[p] - S.star)^2 + (S[q] - S[p] - S.star)^2 + (S[n] - S[q] - S.star)^2
  } else {
    NA
  }
}

test(5, 7, S, S.star)
test(6, 8)

q <- 8
D <- double(length(v))
S <- cumsum(v)
S.star <- tail(S, 1) / 3
D[1] <- test(1, q, S, S.star)
for (i in 2:(q-1)) {
  D[i] = D[i-1] + 2 * v[i] * (v[i] + 2 * S[i-1] - S[q])
}
D
sapply(1:7, function(p) test(p, q))



v <- sort(sample(1:10, 1e4, replace = TRUE))

system.time({
  n <- length(v)
  D <- rep(NA_real_, n)
  S <- cumsum(v)
  min <- Inf
  for (q in 3:(n-1)) {
    D[1] <- test(1, q, S)
    for (i in 2:(q-1)) {
      D[i] = D[i-1] + 2 * v[i] * (v[i] + 2 * S[i-1] - S[q])
    }
    ind <- which.min(D)
    if (D[ind] < min) {
      my_p <- ind
      print(my_q <- q)
      min <- D[ind]
    } 
  }
})

v <- sort(sample(1:10, 1e5, replace = TRUE))

Rcpp::sourceCpp('opti-dyn-prog.cpp')
getBounds <- function(v) {
  n <- length(v)
  D <- rep(Inf, n)
  S <- cumsum(v)
  S.star <- S[n] / 3
  D_init <- (S[1] - S.star)^2 + (S - S[1] - S.star)^2 + (S[n] - S - S.star)^2
  dynProg(v, S, D, D_init)
}

system.time(test <- getBounds(v))
test
c(my_p, my_q)


# q <- 8000
# D[1] <- test(1, q, S)
# for (i in 2:(q-1)) {
#   D[i] = D[i-1] + 2 * v[i] * (v[i] + 2 * S[i-1] - S[q])
# }
# head(D)
# D2 <- sapply(1:(q-1), function(p) test(p, q, S))
# head(D2)
# all.equal(D2[1:(q-1)], D[1:(q-1)])
test(my_p, my_q, S)

P1 <- which.min(abs(cumsum(v) - sum(v)/3))
Q1 <- which.min(abs(cumsum(v) - sum(v)/3*2))
test(my_p, my_q, S) / test(P1, Q1, S)
