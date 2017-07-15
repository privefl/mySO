library(MASS)  
out1 <- mvrnorm(40, mu = c(2,4), 
                Sigma = matrix(c(1,.5,
                                 .5,1), ncol = 2),
                empirical = TRUE) #Generates data for first group  
out1<-as.data.frame(out1)   
out1$ivbg<-NA   
out1$ivbg<-1 #identifies group 1

out2 <- mvrnorm(40, mu = c(4,6),Sigma = matrix(c(1,.5,.5,1), ncol = 2),
                empirical = TRUE)
out2<-as.data.frame(out2)  
out2$ivbg<-NA  
out2$ivbg<-2

merged<-rbind(out1,out2) # Put them together

cor(out1$V1,out1$V2) #Group 1 correlations = .5
sd(out1$V1) #Group 1 SD = 1
sd(out1$V2) #Group 1 SD = 1

cor(out2$V1,out2$V2) #Group 2 correlations = .5
sd(out2$V1) #Group 2 SD = 1
sd(out2$V2) #Group 2 SD = 1

cor(merged$V1,merged$V2) #Merged Correlation = .75
sd(merged$V1) #Merged sd = 1.414
sd(merged$V2) #Merged sd = 1.414


merged2 <- merged / sqrt(2)

cor(merged2$V1, merged2$V2) #Merged Correlation = .75
sd(merged2$V1) #Merged sd = 1.414
sd(merged2$V2) #Merged sd = 1.414
