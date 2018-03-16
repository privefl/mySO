snps <- c("rs2187668", "rs7454108", "rs2395182", "rs7775228", "rs4713586", "rs4639334")


ind <- match(snps, celiac$map$marker.ID)
ind <- ind[!is.na(ind)]
apply(G[, ind], 2, table, celiac$fam$affection)
table(G[, ind[1]], celiac$fam$affection)
table(G[, ind[2]], celiac$fam$affection)
table(G[, ind[3]], celiac$fam$affection)


table(paste(G[, ind[1]], G[, ind[2]], G[, ind[3]]), )


library(xgboost)
y <- celiac$fam$affection - 1

xgbs <- lapply(1:10, function(d) {
  xgboost(data = G[ind.train, ind], label = y[ind.train], nround = 100,
          objective = "binary:logistic", eta = 0.1, max_depth = d)
})

plot(1:10, sapply(xgbs, function(xgb) tail(xgb$evaluation_log$train_error, 1)))

xgb.preds <- predict(xgb, G[ind.test, ind])


data.frame(preds = xgb.preds, pheno = y[ind.test]) %>%
  myggplot() +
  geom_density(aes(preds, fill = as.factor(pheno)), alpha = 0.3)

AUC(xgb.preds, y[ind.test])

xgboost::xgb.plot.tree(feature_names = paste0("V", 1:3), model = xgbs[[4]],
                       n_first_tree = 0)
