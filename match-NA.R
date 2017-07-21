messy <- data.frame(o1 = runif(4),
                    o2 = runif(4),
                    o3 = runif(4),
                    o4 = runif(4))
colSums(messy > 0.5)


original_data <- data.frame(id = 1:10, name = letters[1:10], stringsAsFactors = F)

replacement_dataframe <- data.frame(old_name = c("a","b", "c", "v"), 
                                    new_name = c("abra", "banana", "coconut", "lol"), 
                                    stringsAsFactors = F)


ind <- match(original_data$name, replacement_dataframe$old_name)
original_data$name[!is.na(ind)] <- replacement_dataframe$new_name[ind[!is.na(ind)]]
original_data


original_data <- data.frame(id = 10:1, name = letters[10:1], stringsAsFactors = F)

ind <- match(original_data$name, replacement_dataframe$old_name)
original_data$name[!is.na(ind)] <- replacement_dataframe$new_name[ind[!is.na(ind)]]
original_data
