n <- 6
calls <- setNames(integer(n + 1), 0:n)

compute_fib <- function(n) {
  
  calls[n + 1] <<- calls[n + 1] + 1L
  
  if (n <= 1) return(n)
  
  compute_fib(n - 1) + compute_fib(n - 2)
}

compute_fib(n)
calls

microbenchmark::microbenchmark(
  compute_fib(2),
  compute_fib(5),
  compute_fib(10),
  compute_fib(15),
  compute_fib(20),
  times = 20
)

compute_fib <- memoise::memoise(compute_fib)
n <- 50
calls <- setNames(integer(n + 1), 0:n)
compute_fib(n)
calls

####

my_compute_fib_mem <- function(n) {
  
  prev <- rep(NA_integer_, n)  # we use NAs to say "not computed yet"
  
  compute_fib <- function(n) {
    
    if (n <= 1) return(n)
    
    if (is.na(val <- prev[n + 1])) {  # not computed yet
      val <- prev[n + 1] <<- compute_fib(n - 1) + compute_fib(n - 2)
    } 
    
    val
  }
  
  compute_fib(n)
}

my_compute_fib_mem(50)
