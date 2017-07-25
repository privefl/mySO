for (j in 1:ncol(tmp)) {
  for (i in 1:nrow(tmp)) {
    PNLData[i, j] <- 10 * tmp[i,j] * SpreadData[nrow(SpreadData), j]
  }
}

PNLData <- sweep(10 * tmp, 2, SpreadData[nrow(SpreadData), ], "*")