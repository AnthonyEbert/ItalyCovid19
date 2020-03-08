# Adjacency matrix provinces

z = readxl::read_xlsx("Francesco/Adj matrix PROVINCE ITALIA_1.xlsx", skip = 1) %>%
  select(-Regione)

readr::write_excel_csv(z, path = "protezione-civile-download/adjacency_matrix_provinces_3-weights.csv")