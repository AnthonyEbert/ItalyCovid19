# Create Italian transition matricies

library(dplyr)

x = readr::read_csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv")
x$data <- lubridate::as_date(x$data)

# Confirmed

x_confirmed <- x %>%
  select(data, denominazione_regione, totale_casi) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione,
    values_from = totale_casi
  ) %>%
  rename(date = data)

readr::write_csv(x_confirmed, path = "protezione-civile-download/transition_matrix_regione_confirmed.csv")

# Deaths

x_deaths <- x %>%
  select(data, denominazione_regione, deceduti) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione,
    values_from = deceduti
  ) %>%
  rename(date = data)

readr::write_csv(x_deaths, path = "protezione-civile-download/transition_matrix_regione_deaths.csv")

# Recovered

x_recovered <- x %>%
  select(data, denominazione_regione, dimessi_guariti) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione,
    values_from = dimessi_guariti
  ) %>%
  rename(date = data)

readr::write_csv(x_recovered, path = "protezione-civile-download/transition_matrix_regione_recovered.csv")


