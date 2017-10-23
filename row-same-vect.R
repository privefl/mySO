a<-matrix(c(1,1,1,0,1,1,0,1,0,1,0,1,0,0,0),5,3)


tcrossprod(a) + tcrossprod(1 - a)


a %&&% t(a)

a<-matrix(sample(c(0,1), size=18, replace=T), ncol=3) # a random matrix 6x3
a

mat<-diag(0,nrow=dim(a)[1])

n<-dim(a)[1]

for( i in 1:(n-1)){
  for (j in (i+1):n){
    mat[i,j]<-sum(ifelse(a[i,]==a[j,],1,0))
  }}
mat

tcrossprod(a) + tcrossprod(1 - a)

