df <- data.frame(ID = c("a", "b"), A = rnorm(2), B = runif(2), C = rlnorm(2))

plt <- list()
i <- 1
for (colname in names(df)[-1]) {
  plt[[i]] <- ggplot(data = df, aes_string("ID", y = colname)) +
    geom_bar(stat = "identity")
  i <- i + 1 
}
