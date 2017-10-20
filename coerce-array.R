ex.array <- array(dim = c(3,3,3))

ex.array[,,1] <- c("N","A","","1","0","N","A","","1")
ex.array[,,2] <- c("0","N","A","","1","0","N","A","")
ex.array[,,3] <- c("1","0","N","A","","1","0","N","A")

desired.array <- array(dim = c(3,3,3))

desired.array[,,1] <- c(NA,NA,NA,1,0,NA,NA,NA,1)
desired.array[,,2] <- c(0,NA,NA,NA,1,0,NA,NA,NA)
desired.array[,,3] <- c(1,0,NA,NA,NA,1,0,NA,NA)

ex.array
desired.array

ex.array[ex.array %in% c("", "N", "A")] <- NA
storage.mode(ex.array) <- "integer"
identical(ex.array, desired.array)
