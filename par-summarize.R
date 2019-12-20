# Load packages
library(dplyr)

tmp <- airquality[rep(seq_len(nrow(airquality)), 1e5), ] %>% 
  group_by(Month)
str(tmp)


library(doParallel)
NCORES <- detectCores() - 1
registerDoParallel(cl <- makeForkCluster(NCORES))
# registerDoSEQ()
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

system.time(
  summarize_par(tmp, cnt = n())
)

system.time(
  summarise(tmp, cnt = n())
)


library(future)

summarize_par2 <- function(grouped_df, ...) {
  
  sizes <- attr(grouped_df, "group_sizes")
  
  one_group <- function(gdf, i, size) {
    
    size_i <- attr(grouped_df, "group_sizes")[i]
    
    structure(
      gdf[attr(gdf, "indices")[[i]] + 1, ], 
      indices = list(0:(size_i - 1)),
      group_sizes = size_i,
      biggest_group_sizes = size_i,
      labels = attr(gdf, "labels")[i, , drop = FALSE]
    )
  }
  
  dots <- dplyr:::named_quos(...)
  res <- listenv::listenv()
  for (i in order(sizes, decreasing = TRUE)) {
    df_one_group <- one_group(grouped_df, i)
    res[[i]] %<-% dplyr::summarise(df_one_group, !!!dots)
  }
  
  do.call(rbind, as.list(res))
}

stopCluster(cl)
plan(multiprocess, workers = NCORES)
system.time(
  summarize_par2(tmp, cnt = n())
)

