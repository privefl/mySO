my_vec <- factor(c(NA,"a","b"),exclude=NA)
levels(my_vec)

levels(my_vec) <- replace(levels(my_vec), levels(my_vec) == "b", "c")
[levels(my_vec) == "b"] <- "c"
levels(my_vec)
str(my_vec)
