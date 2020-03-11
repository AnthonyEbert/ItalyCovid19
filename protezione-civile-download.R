# Create Italian transition matricies

library(dplyr)

x = readr::read_csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv")
x$data <- lubridate::as_date(x$data)
x$codice_regione <- as.numeric(x$codice_regione)

level_tst <- levels(factor(x$denominazione_regione[which(x$codice_regione == 4)]))
x$codice_regione[which(x$denominazione_regione == level_tst[2])] = -1

x <- x %>%
  group_by(codice_regione) %>%
  arrange(data) %>%
  mutate(denominazione_regione = first(denominazione_regione)) %>%
  ungroup()
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




# Ricoverati con sintomi

x_ricoverati_con_sintomi <- x %>%
  select(data, denominazione_regione, ricoverati_con_sintomi) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione,
    values_from = ricoverati_con_sintomi
  ) %>%
  rename(date = data)

readr::write_csv(x_ricoverati_con_sintomi, path = "protezione-civile-download/transition_matrix_regione_ricoverati_con_sintomi.csv")


# Terapia intensiva

x_terapia_intensiva <- x %>%
  select(data, denominazione_regione, terapia_intensiva) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione,
    values_from = terapia_intensiva
  ) %>%
  rename(date = data)

readr::write_csv(x_terapia_intensiva, path = "protezione-civile-download/transition_matrix_regione_terapia_intensiva.csv")

# Isolamento domiciliare

x_isolamento_domiciliare <- x %>%
  select(data, denominazione_regione, isolamento_domiciliare) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione,
    values_from = isolamento_domiciliare
  ) %>%
  rename(date = data)

readr::write_csv(x_isolamento_domiciliare, path = "protezione-civile-download/transition_matrix_regione_isolamento_domiciliare.csv")

# Tamponi

x_tamponi <- x %>%
  select(data, denominazione_regione, tamponi) %>%
  tidyr::pivot_wider(
    names_from = denominazione_regione,
    values_from = tamponi
  ) %>%
  rename(date = data)

readr::write_csv(x_tamponi, path = "protezione-civile-download/transition_matrix_regione_tamponi.csv")



italy_all = x %>%
  group_by(data) %>%
  summarise_if(is.numeric, sum) %>%
  select(-long, -lat) %>%
  mutate(suscettibili_non_malati = 60316771 + first(totale_casi)) %>%
  arrange(data) %>%
  mutate(
    suscettibili_non_malati = suscettibili_non_malati - totale_casi,
    time = 1:length(totale_casi)
  ) %>%
  select(
    time,
    suscettibili_non_malati,
    dimessi_guariti,
    isolamento_domiciliare,
    ricoverati_con_sintomi,
    terapia_intensiva,
    deceduti
  )

readr::write_csv(italy_all, path = "protezione-civile-download/italy_all.csv")



