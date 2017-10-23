data <- MASS::birthwt
data <- rev(iris)
# Set data sets
X <- cbind(1, scale(as.matrix(data[, -1])))
# X <- X[, -10]
Y <- data[, 1]
Y <- as.numeric(data[, 1] == "setosa")
n <- dim(X)[1]
p <- dim(X)[2]    
beta <- rep(0, p)  # Initialize beta
beta1 <- rep(1, p)  # Initialize beta1


# fit logit regression using Fisher scoring
while (sum(abs(beta - beta1))  > 0.01) {
  beta1 <- beta
  
  # Calculate mu and eta
  eta <- X %*% beta1
  mu <- 1 / (1 + exp(-eta))
  
  # Calculate the derivatives
  # dmu_deta <- exp(eta) / (( 1 + exp(eta)) ^ 2)
  # deta_dmu <- 1 / mu + 1 / (1 - mu)
  
  V <- mu * (1 - mu)  # Calculate the variance function
  Z <- eta + (Y - mu) / V  # Calculate Z
  
  XtW <- sweep(t(X), 2, V, '*')
  beta <- solve(XtW %*% X, XtW %*% Z)
  beta - beta1
}

print(beta)

# qr(X)$rank
# 
# glm(Y ~ X[, - 1], family = "binomial")


glm(Y ~ X[, - 1], family = "binomial")
