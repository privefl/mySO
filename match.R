df <- read.table(textConnection("
id1 id2 id3       inter
  1   2   3       7.343
  6   5   4       2.454
  1   5   6       3.234
"), header = TRUE)


source <- read.table(textConnection("
sid rid 
  1   a
  2   b
  3   c
  4   43454
  5   2254 
  6   43
"), header = TRUE)

tmp <- as.matrix(df[paste0("id", 1:3)]) 
ind <- match(tmp, source$sid)
tmp[] <- as.character(source$rid)[ind]
df[paste0("id", 1:3)] <- tmp
