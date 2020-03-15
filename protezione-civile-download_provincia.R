# Provincia

x = read.csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province.csv")
x$data <- lubridate::as_date(x$data)
x$denominazione_provincia <- as.character(x$denominazione_provincia)

x$denominazione_provincia[which(stringr::str_starts(x$denominazione_provincia, "In fase"))] <- as.character(x$denominazione_regione[which(stringr::str_starts(x$denominazione_provincia, "In fase"))])

x_provincia <- x %>%
  select(data, denominazione_provincia, totale_casi) %>%
  tidyr::pivot_wider(
    names_from = denominazione_provincia,
    values_from = totale_casi
  ) %>%
  rename(date = data)

readr::write_excel_csv(x_provincia, path = "protezione-civile-download/transition_matrix_provincia_confirmed.csv")
