df <- read.table(text = "a a 1
a b 2
           a c 3
           b b 1
           b c 2
           c c 1")

xtabs(V3 ~ V1 + V2, df)
