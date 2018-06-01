mystring="lalalal  lalalal lalala   lalalala "
mystring = paste(rep(mystring, 100), collapse = " ")

sequence_of_blanks=function(vectors_of_strings){
  tokens=strsplit(x = mystring,split = "",fixed = TRUE)
  sequence=lapply(X = tokens,FUN = rle)
  resultats=lapply(sequence, function(item){
    resultats=item$lengths[which(item$values==" ")]
  })
}

library(stringr)
tabulate(cumsum(c(TRUE, diff(str_locate_all(mystring, " ")[[1]][,2]) !=1)))
nchar(unlist(str_extract_all(mystring, " +")))


microbenchmark::microbenchmark(
  OP = sequence_of_blanks(mystring),
  akrun = tabulate(cumsum(c(TRUE, diff(str_locate_all(mystring, " ")[[1]][,2]) !=1))),
  wiktor = nchar(unlist(str_extract_all(mystring, " +"))),
  # charToRaw(mystring) == charToRaw(" "),
  fprive = { myrle <- rle(charToRaw(mystring) == charToRaw(" ")); myrle$lengths[myrle$values] }
)


