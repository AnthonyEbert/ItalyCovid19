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

x <- x %>%
  tidyr::pivot_wider(
    names_from = "Country.Region",
    values_from = "value"
  ) %>%
  rename(date = key)

readr::write_excel_csv(x, path = "johns-hopkins-download/transition_matrix_countries_confirmed.csv")

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

x <- x %>%
  tidyr::pivot_wider(
    names_from = "Country.Region",
    values_from = "value"
  ) %>%
  rename(date = key)

readr::write_excel_csv(x, path = "johns-hopkins-download/transition_matrix_countries_deaths.csv")

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

x <- x %>%
  tidyr::pivot_wider(
    names_from = "Country.Region",
    values_from = "value"
  ) %>%
  rename(date = key)

readr::write_excel_csv(x, path = "johns-hopkins-download/transition_matrix_countries_recovered.csv")

