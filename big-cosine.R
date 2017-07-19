library(reshape2)


psm_sample <- read.csv("psm_final_without_null.csv")
numRows = nrow(psm_sample)


##################################

normalize <- function(x) {
  r <- range(x)
  2 * (x - r[1]) / diff(r) - 1 
}

##################################
cat_normalize <- function(x) {
  ifelse(normalize(x) < 0, -1, 1)
}

#############################

cat_gender <- function(sex) {
  sex <- as.character(sex)
  
  if( sex == 'M' ) {
    return (as.integer(1))
  }
  else{
    return(as.integer(2))
  }
}

##################################

cat_admsn_type <- function (type){
  type <- as.character(type)
  
  if( type == 'EMERGENCY' ) {
    return(as.integer(1))
  }
  else if ( type == 'URGENT'){ 
    return(as.integer(2))
  }
  else{
    return(as.integer(3))
  }
}

#############################

cat_first_icu <- function (ficu){
  type <- as.character(ficu)
  
  if( ficu == 'CCU' ) {
    return(as.integer(1))
  }
  else if ( ficu == 'CSRU'){ 
    return(as.integer(2))
  }
  else if ( ficu == 'MICU'){ 
    return(as.integer(3))
  }
  else if ( ficu == 'NICU'){ 
    return(as.integer(4))
  }
  else if ( ficu == 'SICU'){ 
    return(as.integer(5))
  }
  else{
    return(as.integer(6))
  }
}

##################################

cat_last_icu <- function (licu){
  type <- as.character(licu)
  
  if( licu == 'CCU' ) {
    return(as.integer(1))
  }
  else if ( licu == 'CSRU'){ 
    return(as.integer(2))
  }
  else if ( licu == 'MICU'){ 
    return(as.integer(3))
  }
  else if ( licu == 'NICU'){ 
    return(as.integer(4))
  }
  else if ( licu == 'SICU'){ 
    return(as.integer(5))
  }
  else{
    return(as.integer(6))
  }
}

#################################################################################

gender <- sapply(psm_sample$gender,cat_gender)
admission_type <- sapply(psm_sample$admission_type,cat_admsn_type)
first_icu_service_type <- sapply(psm_sample$first_icu_service_type,cat_first_icu)
last_icu_service_type <- sapply(psm_sample$last_icu_service_type,cat_last_icu)

################################################################################

psm_sample_cont_norm_df <- as.data.frame(lapply(psm_sample[8:138], normalize))
psm_sample_cat_df <- data.frame(gender,admission_type,first_icu_service_type,last_icu_service_type)
psm_sample_cat_norm_df <- as.data.frame(lapply(psm_sample_cat_df, cat_normalize))

psm_temp_df <- cbind.data.frame(psm_sample[1], psm_sample_cat_norm_df, psm_sample_cont_norm_df)


row.names(psm_temp_df ) <- make.names(paste0("patid.", as.character(1:nrow(psm_temp_df ))))
psm_final_df <- psm_temp_df[2:136]

###############################################################################


mycosine <- function(x,y){
  c <- sum(x*y) / (sqrt(sum(x*x)) * sqrt(sum(y*y)))
  return(c)
}

cosinesim <- function(x) {
  # initialize similarity matrix
  m <- matrix(NA, nrow=ncol(x),ncol=ncol(x),dimnames=list(colnames(x),colnames(x)))
  cos <- as.data.frame(m)
  
  for(i in 1:ncol(x)) {
    for(j in i:ncol(x)) {
      co_rate_1 <- x[which(x[,i] & x[,j]),i]
      co_rate_2 <- x[which(x[,i] & x[,j]),j]  
      cos[i,j]= mycosine(co_rate_1,co_rate_2)
      cos[j,i]=cos[i,j]        
    }
  }
  return(cos)
}

cs <- cosinesim(t(psm_final_df))
cs_round <-round(cs,digits = 2)



#cs_norm <- as.data.frame(lapply(cs,normalize))
#print(cs_norm)
#print(cs_round)

##########################################

numCols = 3;
totalROws = (numRows * (numRows-1)) / 2;
result <- matrix(nrow = totalROws, ncol = numCols)
#result<- big.matrix( nrow = totalROws, ncol = numCols, type = "double",shared = TRUE)
#options(bigmemory.allow.dimnames=TRUE)

colnames(result) <- c("PatA","PatB","Similarity")

index = 1;
for (i in 1:nrow(cs_round)) {
  patA = rownames(cs_round)[i]
  for (j in i:ncol(cs_round)) {
    if (j > i) {
      patB = colnames(cs_round)[j]
      result[index, 1] = patA
      result[index, 2] = patB
      result[index, 3] = cs_round[i,j]
      
      index = index + 1;
    }
  }
}

print(result)

write.csv(result, file = "C:/cosine/output.csv", row.names = F)
#ord_result<-result[order(result[,3],decreasing=TRUE),]
#print(ord_result)