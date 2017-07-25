H10 <- read.table(text = "            DV1_C           DV2_C         DV3_C           DV4_C     t10dv
                 1               1               0               0               1 0.3880952
                 2              -1               0               2              -1 0.3880952
                 3               0               0               0               0 0.3880952
                 4               0               2               1               1 0.3880952
                 5              -1              -1              -1              -2 0.3880952
                 6              -2               0               0               0 0.3880952
                 ", header = TRUE)


H10$t10dv <- rowMeans(H10[c("DV1_C", "DV2_C", "DV3_C", "DV4_C")])
