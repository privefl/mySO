library(dplyr)

A <- NULL
B <- NULL
`%W>%` <- function(lhs, rhs) {
  call <- substitute(`%>%`(lhs, rhs))
  eval(withr::with_options(c("warn" = -1), eval(call)), parent.frame())
}


data.frame(a= c(1,-1)) %W>% mutate(a=sqrt(a)) %>% cos

c(1,-1) %W>% sqrt()



withr::with_options(c("warn" = -1), `%>%`(c(1, -2), sqrt()))

