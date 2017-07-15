df <- data.frame(Male=1:4, Female=5:8, Territory=c("TEE","TEE","JEB","GAT"), Year=2013, stringsAsFactors = FALSE)
df <- as_data_frame(df)

# Male Female Territory Year
# 1    1      5       TEE 2013
# 2    2      6       TEE 2013
# 3    3      7       JEB 2013
# 4    4      8       GAT 2013

neighbour <- list()
neighbour[['GAT']] <- c("TEE","SHY","BOB")
neighbour[['JEB']] <- c("LEE", "GAT", "BOO")
neighbour[['TEE']] <- c("DON", "RAZ", "ZAP")

# $GAT
# [1] "TEE" "SHY" "BOB"
# $JEB
# [1] "LEE" "GAT" "BOO"
# $TEE
# [1] "DON" "RAZ" "ZAP"

result <- lapply(setNames(nm=df$Female), function(x) {
  #territory of the current female
  FemTer <- df[df$Female == x, "Territory"]
  #males living in the neighbourhood
  df[df$Territory %in% c(FemTer, neighbour[[FemTer]]), "Male"]
})

library(dplyr)

ter_male <- split(df[["Male"]], df[["Territory"]])

ter_male_ext <- lapply(seq_along(ter_male), function(i) {
  ter <- names(ter_male)[[i]]
  ter_ext <- c(ter, neighbour[[ter]])
  sort(unlist(ter_male[ter_ext], use.names = FALSE))
})
names(ter_male_ext) <- names(ter_male)


lapply(split(df[["Territory"]], df[["Female"]]), function(ter) {
  ter_male_ext[[ter]]
})


