df_climate_1_subset_1 <- data.frame(
  names  = c("t1","t2","t3","t4","t5","t6","t7","t8","t9","t10","t11"),
  value1 = c(2,3.1,4.5,1,6.5,7.1,8.5,9.11,10.1,4,12.3),
  value2 = c(2.5,3.1,4.5,2,12,7.1,8.5,10,10.1,17.8,12.3),
  value3 = c(2,3.1,2,5.1,12,7.1,8.5,9.11,10.1,17.8,12.3),
  value4 = c(1,3.1,4.5,5.1,12,7.1,8.5,1,10.1,17.8,12.3) 
)

subsets_temp <- data.frame(
  names   = c("t1","t2","t3","t4","t5","t6","t7","t8","t9","t10","t11"),
  subset1 = c(5.5,3,4,1,6,7.1,8.5,9.11,10.1,4,12.3),
  subset2 = c(2.5,3.1,4.5,2.5,12,7.1,8.5,10,10.1,17.8,12.3), 
  subset3 = c(1,1,1.1,8.5,9,10.1,1,1.5,3,2,4),
  subset4 = c(1,3.1,4.5,0,12,7.1,0,1,10.1,17.8,12.3) 
)
for (i in 5:100) {
  subset <- paste0("subset", i)
  subsets_temp[[subset]] <- subsets_temp[["subset4"]]
}

df_climate_1_subset_1
subsets_temp

cor(df_climate_1_subset_1[-1], subsets_temp[["subset1"]])



for (a in 1:12) {
  for (b in 1:100) {
    filename <- paste("tmp/df_climate", a, "subset", b, sep = "_")
    write.csv(df_climate_1_subset_1, filename, row.names = FALSE)
  }
}

library(foreach)

res <- foreach(a = 1:12) %:% 
  foreach(b = 1:100, .combine = "cbind") %do% {
    if (b == 1) print(a)
    filename <- paste("tmp/df_climate", a, "subset", b, sep = "_")
    df <- read.csv(filename)
    subset <- paste0("subset", b)
    cor(df[-1], subsets_temp[[subset]])
  }

