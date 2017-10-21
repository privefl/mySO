df <- data.frame(values = c(1,1,2,2,3,4,5,6,6,7))
v <- df$values

S.star <- sum(v / 3) 
n <- length(v)


computeD <- function(p, q, S) {
  n <- length(S)
  S.star <- S[n] / 3
  if (p < q) {
    (S[p] - S.star)^2 + (S[q] - S[p] - S.star)^2 + (S[n] - S[q] - S.star)^2
  } else {
    NA_real_
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
    D[1] <- computeD(1, q, S)
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
# c(my_p, my_q)

getBounds2 <- function(v) {
  S <- cumsum(v)
  n <- length(v)
  S_star <- S[n] / 3
  P0 <- which.min((S - S_star)^2)
  Q0 <- which.min((S - 2*S_star)^2)
  print(min0 <- computeD(P0, Q0, S))
  noDynProg2(S, rep(Inf, n), min0, P0, Q0)
}
v <- sort(runif(1e5, max = 10))
# v <- c(1, 2, 3, 3, 5, 10)
system.time(test2 <- getBounds2(v))
computeD(test2[1], test2[2], cumsum(v))
computeD(3, 5, cumsum(v))

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

P0 <- which.min(abs(cumsum(v) - sum(v)/3))
Q0 <- which.min(abs(cumsum(v) - sum(v)/3*2))
computeD(test2[1], test2[2], S) / computeD(P0, Q0, S)




computeD <- function(p, q, S) {
  n <- length(S)
  S.star <- S[n] / 3
  if (all(p < q)) {
    (S[p] - S.star)^2 + (S[q] - S[p] - S.star)^2 + (S[n] - S[q] - S.star)^2
  } else {
    stop("You shouldn't be here!")
  }
}

optiCut <- function(v) {
  S <- cumsum(v)
  n <- length(v)
  S_star <- S[n] / 3
  # good starting values
  p_star <- which.min((S - S_star)^2)
  q_star <- which.min((S - 2*S_star)^2)
  print(min <- computeD(p_star, q_star, S))
  
  count <- 0
  for (q in 2:(n-1)) {
    S3 <- S[n] - S[q] - S_star
    if (S3*S3 < min) {
      count <- count + 1
      D <- computeD(seq_len(q - 1), q, S)
      ind = which.min(D);
      if (D[ind] < min) {
        p_star = ind;
        q_star = q;
        min = D[ind];
      }
    }
  }
  c(p_star, q_star, computeD(p_star, q_star, S), count)
}


v <- sort(runif(1e5, max = 10))
optiCut(v)
optiCut(c(1, 2, 3, 3, 5, 10))
