prime_logic <- function(n){
  n <- as.integer(n)
  primes <- rep_len(TRUE, n)
  primes[1] <- FALSE
  last.prime <- 2L
  fsqr <- floor(sqrt(n))
  while (last.prime <= fsqr){
    primes[seq.int(2L*last.prime, n, last.prime)] <- FALSE
    sel <- which(primes[seq.int(last.prime+1, fsqr+1)])
    if(any(sel)){
      last.prime <- last.prime + min(sel)
    }else last.prime <- fsqr+1
  }
  primes
}

microbenchmark::microbenchmark(
  tmp1 <- which(prime_logic(1e6)),
  tmp2 <- primefactr::AllPrimesUpTo(1e6)
)
