Take this matrix:
  
  mat <- matrix(1:25, 5)
  mat
  [,1] [,2] [,3] [,4] [,5]
  [1,]    1    6   11   16   21
  [2,]    2    7   12   17   22
  [3,]    3    8   13   18   23
  [4,]    4    9   14   19   24
  [5,]    5   10   15   20   25
  
  You can subset it with indices as a matrix:
    
    mat[cbind(1, 1:2)]
  [1] 1 6
  
  You can subset it with boolean indices (which are recycled):
    
    mat[c(TRUE, FALSE), ]
  [,1] [,2] [,3] [,4] [,5]
  [1,]    1    6   11   16   21
  [2,]    3    8   13   18   23
  [3,]    5   10   15   20   25
  
  This is all very intuitive, but when it comes to subsetting with a matrix of logical indices, I don't understand the behaviour anymore:
  
  mat[cbind(TRUE, c(TRUE, FALSE))]
  [1]  1  2  3  5  6  7  9 10 11 13 14 15 17 18 19 21 22 23 25  # length 19
  
  Can someone explain to me why I get this output?

It behaves as mat[c(TRUE, TRUE, TRUE, FALSE)]