lower <- c(0, 1, 2.5, 5, 12, 26, 40)
upper <- c(lower[-1], 100)
E <- data.frame(ACCNS = sample(lower, 50, replace = TRUE))

ind <- match(E$ACCNS, lower)
E$ACCNSrandom <- runif(length(ind), lower[ind], upper[ind])

E
