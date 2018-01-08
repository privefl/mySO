n <- 1000; m <- 2000
a <- rnorm(n)
b <- rnorm(m, mean = 1)

s <- c(a, b)
y <- rep(c(0, 1), c(length(a), length(b)))
auc <- bigstatsr::AUC(s, y)
sd <- sqrt((auc) * (1 - auc) + 
             (m - 1) * (auc/(2-auc) - auc^2) +
             (n - 1) * (2 * auc^2 / (1 + auc) - auc^2)) /
  sqrt(n * m)
sd
qnorm(c(0.025, 0.975)) * sd + auc

(aucboot <- bigstatsr::AUCBoot(s, y, nboot = 1e5))

tmp <- Hmisc::somers2(s, y)
