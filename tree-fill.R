# Install package
# install.packages('data.tree')
library(data.tree)

# Create data frame
to <- c("Ned", "John", "Kate", "Kate", "Kate")
from <- c("John", "Kate", "Dan", "Ron", "Sienna")
hours <- c(1,1,1,1,1)
hours2 <- 5:1
df <- data.frame(from,to,hours, hours2)

# Create data tree
tree <- FromDataFrameNetwork(df)
print(tree, "hours", "hours2")

myApply <- function(node) {
  res.ch <- purrr::map(node$children, myApply)
  a <- node$totalHours <- 
    sum(c(node$hours, purrr::map_dbl(res.ch, 1)), na.rm = TRUE)
  b <- node$totalHours2 <- 
    sum(c(node$hours2, purrr::map_dbl(res.ch, 2)), na.rm = TRUE)
  list(a, b)
}
myApply(tree)
print(tree, "hours", "totalHours", "hours2", "totalHours2")

