bedfile <- "../POPRES_data/POPRES_allchr_QC_norel.bed"

library(bigsnpr)

# rdsfile <- snp_readBed(bedfile, "backingfiles/popres")
popres <- snp_attach("backingfiles/popres.rds")
G <- popres$genotypes
n <- nrow(G)
m <- ncol(G)

Rcpp::sourceCpp('bedadapt.cpp')
test <- bedadaptXPtr(bedfile, n, m)

Rcpp::sourceCpp('bedadapt2.cpp')
## Checking a 3 is much faster that checking a NA
lookup <- bigsnpr:::getCode(NA.VAL = 3)
storage.mode(lookup) <- "double"
test2 <- bedadapt2XPtr(bedfile, n, m, lookup)
cmpt_af2(test2)

library(microbenchmark)
microbenchmark(
  maf1 <- cmpt_af(test),
  maf2 <- snp_MAF(G),
  maf3 <- cmpt_af2(test2),
  times = 5
)
all.equal(maf1, maf2)
all.equal(maf3, maf2)
