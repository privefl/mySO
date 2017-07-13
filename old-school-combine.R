dataframe<-data.frame(CIlow_a=c(1.1,1.2),CIlow_b=c(2.1,2.2),CIlow_c=c(3.1,3.2),
                      CIhigh_a=c(1.3,1.4),CIhigh_b=c(2.3,2.4),CIhigh_c=c(3.3,3.4))

dataframe

group<-c("a","b","c")

f<-function(df,gr){
  
  enquo_df<-enquo(df)
  enquo_gr<-enquo(gr)
  
  r<-df%>%
    dplyr::mutate(UQ(paste("CI",enquo_gr,sep="_")):=
                    sprintf("(%s,%s)",
                            paste("CIlow",quo_name(enquo_gr),sep="_"),
                            paste("CIhigh",quo_name(enquo_gr),sep="_")))
  
  return(r)
}



f(df=dataframe,gr=group)

output<-data.frame(CI_a=c("(1.1,1.3)","(1.2,1.4)"),
                   CI_b=c("(2.1,2.3)","(2.2,2.4)"),
                   CI_c=c("(3.1,3.3)","(3.2,3.4)"))

res <- as.data.frame(matrix(NA_character_, nrow(dataframe), ncol(dataframe) / 2))
for (i in seq_along(group)) {
  var <- paste0("CI", c("low", "high"), "_", group[[i]])
  res[[i]] <- sprintf("(%s,%s)", dataframe[[var[[1]]]], dataframe[[var[[2]]]])
}
names(res) <- paste0("CI_", group)