
optiCut_K <- function(v, K) {
  
  S <- cumsum(v)
  n <- length(v)
  S_star <- S[n] / K
  # good starting values
  p_vec_first <- sapply(seq_len(K - 1), function(i) which.min((S - i*S_star)^2))
  min_first <- sum((diff(c(0, S[c(p_vec_first, n)])) - S_star)^2)
  
  compute_children <- function(level, ind, val) {
    
    # leaf
    if (level == 1) {
      val <- val + (S[ind] - S_star)^2
      if (val > min_first) {
        return(NULL)
      } else {
        return(val)
      } 
    } 
    
    P_all <- val + (S[ind] - S[seq_len(ind - 1)] - S_star)^2
    inds <- which(P_all < min_first)
    if (length(inds) == 0) return(NULL)
    
    node <- tibble::tibble(
      level = level - 1,
      ind = inds,
      val = P_all[inds]
    )
    node$children <- purrr::pmap(node, compute_children)
    
    node <- dplyr::filter(node, !purrr::map_lgl(children, is.null))
    `if`(nrow(node) == 0, NULL, node)
  }
  
  compute_children(K, n, 0)
}
v <- sort(sample(1:1000, 1e5, replace = TRUE))

test <- optiCut_K(v, 9)

full_unnest <- function(tbl) {
  tmp <- try(tidyr::unnest(tbl), silent = TRUE)
  `if`(identical(class(tmp), "try-error"), tbl, full_unnest(tmp))
}
print(test <- full_unnest(test))
test[which.min(test$children), ]
min_first
