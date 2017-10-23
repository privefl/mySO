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
        # Update optimal values
        p_star = ind;
        q_star = q;
        min = D[ind];
      }
    }
  }
  c(p_star, q_star, computeD(p_star, q_star, S), count)
}

values = sort(sample(as.numeric(1:1000), 1e7, replace = T))
system.time(optiCut(values))
optiCut(c(1, 2, 3, 3, 5, 10))
