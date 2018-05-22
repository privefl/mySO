
summarize_par <- function(grouped_df, ...) {
  
  sizes <- attr(grouped_df, "group_sizes")
  ord <- order(sizes, decreasing = TRUE)
  
  one_group <- function(gdf, i, size) {
    
    size_i <- sizes[i]
    
    structure(
      gdf[attr(gdf, "indices")[[i]] + 1, ], 
      indices = list(0:(size_i - 1)),
      group_sizes = size_i,
      biggest_group_sizes = size_i,
      labels = attr(gdf, "labels")[i, , drop = FALSE]
    )
  }
  
  dots <- dplyr:::named_quos(...)
  res <- foreach(ic = ord) %dopar% {
    dplyr::summarise(one_group(grouped_df, ic), !!!dots)
  }
  
  do.call(rbind, res[match(seq_along(ord), ord)])
}

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

N  <- 2e7
therapyDF <- data.frame(patid = sample.int(N/2, size = N, replace = TRUE),
                        prodcode = sample(LETTERS, size = N, replace = TRUE))
format(object.size(therapyDF), unit = "GB")
library(dplyr)
system.time(true <- therapyDF %>% 
              group_by(prodcode) %>% 
              summarize(count=n_distinct(patid)))

library(doParallel)
registerDoParallel(cl <- makeForkCluster(detectCores() / 2))
system.time(test <- therapyDF %>% 
              group_by(prodcode) %>% 
              summarize_par(count=n_distinct(patid)))
all.equal(true$count, test$count)
stopCluster(cl)

library(future)
plan(multiprocess, workers = 2)
system.time(test2 <- therapyDF %>% 
              group_by(prodcode) %>% 
              summarize_par2(count=n_distinct(patid)))
all.equal(true$count, test2$count)

