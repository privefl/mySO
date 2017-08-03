germany <- list(a = 2, b = 3)
for (i in 8) {
  eval(parse(text = sprintf("BondDay%d <- list(germany)", i)), envir = -1)
}
