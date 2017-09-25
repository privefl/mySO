library(purrr)
chars <- set_names(c("M", "K"), c("class.1", "class.35"))
x <- "MAKK"
tmp <- charToRaw(x)
charToRaw(chars)


get_split1 <- function(x, chars) {
  x.spl <- strsplit(x, "")[[1]] 
  map(chars, function(chr) {
    which(x.spl == chr)
  })
}
get_split1(x, chars)

get_split2 <- function(x, chars) {
  x.spl <- charToRaw(x)
  map(chars, function(chr) {
    which(x.spl == charToRaw(chr))
  })
}
get_split2(x, chars)

microbenchmark::microbenchmark(
  get_split1(x, chars),
  get_split2(x, chars),
  times = 1000
)
