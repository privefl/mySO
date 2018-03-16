library(tidyverse)

results6 <- list.files("results6", full.names = TRUE) %>%
  map(~readRDS(.x)) 

coeffs <- results6 %>%
  map(1) %>%
  do.call("cbind", .)

n_enter <- rowSums(coeffs != 0)
mean(n_enter == 0)                ## Proportion of SNPs never entering
n_enter_once <- n_enter[n_enter != 0]
mean(n_enter_once)                ## Mean number of times a SNPs enter 
## if entering at least once
bigstatsr:::MY_THEME(
  qplot(n_enter_once, geom = "bar") +
    labs(x = "Number of times")
)

n_enter <- rowSums(coeffs != 0)
length(always_enter <- which(n_enter == ncol(coeffs)))

library(bigstatsr)
scores <- matrix(NA_real_, nrow(G), length(results6))
for (k in seq_along(results6)) {
  betas <- structure(results6[[k]][[1]], class = "big_CMSA")
  test <- results6[[k]][[2]]
  scores[test, k] <- predict(betas, X = G, ind.row = test, 
                             covar.row = obj.svd$u[test, ])
}
corr <- cor(scores, use = "pairwise.complete.obs")
round(100 * corr, 1)
summary(as.vector(corr[corr != 1]))

plot(as.data.frame(scores[, 1:10]))

qplot(n_enter, -predict(gwas.train.gc))

ind <- which(n_enter == ncol(coeffs))
cowplot::plot_grid(
  snp_manhattan(gwas.train.gc, CHR, POS, labels = labels, 
                ind.highlight = ind),
  snp_manhattan(gwas.train.gc, CHR, POS, labels = labels, 
                ind.highlight = ind) +
    coord_cartesian(ylim = c(0, 25)) + 
    geom_hline(yintercept = -log10(5e-8), color = "red", linetype = 3),
  align = "hv", ncol = 1, labels = LETTERS[1:2], label_size = 25, scale = 0.95
)
ggsave("figures/supp-celiac-man-col2.png", scale = 1/90, width = 1300, height = 1000)

