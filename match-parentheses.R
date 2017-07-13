gsubfn::strapply()

text <- "I have apples, bananas, ( some pineapples over 4 ), and cherries ( coconuts with happy face :D ) and so on. You may help yourself except for cherries ( they are for my parents sorry ;C ) . I feel like I can run a fruit business."

gsub("\\( (.*) \\)", replacement = "\\1", x = text, fixed = TRUE)


gsubfn::strapply(text, pattern = "\\( (.*?) \\)", fixed = TRUE)[[1]] %>%
  paste(collapse = " ")

library(stringr)
paste(str_extract_all(text, "\\( (.*?) \\)")[[1]], collapse=' ')
