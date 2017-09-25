a = matrix(rnorm(200e6 * 15), 200e6)
# b = bigmemory::as.big.matrix(a, backingfile="")
# Error in SetMatrixElements(x@address, as.double(j), as.double(i), as.double(value)) : 
#   les vecteurs longs ne sont pas encore supportés : ../../src/include/Rinlinedfuns.h:138
# Erreur pendant l'emballage (wrapup) : les vecteurs longs ne sont pas encore supportés : ../../src/include/Rinlinedfuns.h:138

gc(reset = TRUE)

tmp <- bigstatsr::big_copy(a)
tmp[1, 1]
dim(tmp)
a[1, 1]
