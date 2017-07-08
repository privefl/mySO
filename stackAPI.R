library(tidyverse)

c(16632) %>%
  stackr::stack_users("questions") %>%
  select(tags, is_answered, link, title) %>%
  mutate(tags = strsplit(tags, split = ",", fixed = TRUE)) %>%
  filter(map_lgl(tags, ~is.element("r", .x)), !is_answered) %>%
  transmute(paste0("<a href='", link, "' target='_blank'>", title, "</a>")) %>%
  pull()

c(16632) %>%
  stackr::stack_users("questions") %>%
  select(tags, is_answered, link, title) %>%
  mutate(tags = strsplit(tags, split = ",", fixed = TRUE)) %>%
  filter(!is_answered)



print_width_inf <- function(df, n = 6) {
  df %>%
    head(n = n) %>%
    as.data.frame() %>%
    tibble:::shrink_mat(width = Inf, rows = NA, n = n, star = FALSE) %>%
    `[[`("table") %>%
    print()
}

print_width_inf(test)
