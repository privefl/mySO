df <- data.frame(z_a = 1:2,
                 z_b = 1:2,
                 y_a = 3:4,
                 y_b = 3:4, 
                 y_c = 1:2,
                 y_ab = 1:2)

I can select columns names that contain a character with:
  
library(dplyr)
df %>% select(contains("a"), contains("b"))

searchfor <- letters[1:2]

names(df) %>% ("a") 

library(purrr)
ind_lgl <- map_df(letters[1:2], ~ grepl(.x, names(df), fixed = TRUE)) %>%
  pmap_lgl(`|`)

df[ind_lgl]

df %>%
  `[`(map(letters[1:2], ~ grepl(.x, names(df), fixed = TRUE)) %>%
        pmap_lgl(~which(.x)[1]))

rank <- map(letters[1:2], ~ grepl(.x, names(df), fixed = TRUE)) %>%
  pmap(c) %>%
  map(which)

ind_chr <- data_frame(colnames = names(df), rank) %>%
  mutate(l = lengths(rank)) %>%
  filter(l > 0) %>%
  mutate(rank = unlist(map(rank, ~ .x[[1]]))) %>%
  arrange(rank) %>%
  pull(colnames)
