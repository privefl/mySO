library(dplyr)
df1 <- data.frame(A=c(1.7,1.5,1.7),
                  B=c(0.3,0.3,0.2),
                  C=c("setosa","setosa","setosa")) %>%
  dplyr::mutate_if(is.factor, as.character)
df <- iris %>%
  dplyr::mutate_if(is.factor, as.character)


df[19+0:5, 3 + 0:2]
df1

# find all matches of the top left corner of df1
hits <- which(df == df1[1,1], arr.ind=TRUE)
# remove those matches that can't logically fit in the data
hits <- hits[hits[,"row"] <= nrow(df)-nrow(df1)+1 &
               hits[,"col"] <= ncol(df)-ncol(df1)+1, , drop=FALSE]


for (j in seq_len(ncol(df1))) {
  for (i in seq_len(nrow(df1))) {
    if (i == 1 && j == 1) next
    hits <- hits[df[sweep(hits, 2, c(i, j) - 1, '+')] == df1[i, j], , drop = FALSE]
  }
}
