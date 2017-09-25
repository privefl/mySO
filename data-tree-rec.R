library(data.tree)
data <- data.frame(pathString = c("MainFolder",
                                  "MainFolder/Folder1",
                                  "MainFolder/Folder2",
                                  "MainFolder/Folder3",
                                  "MainFolder/Folder1/Subfolder1",
                                  "MainFolder/Folder1/Subfolder2"),
                   Value = c(1,1,5,2,4,10))
tree <- as.Node(data, Value)
print(tree, "Value")

# tree$averageBranchingFactor
# 
# tree$Climb(1)
# 
# tree$leafCount
# 
# tree[1]
# attributes(tree)
# 
# Navigate(tree, 1)
# 
# 
# tmp <- tree$children
# tmp$isLeaf
# tmp[[1]]$isLeaf
# tmp[[2]]$isLeaf
# 
# tmp2 <- tmp[[2]]

get_value_by_folder <- function(tree) {
  
  res <- rep(NA_real_, tree$totalCount)
  
  i <- 0
  myApply <- function(node) {
    i <<- i + 1
    force(k <- i)
    res[k] <<- node$Value + `if`(node$isLeaf, 0, sum(sapply(node$children, myApply)))
  }
  
  myApply(tree)
  res
}

get_value_by_folder(tree)

get_value_by_folder2 <- function(tree) {
  
  myApply <- function(node) {
    node$Value_by_folder <- node$Value + `if`(node$isLeaf, 0, 
                                              sum(sapply(node$children, myApply)))
  }
  
  myApply(tree)
  tree
}

print(get_value_by_folder2(tree), "Value", "Value_by_folder")

print(tree, "Value", "Value_by_folder")
