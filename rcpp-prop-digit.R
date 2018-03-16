library(microbenchmark)
v = c('(12) 1221-12121,one-twoooooooooo', 'twos:22-222222222', '34-11111111, ext.123', 
      '01012', '123-456-789 valid', 'no digits', '', NaN, NA)

Fake_Similarity = function(V, TopNDigits) {
  vapply(V, function(v) {
    freq = sort(tabulate(as.integer(charToRaw(v)))[48:57], decreasing = T);
    ratio = sum(freq[1:TopNDigits], na.rm = T) / sum(freq, na.rm = T)
    if (is.nan(ratio)) ratio = 1
    ratio
  },
  double(1))
}



Fake_Similarity2 <- function(V, TopNDigits) {
  vapply(V, function(v) prop_top_digit(charToRaw(v), TopNDigits), 1)
}

system.time(Fake_Similarity(rep(v, 1e4), 2))
system.time(Fake_Similarity2(rep(v, 1e4), 2))

t(rbind(Top1Digit = Fake_Similarity(v, 1), 
        Top2Digits = Fake_Similarity(v, 2), 
        Top3Digits = Fake_Similarity(v, 3)))
t(rbind(Top1Digit = Fake_Similarity2(v, 1), 
        Top2Digits = Fake_Similarity2(v, 2), 
        Top3Digits = Fake_Similarity2(v, 3)))


microbenchmark(Fake_Similarity(v, 2), Fake_Similarity2(v, 2))


v <- 'twos:22-222222222'
(charToRaw(v))
as.integer(charToRaw(paste(0:9, collapse = "")))

stringi::stri_count_regex(v, "[:digit:]") / stringi::stri_length(v)
