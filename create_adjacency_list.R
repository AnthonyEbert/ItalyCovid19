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

country_names <- factor(colnames(francesco_mat))
country_names <- forcats::fct_recode(
  country_names, 
  Australia = "Australia (Diamond Princess)",
  `Bosnia and Herzegovina` = "Bosnia ed Erzegovina",
  Chad = "Ciad",
  Israel = "Israel (Diamond Princess)",
  Kazakhstan = "Kazakistan",
  Macau = "Macao",
  `Mainland China` = "China",
  `Netherlands` = "Netherland",
  `New Zealand` = "New Zeland",
  `Peru` = "Perù",
  `United Arab Emirates` = "United  Arab Emirates",
  `US` = "USA"
)

francesco_list[,1] <- country_names[francesco_list[,1]]
francesco_list[,2] <- country_names[francesco_list[,2]]
francesco_list <- francesco_list[,c(2,1,3)]

readr::write_csv(francesco_list, "Francesco/francesco_list.csv")


