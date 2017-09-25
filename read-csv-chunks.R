library(tidyverse)

read_csv("FL_insurance_sample.csv.zip", col_types = cols_only(
  eq_site_limit = col_double(),
  hu_site_limit = col_double(),
  fl_site_limit = col_double()
)) %>% 
  filter(eq_site_limit > 0)

read_csv("my.csv", col_types = cols_only(
  column1 = col_double(),
  column2 = col_double(),
  column7 = col_double(),
  column12 = col_double(),
  column15 = col_double()
)) %>%
  filter(column1 == 6 & column7 == 1)

SampleTable<-fread("my.csv", header = T, sep = ",", select=c("column1", "column2", "column7", "column12", "column15"))

library(bigstatsr)
test <- big_readBM("FL_insurance_sample.csv/FL_insurance_sample.csv", 
                   file.nheader = 1,
                   split = ",", read.what = "")
csv <- "FL_insurance_sample.csv/FL_insurance_sample.csv"
colnames <- names(read.csv(csv, header = TRUE, nrows = 1))
colclasses <- rep(list(NULL), length(colnames))
ind <- match(c("eq_site_limit", "hu_site_limit", "fl_site_limit"), colnames)
colclasses[ind] <- "double"

l_df <- list()
con <- file(csv, "rt")
df <- read.csv(con, header = TRUE, nrows = 1, colClasses = colclasses) %>%
  filter(eq_site_limit > 0)
names(df) <- paste0("V", ind)
l_df[[i <- 1]] <- df

repeat {
  i <- i + 1
  df <- read.csv(con, header = FALSE, nrows = 9973, colClasses = colclasses)
  l_df[[i]] <- filter(df, V4 > 0)
  if (nrow(df) < 9973) break
}

df <- do.call("rbind", l_df)


