library(tidyverse)

df <- read.table(text = "Q1                   Q2                  Q3                   Q4    
Strongly_Agree       Strongly_Agree      Agree                Agree
Agree                Strongly_Agree      Agree                Strongly_Agree
Strongly_Agree       Disagree            Strongly_Disagree    Disagree
Disagree             Agree               Strongly_Agree       Agree
Agree                Agree               Disagree             Disagree
Strongly_Disagree    Strongly_Disagree   Disagree             Disagree",
                 header = TRUE)

reshape2::melt(df, id.)
df <- tidyr::gather(df)  # or reshape2::melt(as.list(df))

ggplot(df, aes(key, value)) +
  geom_bar(stat = "Identity")
