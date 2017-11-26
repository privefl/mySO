temp <- data.frame(list(col1 = c("424", "560", "557"), 
                        col2 = c("276", "427", "V46"), 
                        col3 = c("780", "V45", "584"), 
                        col4 = c("276", "V45", "995"), 
                        col5 = c("428", "799", "427")),
                   stringsAsFactors = FALSE)
print(temp)

p <- ncol(temp)

myf <- compiler::cmpfun(
  function(x) {
    un <- unique(x)
    d <- p - length(un)
    if (d > 0) {
      un <- c(un, rep(NA_character_, d))
    }
    un
  }
)


microbenchmark::microbenchmark(
  base = apply(t(temp), 2, unique),
  privefl = as.data.frame(t(apply(t(temp), 2, myf))),
  OP = plyr::ldply(apply(temp, 1, function(x) unique(unlist(x))), rbind),
  times = 2
)


temp <- temp[sample(nrow(temp), size = 1e5, replace = TRUE), ]

