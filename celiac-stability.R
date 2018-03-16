
if (!dir.exists("results6")) dir.create("results6")

for (i in seq_len(100)) {
  
  res.file <- paste0("results6/simu_", i, ".rds")
  if (file.exists(res.file)) next
  
  ind.train <- sort(sample(nrow(G)))
  
  cmsa.logit <- big_CMSA(FUN = big_spLogReg, feval = AUC,
                         X = G, y.train = y[ind.train], 
                         ind.train = ind.train, 
                         covar.train = obj.svd$u[ind.train, ],
                         alpha = 0.5, dfmax = 20e3, 
                         ncores = NCORES)
  
  saveRDS(cmsa.logit[cols_along(G)], file = res.file)
}


### Analysis

library(tidyverse)
results6 <- list.files("results6", full.names = TRUE) %>%
  map(~readRDS(.x)) %>%
  do.call("cbind", .)

results6

# cor(results6)
# # cor(results6, method = "kendall")
# pcaPP::cor.fk(results6)

n_enter <- rowSums(results6 != 0)
mean(n_enter == 0)                ## Proportion of SNPs never entering
n_enter_once <- n_enter[n_enter != 0]
mean(n_enter_once)                ## Mean number of times a SNPs enter 
## if entering at least once


bigstatsr:::MY_THEME(
  qplot(n_enter_once, geom = "bar")
)


# sum_weights <- rowSums(results6)
# sum_weights[n_enter == 0] <- NA
# plot(abs(sum_weights), pch = 19, cex = 0.5)

length(always_enter <- which(n_enter == ncol(results6)))
cowplot::plot_grid(
  snp_manhattan(gwas.train.gc, CHR, POS, labels = labels, 
                ind.highlight = always_enter),
  snp_manhattan(gwas.train.gc, CHR, POS, labels = labels, 
                ind.highlight = always_enter) +
    coord_cartesian(ylim = c(0, 25)) + 
    geom_hline(yintercept = -log10(5e-8), color = "red", linetype = 3),
  align = "hv", ncol = 1, labels = LETTERS[1:2], label_size = 25, scale = 0.95
)
ggsave("colored2-manhattan.png", scale = 1/90, width = 1270, height = 1040)


effects_always <- colSums((results6[always_enter, ])^2)
effects_others <- colSums((results6[-always_enter, ])^2)
summary(100 * effects_always / (effects_always + effects_others))
