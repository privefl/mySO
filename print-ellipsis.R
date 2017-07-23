dt <- data.table::data.table(
  Fruit = letters, 
  Ranking = seq_along(letters)
)

print(dt, topn = 3)