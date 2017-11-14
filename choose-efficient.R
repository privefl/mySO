P_ni <- function(Pn,Pi,eta1,eta2,p,d=NA)
{
  if(is.na(d)) d <- 1-p
  if(Pn==Pi) output <- p^Pn
  else
  {
    if(Pi==1)seq1 <- seq_len(Pn-1)
    if(Pi>1)seq1 <- seq_len(Pn-1)[-seq_len(Pi-1)]
    output <- sum(choose((Pn-Pi-1),c(seq1-Pi))*choose(Pn,seq1)*
                    (eta1/(eta1+eta2))^c(seq1-Pi)*
                    (eta2/(eta1+eta2))^c(Pn-seq1)*p^seq1*d^c(Pn-seq1)
    )
  }
  return(output)
}

P_ni2 <- function(Pn, Pi, eta1, eta2, p, precomputed, d = 1 - p) {
  
  if (Pn == Pi) return(p^Pn)
  
  seq1 <- seq(Pi, Pn - 1)
  
  sum(
    precomputed[Pn-Pi, seq1-Pi+1] *
      precomputed[Pn+1, seq1+1] * 
      (eta1 / eta2 * p / d)^seq1
  ) *
    (eta2/(eta1+eta2) * d)^Pn / (eta1/(eta1+eta2))^Pi
}

eta1 <- 10
eta2 <- 5
p <- 0.4
n_k_matrix <- expand.grid(c(1:400),c(1:400))
n_k_matrix <- n_k_matrix[n_k_matrix[,1] >=n_k_matrix[,2], ]
n_k_matrix <- n_k_matrix[order(n_k_matrix[,1]), ]

system.time({
  n_k_matrix[[3]] <- sapply(1:nrow(n_k_matrix), function(i) {
    P_ni(n_k_matrix[i,1], n_k_matrix[i,2], eta1, eta2, p)
  })
})



P_ni2 <- function(n, eta1, eta2, p, d = 1 - p) {
  
  res <- matrix(0, n, n)
  diag(res) <- p^seq_len(n)
  
  C1 <- eta1 / eta2 * p / d
  C2 <- eta2 / (eta1 + eta2) * d
  C3 <- eta1 / (eta1 + eta2)
  C2_n <- C2^seq_len(n)
  C3_n <- C3^seq_len(n)
  precomputed <- outer(0:n, 0:n, choose)
  
  for (j in seq_len(n)) {
    for (i in seq_len(j - 1)) {
      seq1 <- seq(i, j - 1)
      res[i, j] <- sum(
        precomputed[j-i, seq1-i+1] * precomputed[j+1, seq1+1] * C1^seq1
      ) * C2_n[j] / C3_n[i]
    }
  }
  
  res
}

system.time({
  test <- P_ni2(400, eta1, eta2, p)
  n_k_matrix[[4]] <- test[as.matrix(n_k_matrix[, 2:1])]
})

# for (Pn in 1:5) {
#   for (Pi in seq_len(Pn-1)) {
#     print(P_ni(Pn,Pi,eta1,eta2,p))
#     print(test[Pi, Pn])
#   }
# }

all.equal(n_k_matrix[[3]], n_k_matrix[[4]])
