library(bigmemory)
tmp <- big.matrix(10, 10, type = "char", backingfile = "test.bk")
describe(tmp)

library(bigsnpr)
x <- snp_attach("../thesis/paper2-PRS/backingfiles/celiacQC_sub1.rds")$genotypes
n <- as.double(x$nrow)
m <- as.double(x$ncol)
desc <- new("big.matrix.descriptor",
            description = list(
              sharedType = "FileBacked", 
              filename = x$backingfile, 
              totalRows = n, totalCols = m, 
              rowOffset = c(0, n), colOffset = c(0, m), 
              nrow = n, ncol = m, 
              rowNames = NULL, colNames = NULL, 
              type = "char", 
              separated = FALSE))

test <- attach.big.matrix(desc)
options(bigmemory.allow.dimnames=TRUE)
rownames(test) <- sprintf("ind_%d 3", rows_along(test))

system.time(
  test2 <- write.big.matrix(test, "testBM.txt", 
                            row.names = TRUE, col.names = FALSE, sep = " ")
)
test[, 1:3]
