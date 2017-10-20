library(stringr)
library(ncdf4)
library(reshape2)
library(dplyr)

# paths
ruta_datos<-"/home/meteo/PROJECTES/VERSUS/CMEMS/DATA/SST/"
ruta_treball<-"/home/meteo/PROJECTES/VERSUS/CMEMS/TREBALL/"
setwd(ruta_treball)

sst_data_full <- function(inputfile) {
  
  sstFile <- nc_open(inputfile)
  sst_read <- list()
  
  sst_read$lon <- ncvar_get(sstFile, "lon")
  sst_read$lats <- ncvar_get(sstFile, "lat")
  sst_read$sst <- ncvar_get(sstFile, "analysed_sst")
  
  nc_close(sstFile)
  
  sst_read
}

melt_sst <- function(L) {
  dimnames(L$sst) <- list(lon = L$lon, lat = L$lats)
  sst_read <- melt(L$sst, value.name = "sst")
}

# One month list file: This ends with a df of 245855 rows x 33 columns
files <- list.files(path = "SST-CMEMS", pattern = "SST-CMEMS-198201*",
                    full.names = TRUE)

tmp <- sst_data_full(files[1])

library(bigstatsr)
mat <- FBM(length(tmp$sst), length(files))

for (i in seq_along(files)) {
  mat[, i] <- sst_data_full(files[i])$sst
}


sst.out=data.frame()

for (i in 1:length(files) ) { 
  sst<-sst_data_full(paste0(ruta_datos,files[i],sep=""))
  msst <- melt_sst(sst)
  msst<-subset(msst, !is.na(msst$sst))
  
  if ( i == 1 ) {
    sst.out<-msst
  } else {
    sst.out<-cbind(sst.out,msst$sst)
  }
  
}