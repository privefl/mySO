################
## Setup data ##
################

sdX1 = 0.33
sdX2 = 0.70
muX1 = log(32765) - 0.5 * sdX1^2
muX2 = log(52650) - 0.5 * sdX2^2

####################################
## PDF for sum of 2 lognormal RVs ##
####################################

d2lnorm = function(z, muX1, muX2, sdX1, sdX2){
  
  #PDFs
  L1 = distr::Lnorm(meanlog = muX1, sdlog = sdX1)
  L2 = distr::Lnorm(meanlog = muX2, sdlog = sdX2)
  
  #Convlution integral
  L1plusL2 = distr::convpow(L1 + L2, 1)
  
  #Density function
  f.Z = distr::d(L1plusL2)
  
  #Evaluate
  return(f.Z(z))
  
}

############################################
## Expectation for sum of 2 lognormal RVs ##
############################################    



curve(f(x), to = 3e5)

integrate(f, lower = 0, upper = 2e8)

ex2lnorm = function(muX1, muX2, sdX1, sdX2){    
  
  f <- function(z) log(z) * d2lnorm(z, muX1 = muX1, muX2 = muX2, sdX1 = sdX1, sdX2 = sdX2)
  
  upper <- 2^10
  cond.lower <- FALSE
  repeat {
    new <- integrate(f, lower = 0, upper = upper)$value
    if (new > 0) cond.lower <- TRUE
    if (cond.lower && new == 0) break
    upper <- upper * 2
    prev <- new
  }
  
  prev
}

##############
## Run code ##
##############

ex2lnorm(muX1, muX2, sdX1, sdX2)

