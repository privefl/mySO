# generate genotypes
expand.G = function(n,p){
  probs = runif(n = p)
  G012.rows = matrix(rbinom(2,prob = probs,n=n*p),nrow = p)
  colnames(G012.rows) = paste('s',1:n,sep = '')
  rownames(G012.rows) = paste('g',1:p, sep = '')
  G012.cols = t(G012.rows)
  
  expand.geno = function(g){
    if(g == 0){return(c(1,0,0))}
    if(g == 1){return(c(0,1,0))}
    if(g == 2){return(c(0,0,1))}
  }
  
  gtype = c()
  for(i in 1:length(c(G012.cols))){
    gtype = c(
      gtype,
      expand.geno(c(G012.cols)[i])
    )
  }
  
  length(gtype)
  
  G = matrix(gtype,byrow = T, nrow = p)
  colnames(G) = paste('s',rep(1:n,each = 3),c('1','2','3'),sep = '')
  rownames(G) = paste('g',1:p, sep = '')
  print(G[1:10,1:15])
  print(G012.rows[1:10,1:5])
  
  return(G)
}


reduce012 = function(x){
  if(isTRUE(all.equal(x, c(1,0,0)))){
    return(0)
  } else if(isTRUE(all.equal(x, c(0,1,0)))){
    return(1)
  } else if(isTRUE(all.equal(x,  c(0,0,1)))){
    return(2)
  } else { 
    return(NA)
  }
}

reduce.G = function(G.gen){
  G.vec = 
    mapply(function(i,j) reduce012(as.numeric(G.gen[i,(3*j-2):(3*j)])), 
           i=expand.grid(1:(ncol(G.gen)/3),1:nrow(G.gen))[,2], 
           j=expand.grid(1:(ncol(G.gen)/3),1:nrow(G.gen))[,1]
    )
  
  G = matrix(G.vec, nrow = ncol(G.gen)/3, ncol = nrow(G.gen))
  colnames(G) = rownames(G.gen)
  return(G)
}

reduce.G.loop = function(G.gen){
  G = matrix(NA,nrow = ncol(G.gen)/3, ncol = nrow(G.gen))
  for(i in 1:nrow(G.gen)){
    for(j in 1:(ncol(G.gen)/3)){
      G[j,i] = reduce012(as.numeric(G.gen[i,(3*j-2):(3*j)]))
    }
  }
  colnames(G) = rownames(G.gen)
  return(G)
}

reduce2.G <- function(G) {
  varmap = c("100"=0, "010"=1, "001"=2)
  result <- do.call(rbind, lapply(1:(ncol(G)/3)-1, function(val) 
    varmap[paste(G[,3*val+1], G[,3*val+2], G[,3*val+3], sep="")]))
  colnames(result) <- rownames(G)
  result
}

# G = expand.G(1000,20)
# system.time(reduce.G(G))
# system.time(reduce.G.loop(G))
# 
# G = expand.G(2000,20)
# system.time(reduce.G(G))
# system.time(reduce.G.loop(G))

G = expand.G(4000,20)
system.time(G1 <- reduce.G(G))
system.time(G2 <- reduce.G.loop(G))
system.time(G3 <- reduce2.G(G))
all.equal(G2, G1)
all.equal(G3, G1)


decode <- array(dim = c(3, 3, 3))
decode[cbind(1, 0, 0) + 1] <- 0
decode[cbind(0, 1, 0) + 1] <- 1
decode[cbind(0, 0, 1) + 1] <- 2
decode


system.time(
  G.red <- matrix(decode[matrix(t(G + 1), ncol = 3, byrow = TRUE)], ncol = nrow(G))
)
all.equal(G.red, reduce.G(G), check.attributes = FALSE)

# G2 <- G
# dim(G2) <- c(length(G) / 3, 3)
# G.red2 <- matrix(decode[G2 + 1], ncol = nrow(G))
# all.equal(G.red2, G.red)
