# Create Global transition matrix

library(dplyr)

## Confirmed

x = read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")

iso3166 <- read.csv("https://raw.githubusercontent.com/AnthonyEbert/COVID-19_ISO-3166/master/JohnsHopkins-to-A3.csv")

x <- x %>%
  left_join(iso3166) %>%
  mutate(Country.Region = alpha3) %>%
  select(-alpha3)

x = x %>%
  group_by(Country.Region) %>%
  summarise_at(names(.)[purrr::partial(startsWith, prefix = "X")(names(.))], sum) %>%
  tidyr::gather(,,-Country.Region)

x$key <- stringr::str_sub(x$key, start = 2) %>%
  lubridate::as_date(format = "%m.%d.%y", tz = "Europe/London")

full_list <- read.csv("https://raw.githubusercontent.com/AnthonyEbert/COVID-19_ISO-3166/master/full_list.csv")

x_full <- expand.grid(full_list$alpha3, levels(factor(x$key)))
x_full <- data.frame(Country.Region = x_full$Var1, key = x_full$Var2)
x_full$key <- lubridate::as_date(x_full$key)

x <- dplyr::left_join(x_full, x) %>%
  mutate(value = replace(.$value, is.na(.$value), 0))

x_confirmed <- x %>%
  tidyr::pivot_wider(
    names_from = "Country.Region",
    values_from = "value"
  ) %>%
  rename(date = key)

readr::write_excel_csv(x_confirmed, path = "johns-hopkins-download/transition_matrix_countries_confirmed.csv")

## Deaths

x = read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv")

x <- x %>%
  left_join(iso3166) %>%
  mutate(Country.Region = alpha3) %>%
  select(-alpha3)

x = x %>%
  group_by(Country.Region) %>%
  summarise_at(names(.)[purrr::partial(startsWith, prefix = "X")(names(.))], sum) %>%
  tidyr::gather(,,-Country.Region)

x$key <- stringr::str_sub(x$key, start = 2) %>%
  lubridate::as_date(format = "%m.%d.%y", tz = "Europe/London")

x <- dplyr::left_join(x_full, x) %>%
  mutate(value = replace(.$value, is.na(.$value), 0))

x_deaths <- x %>%
  tidyr::pivot_wider(
    names_from = "Country.Region",
    values_from = "value"
  ) %>%
  rename(date = key)

readr::write_excel_csv(x_deaths, path = "johns-hopkins-download/transition_matrix_countries_deaths.csv")

## Recovered

x = read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv")

x <- x %>%
  left_join(iso3166) %>%
  mutate(Country.Region = alpha3) %>%
  select(-alpha3)

x = x %>%
  group_by(Country.Region) %>%
  summarise_at(names(.)[purrr::partial(startsWith, prefix = "X")(names(.))], sum) %>%
  tidyr::gather(,,-Country.Region)

x$key <- stringr::str_sub(x$key, start = 2) %>%
  lubridate::as_date(format = "%m.%d.%y", tz = "Europe/London")

x <- dplyr::left_join(x_full, x) %>%
  mutate(value = replace(.$value, is.na(.$value), 0))

x_recovered <- x %>%
  tidyr::pivot_wider(
    names_from = "Country.Region",
    values_from = "value"
  ) %>%
  rename(date = key)

readr::write_excel_csv(x_recovered, path = "johns-hopkins-download/transition_matrix_countries_recovered.csv")


x_confirmed <- x_confirmed %>%
  select(date, CHN) %>%
  mutate(confirmed = CHN) %>%
  select(-CHN)

x_deaths <- x_deaths %>%
  select(date, CHN) %>%
  mutate(deaths = CHN) %>%
  select(-CHN)

x_recovered <- x_recovered %>%
  select(date, CHN) %>%
  mutate(recovered = CHN) %>%
  select(-CHN)

x2 <- left_join(x_confirmed, x_deaths, by = "date") %>% left_join(x_recovered, by = "date")

x = readr::read_csv("https://raw.githubusercontent.com/BlankerL/DXY-COVID-19-Data/master/csv/DXYOverall.csv")

x1 <- x %>%
  mutate(date = lubridate::as_date(updateTime)) %>%
  group_by(date) %>%
  summarise(terapia_intensiva = max(seriousCount, na.rm = TRUE))

china_all <- left_join(x2, x1)

china_all <- china_all %>%
  arrange(date) %>%
  mutate(
    time = 1:n(),
    suscettibili_non_malati = 1439323776 - confirmed,
    dimessi_guariti = recovered,
    deceduti = deaths
  ) %>%
  select(date, time, suscettibili_non_malati, dimessi_guariti, terapia_intensiva, deceduti, confirmed) %>%
  transmute(
    date,
    time,
    susc_not_ill = suscettibili_non_malati,
    recovered = dimessi_guariti,
    intensive_care = terapia_intensiva,
    deceased = deceduti,
    active = confirmed - deceased - recovered
  )

isolamento_dominciliare <- readr::read_csv("China_isolamento_domiciliare.csv")

china_all <- left_join(china_all, isolamento_dominciliare) %>%
  mutate(intensive_care = replace(.$intensive_care, !is.finite(.$intensive_care), NA)) %>%
  transmute(
    date,
    time,
    susc_not_ill,
    recovered,
    quarantene = isolamento_domiciliare,
    intensive_care,
    deceased,
    active
  )

readr::write_csv(china_all, "johns-hopkins-download/china_all.csv")


