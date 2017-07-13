library(tidyverse)

mtcars %>% 
  as_tibble() %>% 
  rownames_to_column("model") %>%
  ggplot(aes(hp, ..count..)) +
  geom_dotplot(binwidth = 10, stackdir = 'center') + 
  geom_text(aes(label = model))


  ggrepel::geom_text_repel(aes(label = model),
                           box.padding = unit(2, 'lines'))
