l <- list(c(TRUE, FALSE), c(FALSE, FALSE), c(FALSE))
l2 <- lapply(l, which)
l3 <- lengths(l2)
l4 <- l[l3 == 0]
