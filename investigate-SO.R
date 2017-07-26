devtools::install_github("dgrtwo/stackr")
library(stackr)

myID <- "6103040"

myRep <- stack_users(myID, "reputation-history", num_pages = 10)

myTags <- stack_users(myID, "tags", num_pages = 10) %>%
  as_tibble()

library(tidyverse)
(p <- myRep %>%
    arrange(creation_date) %>%
    ggplot(aes(creation_date, cumsum(reputation_change))) %>%
    bigstatsr:::MY_THEME() +
    geom_point() +
    labs(x = "Date", y = "Reputation", 
         title = "My Stack Overflow reputation over time"))

library(lubridate)
p 

myAnswers <- stack_users(myID, "answers", num_pages = 10,
                         fromdate = today() - months(1)) %>%
  select(-starts_with("owner")) %>%
  arrange(desc(score)) %>%
  as_tibble() 



count(myAnswers, "score")
mean(myAnswers$is_accepted)
  
browseAnswers <- function(answers) {
  sapply(paste0("https://stackoverflow.com/questions/", 
                answers$question_id), browseURL)
}

browseAnswers(filter(myAnswers, score >= 5))
browseAnswers(filter(myAnswers, score < 0))


otherId <- "8037249"
otherRep <- stack_users(otherId, "reputation-history", num_pages = 20)

otherRep %>%
    arrange(creation_date) %>%
    ggplot(aes(creation_date, cumsum(reputation_change))) %>%
    bigstatsr:::MY_THEME() +
    geom_point() +
    labs(x = "Date", y = "Reputation", 
         title = "Stack Overflow reputation over time") +
    xlim(as.POSIXct(c(today() - months(1), today()))) +
    geom_smooth(method = "lm")

otherTags <- stack_users(otherId, "tags", num_pages = 10) %>%
  as_tibble()

otherAnswers <- stack_users(otherId, "answers", num_pages = 20,
                            fromdate = today() - months(1)) %>%
  select(-starts_with("owner")) %>%
  arrange(desc(score)) %>%
  as_tibble() 

count(otherAnswers, "score")
mean(otherAnswers$is_accepted)

browseAnswers(filter(otherAnswers, score == 3))
