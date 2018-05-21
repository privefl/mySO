bool_noNA <- function(fun) {
  function(x) {
    res  <- logical(length(x))
    noNA <- !is.na(x)
    res[noNA] <- fun(x[noNA])
    res
  }
}

is_odd <- function(x) {
  x %% 2 == 1
}

is_odd(c(NA, 3:5, NA))

is_odd_noNA <- bool_noNA(is_odd)
is_odd_noNA(c(NA, 3:5, NA))


input <- data.frame(valid=c(T,T,T,F,F), value=c('1','12','13','huh', 'huh'), stringsAsFactors = F)
# A function to check evenness, but who prints an alert if the value is more then 10
fun <- function(x) {
  if(any(as.numeric(x)>10))
    cat(as.numeric(x)[as.numeric(x)>10], '')
  return(as.numeric(x) %% 2==0)
}
cat("Numbers over 10 (unexpected):\n")
pass <- input$valid & fun(input$value)
cat("\nAnd in total we have",sum(pass),"even numbers") 

pass2 <- rep(FALSE, nrow(input))
cat("Numbers over 10 (unexpected):\n")
for(n in 1:nrow(input)) {
  if(input$valid[n]) pass2[n] <- fun(input$value[n])
}
cat("\nAnd in total we have",sum(pass2),"even (valid) numbers")


bool_noNA <- function(fun) {
  function(x, valid) {
    if (missing(valid)) valid <- !is.na(x)
    res  <- logical(length(x))
    res[valid] <- fun(x[valid])
    res
  }
}

is_odd <- function(x) {
  x %% 2 == 1
}

is_odd(c(NA, 3:5, NA))

is_odd_noNA <- bool_noNA(is_odd)
is_odd_noNA(c(NA, 3:5, NA))
is_odd_noNA(c(NA, 3:5, NA), valid = c(F, T, F, F, F))
is_odd_noNA(c(NA, 3:5, NA), valid = c(F, F, T, F, F))

is_odd_noNA(fun)(input$value, input$valid)
