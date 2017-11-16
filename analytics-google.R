# install.packages("googleAnalyticsR", dependencies = TRUE)
library(googleAnalyticsR)
ga_auth()

# (account_list <- ga_account_list())

data_blog <- google_analytics_4(
  viewId = "152155542",
  date_range = lubridate::ymd("2017-06-04", Sys.Date()),
  dimensions = c("date"),  # , "pagePath", "hour", "medium"
  metrics = c("sessions")  # , "pageviews"
)

data_about <- google_analytics_4(
  viewId = "153879696",
  date_range = lubridate::ymd("2017-06-26", Sys.Date()),
  dimensions = c("date"),  # , "pagePath", "hour", "medium"
  metrics = c("sessions")  # , "pageviews"
)
data_about

blog_dates <- list.files("../RMARKDOWN/blog/_posts/") %>%
  stringr::str_sub(end = 10) %>%
  readr::parse_date()

useR2017_dates <- lubridate::ymd("2017-07-04", "2017-07-07")

papers_dates <- lubridate::ymd("2017-09-17")

library(tidyverse)

data_blog %>%
  ggplot(aes(date, sessions)) %>%
  bigstatsr:::MY_THEME() +
  geom_vline(xintercept = blog_dates, color = "blue",
             linetype = 2, size = 1) +
  # geom_vline(xintercept = useR2017_dates, color = "green",
  #            linetype = 3, size = 1) +
  geom_point(size = 2) +
  geom_line(aes(group = 1), size = 0.8) +
  geom_smooth(method = "loess", span = 0.25, color = "red") +
  labs(x = "Date", y = "Nombre of sessions sur mon blog") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

data_about %>%
  ggplot(aes(date, sessions)) %>%
  bigstatsr:::MY_THEME() +
  geom_vline(xintercept = blog_dates, color = "blue",
             linetype = 2, size = 1) +
  geom_vline(xintercept = useR2017_dates, color = "green",
             linetype = 3, size = 1) +
  geom_vline(xintercept = papers_dates, color = "red",
             linetype = 3, size = 1) +
  geom_point(size = 2) +
  geom_line(aes(group = 1), size = 0.8) +
  geom_smooth(method = "loess", span = 0.25, color = "red") +
  labs(x = "Date", y = "Nombre of sessions sur ma page") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

right_join(data_blog, data_about, by = "date") %>%
  ggplot(aes(sessions.x, sessions.y)) %>%
  bigstatsr:::MY_THEME() +
  geom_point(size = 2) +
  # geom_smooth(method = "loess", color = "red") +
  geom_smooth(method = "lm", color = "blue") +
  labs(x = "Nombre de sessions sur mon blog",
       y = "Nombre of sessions sur ma page") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

filter(data_about, sessions > 6)
#1: 2017-09-12 -> scrapping some medical -> weird
#2: 2017-10-09 -> tuto PCA? ven 6 oct -> lun 9 oct



data_about_country <- google_analytics_4(
  viewId = "153879696",
  date_range = lubridate::ymd("2017-06-26", Sys.Date()),
  dimensions = c("country"),  # , "pagePath", "hour", "medium"
  metrics = c("sessions")  # , "pageviews"
)


data_about_country %>%
  mutate(country2 = ifelse(sessions < 5, "Others", country)) %>%
  ggplot(aes(reorder(country2, -sessions), sessions)) %>%
  bigstatsr:::MY_THEME() +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
