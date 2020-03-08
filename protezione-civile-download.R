# Create Italian transition matricies

library(dplyr)

x = readr::read_csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv")
x$data <- lubridate::as_date(x$data)

x <- x %>%
  select(data, denominazione_regione, totale_casi) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione, 
    values_from = totale_casi
  ) %>%
  rename(date = data)

readr::write_excel_csv(x, path = "protezione-civile-download/transition_matrix_regione_confirmed.csv")


