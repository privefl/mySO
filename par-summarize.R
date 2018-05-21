# Load packages
library(dplyr)
library(multidplyr)

# # We will use built-in dataset - airquality
# # dplyr
# airquality %>% group_by(Month) %>% summarize(cnt = mean(Ozone, na.rm = TRUE))
# 
# # multidplyr
# airquality %>% partition(Month) %>% summarize(cnt = n()) %>% collect()
# 
# 
# library(purrr)
# library(foreach)
# DF <- tmp[!names(tmp) %in% attr(tmp, "vars")]
# tmp <- foreach(attr(tmp, "indices")) {
#   
# }
# 
# 
# dplyr:::group_by.data.frame


tmp <- airquality %>% group_by(Month)
str(tmp)

one_group <- function(gdf, i) {
  gdf2 <- gdf
  ind <- attr(gdf2, "indices") <- attr(gdf2, "indices")[i]
  attr(gdf2, "labels") <- attr(gdf2, "labels")[i, , drop = FALSE]
  attr(gdf2, "biggest_group_sizes") <- attr(gdf2, "group_sizes") <- 
    attr(gdf2, "group_sizes")[i]
  gdf2[ind[[1]] + 1, ]
}
str(tmp)
tmp2 <- one_group(tmp, 4)
str(tmp2)

summarise(one_group(tmp, 2), cnt = n())

library(foreach)
# cl <- parallel::makeForkCluster(3)
# doParallel::registerDoParallel(cl)
registerDoSEQ()
summarize_par <- function(grouped_df, ...) {
  
  one_group <- function(gdf, i) {
    
    gdf2 <- gdf
    
    ind <- attr(gdf2, "indices")[[i]]
    size_i <- attr(gdf2, "group_sizes")[i]
    attr(gdf2, "indices") <- list(0:(size_i - 1))
    
    attr(gdf2, "labels") <- attr(gdf2, "labels")[i, , drop = FALSE]
    attr(gdf2, "biggest_group_sizes") <- attr(gdf2, "group_sizes") <- size_i
      
    gdf2[ind + 1, ]
  }
  
  dots <- dplyr:::named_quos(...)
  foreach(ic = seq_along(attr(grouped_df, "indices")), .combine = rbind) %dopar% {
    dplyr::summarise(one_group(grouped_df, ic), !!!dots)
  }
}

summarize_par(tmp, cnt = n())
summarise(tmp, cnt = n())

str(tmp)



check <- airquality %>% group_by(1)
str(check)
