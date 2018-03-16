mydf <- expand.grid(
  A = letters[1:3],
  B = letters[4:5],
  C = letters[6:7], 
  stringsAsFactors = FALSE
)
mydf$D = runif(nrow(mydf))

ftable(mydf, row.vars = 1, col.vars = 2:3)

myft <- ftable(mydf, row.vars = 1, col.vars = 2:3)

attributes(myft)
myft[] <- mydf$D
