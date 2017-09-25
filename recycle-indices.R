vec<-c(letters, 0:9, LETTERS, c("!","§","$","%","&"))
vec

recycle <- function(vec, i) {
  L <- length(vec)
  ind <- (abs(i) - 1) %% L + 1
  res <- ifelse(i > 0, vec[ind], vec[L - ind + 1])
  res[i != 0]
}
print(recycle(vec, 68))
print(recycle(vec, -1))
print(recycle(vec, setdiff(-68:68, 0)))
all.equal(recycle(vec, setdiff(-68:68, 0)), recycle(vec, -68:68))
recycle(vec, 0)


recycle <- function( vec , x ){
  l <- length(vec)   
  #  Deal with negative indices
  if( x < 0 ){
    vec <- rev(vec)
    x <- abs(x)
  }
  #  Extend vector if required index is longer
  if( x > l ){
    t <- x %/% l + 1
    vec <- rep( vec , t )
  }
  # Get value
  vec[x]
}

