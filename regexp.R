vec <- c("ENSP00000424360.1-D4", "ENSP00000424360.2-D4",
         "ENSP00000424360.3-D4", "ENSP00000437781-D59",
         "XP_010974537.1", "XP_010974538.1", "XP_010974538.2")

library(dplyr)
vec %>%
  sub("\\..+$", "", .) %>%
  sub("-.+$", "", .) %>% 
  unique()
