# parameter1 = if(cond1) then value1 else default_value_of_param

f <- function(x, ind.row = seq_len(nrow(x)), ind.col = seq_len(ncol(x))) {
  x[ind.row, ind.col]
}

f2 <- function(x, ind.row.rm = integer(0), ind.col.rm = integer(0)) {
  f.args <- formals(f)
  f(x, 
    ind.row = `if`(length(ind.row.rm) > 0, -ind.row.rm, eval(f.args$ind.row)),
    ind.col = `if`(length(ind.col.rm) > 0, -ind.col.rm, eval(f.args$ind.col)))
}

x <- matrix(1:6, 2)

f2(x, 1:2)
f2(x, , 1:2)
f2(x, 1, 2)
f2(x, , 1)
f2(x, 1, )
f2(x)
