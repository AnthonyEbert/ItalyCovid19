library(dplyr)

francesco_mat = readxl::read_xlsx(
    "Francesco/Adjacence matrix done.xlsx"
  )[-c(1,84),-c(1,2,3)] %>%
  as.matrix()

diag(francesco_mat) = 0
francesco_mat[upper.tri(francesco_mat)] <- 0

francesco_list <- francesco_mat %>%
  Matrix::Matrix(sparse = TRUE) %>%
  summary()

francesco_list[,1] <- levels(factor(y$...3))[francesco_list[,1]]
francesco_list[,2] <- levels(factor(y$...3))[francesco_list[,2]]
francesco_list <- francesco_list[,c(2,1,3)]

xlsx::write.xlsx(francesco_list, "Francesco/francesco_list.xlsx")


