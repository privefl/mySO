OP <- function(words) {
  diffs <- c()
  for (i in seq_along(words)) {
    diffs <- c(diffs, sum(sapply(words, function(y) {
      count <- 0
      elements <- list(words[[i]], y)
      len <- c(length(words[[i]]), length(y))
      if (identical(elements[which(len==max(len))][[1]][-1], elements[which(len==min(len))][[1]]) == 1) {
        count + identical(elements[which(len==max(len))][[1]][-1], elements[which(len==min(len))][[1]])
      } else {
        length(elements[which(len==min(len))][[1]]) <- length(elements[which(len==max(len))][[1]])
        elements <- rapply(elements, f=function(x) ifelse(is.na(x),"$$",x), how="replace" )
        count + sum(elements[[1]] != elements[[2]])
      }
    })== 1))
  }
  diffs
}


words <- list("UU", c("EY", "Z"), c("T", "R", "IH", "P", "UU", "L", "EY"),
              c("AA", "B", "ER", "G"), c("AA", "K", "UU", "N"), c("AA", "K", "ER"))
words

words <- list(c("EY", "Z"), c("M", "EY", "Z"), c("AY", "Z"), c("EY", "D"), c("EY", "Z", "AH"))
words <- rep(words, 100)
# words <- rep(words[1], 10)

get_one_diff <- function(words) {
  
  le <- lengths(words)
  i_chr <- as.character(seq_len(max(le)))
  words.spl <- split(words, le)
  
  test_substitution <- function(i) {
    word1 <- words[[i]]
    do.call(sum, lapply(words.spl[[i_chr[le[i]]]], function(word2) {
      sum(word1 != word2) == 1
    }))
  }
  
  test_addition <- function(i) {
    word1 <- words[[i]]
    le_add <- le[i] + 1
    do.call(sum, lapply(words.spl[[i_chr[le_add]]], function(word2) {
      all(word1 == word2[-1]) || all(word1 == word2[-le_add])
    }))
  }
  
  test_deletion <- function(i) {
    word1 <- words[[i]]
    le <- le[i]
    do.call(sum, lapply(words.spl[[i_chr[le - 1]]], function(word2) {
      all(word1[-1] == word2) || all(word1[-le] == word2)
    }))
  }
  
  sapply(seq_along(words), function(i) {
    test_substitution(i) + test_addition(i) + test_deletion(i)
  })
}

system.time(true <- OP(words))
system.time(test <- get_one_diff(words))
all.equal(test, true)


word1 <- words[[1]]
test_substitution(words[[1]], le_chr[[1]])

diffs <- c()
for (i in seq_along(words)) {
  diffs <- c(diffs, sum(sapply(words, function(y) {
    count <- 0
    elements <- list(words[[i]], y)
    len <- c(length(words[[i]]), length(y))
    if (identical(elements[which(len==max(len))][[1]][-1], elements[which(len==min(len))][[1]]) == 1) {
      count + identical(elements[which(len==max(len))][[1]][-1], elements[which(len==min(len))][[1]])
    } else {
      length(elements[which(len==min(len))][[1]]) <- length(elements[which(len==max(len))][[1]])
      elements <- rapply(elements, f=function(x) ifelse(is.na(x),"$$",x), how="replace" )
      count + sum(elements[[1]] != elements[[2]])
    }
  })== 1))
}


vecLeven <- function(s, t) {
  d <- matrix(0, nrow = length(s) + 1, ncol=length(t) + 1)
  d[, 1] <- (1:nrow(d)) - 1
  d[1,] <- (1:ncol(d))-1
  for (i in 1:length(s))  {
    for (j in 1:length(t)) {
      d[i+1, j+1] <- min(
        d[i, j+1] + 1, # deletion
        d[i+1, j] + 1, # insertion
        d[i, j] + if (s[i] == t[j]) 0 else 1 # substitution
      )
    }
  }
  
  d[nrow(d), ncol(d)]
}


onediff <- sapply(words, function(x) {
  lengthdiff <- sapply(words, function(word) abs(length(word) - length(x)))
  sum(sapply(words[lengthdiff == 0], function(word) sum(word != x) == 1)) +
    sum(mapply(vecLeven, list(x), words[lengthdiff == 1]) == 1)
})