library(dplyr)
files <- list.files(".", pattern = "^vec", full.names = TRUE)
files %>%
  file.info() %>%
  pull(mtime) %>%
  which.max() %>%
  files[.]

ifelse(!dir.exists(file.path("scriptFld")), dir.create(file.path("scriptFld")), FALSE)
strTime = format(Sys.time(), "%H%M")
file.create(NA, paste0("scriptFld/mySource1_", strTime,".R")); Sys.sleep(1)
file.create(NA, paste0("scriptFld/mySource2_", strTime,".R")); Sys.sleep(1)
file.create(NA, paste0("scriptFld/notMySource3_", strTime,".R"))

library(dplyr)
files <- list.files("scriptFld", pattern = "^mySource", full.names = TRUE)
files %>%
  file.info() %>%
  pull(mtime) %>%
  which.max() %>%
  files[.] %>%
  source()