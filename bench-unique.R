set.seed(1)
N <- 1e6
x <- rpois(N, 0.3)                 ; y <- rpois(N, 0.3)
u <- rnbinom(N, mu = 2, size = .1) ; v <- rnbinom(N, mu = 2, size = .1)

f.df       <- function(x,y) {
  df <- unique(data.frame(x = x, y = y))
  list(df$x, df$y)}

f.tbl <- function(x,y) {
  tbl <- dplyr::distinct(dplyr::tibble(x = x, y = y))
  list(tbl$x, tbl$y)}

f.DF       <- function(x,y) {
  DF <- unique(S4Vectors::DataFrame(x = x, y = y))
  list(DF$x, DF$y)}

f.dt       <- function(x,y) {
  dt <- unique(data.table::data.table(x = x, y = y))
  list(dt$x, dt$y)}

f.cplx     <- function(x,y) {
  u <- unique(complex(real=x, im=y))
  list(Re(u), Im(u))}

microbenchmark::microbenchmark(
  order(x, y),     order(u, v),
  f.df(x,y),       f.df(u,v),
  f.DF(x,y),       f.DF(u,v),
  f.dt(x,y),       f.dt(u,v),
  f.tbl(x,y),      f.tbl(u,v),
  f.cplx(x,y),     f.cplx(u,v),   times = 10L)