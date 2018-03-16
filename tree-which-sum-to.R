df <- read.table(text = "       Client.Code.      Invoice        Amount 
   1:      1004772    20170800563       3620.32
           2:      1005012    20171000389       52661.62
           3:      1005012    20171000466       14800.72
           4:      1004742    20171200022       5445.00
           5:      1004724    20171100426       26620.00")



library(data.tree)

find_solutions <- function(df, client.code, sum.value, print_tree = FALSE) {
  
  df_sub <- subset(df, Client.Code. == client.code)
  df_sub <- df_sub[order(df_sub$Amount, decreasing = TRUE), ]
  n <- nrow(df_sub)
  max <- sum.value
  solutions <- list()
  
  grow_tree <- function(node) {
    
    id <- node$level
    if (id <= n) {
      val <- node$value + df_sub$Amount[id]
      if (val == max) {
        solutions[[length(solutions) + 1]] <<- 
          c(which(node$path[-1] == "yes"), id)
        node$AddChild("yes", value = val)
      } else if (val < max) {
        grow_tree(node$AddChild("yes", value = val))
        grow_tree(node$AddChild("no", value = node$value))
      } else {
        grow_tree(node$AddChild("no", value = node$value))
      }
    }
    
    NULL
  }
  
  grow_tree(root <- Node$new(value = 0))
  
  if (print_tree) print(root, "value")
  
  lapply(solutions, function(ids) df_sub$Invoice[ids])
}

a <- find_solutions(df, client.code = 1005012, sum.value = 67462.34, print_tree = TRUE)

df2 <- df
df2$Client.Code. = 1005012
  
b <- find_solutions(df2, client.code = 1005012, sum.value = 67462.34, print_tree = TRUE)
all.equal(a, b)

