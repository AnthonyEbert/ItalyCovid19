
library(dplyr)

italy_confirmed <- dplyr::bind_rows(read.csv("johns-hopkins-format/time_series_19-covid-Confirmed_Italy.csv")) %>%
  mutate(Country.Region = Province.State)

italy_recovered <- dplyr::bind_rows(read.csv("johns-hopkins-format/time_series_19-covid-Recovered_Italy.csv")) %>%
  mutate(Country.Region = Province.State)

italy_deaths <- dplyr::bind_rows(read.csv("johns-hopkins-format/time_series_19-covid-Deaths_Italy.csv")) %>%
  mutate(Country.Region = Province.State)

confirmed = read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv") %>%
  filter(Country.Region == "China") %>%
  group_by(Country.Region) %>%
  summarise_at(names(.)[purrr::partial(startsWith, prefix = "X")(names(.))], sum)  %>%
  mutate(Province.State = "total") %>%
  dplyr::bind_rows(italy_confirmed) %>%
  select(Country.Region, Province.State, Lat, Long, starts_with("X"))


recovered = read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv") %>%
  filter(Country.Region == "China") %>%
  group_by(Country.Region) %>%
  summarise_at(names(.)[purrr::partial(startsWith, prefix = "X")(names(.))], sum)  %>%
  mutate(Province.State = "total") %>%
  dplyr::bind_rows(italy_recovered) %>%
  select(Country.Region, Province.State, Lat, Long, starts_with("X"))

deaths = read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv") %>%
  filter(Country.Region == "China") %>%
  group_by(Country.Region) %>%
  summarise_at(names(.)[purrr::partial(startsWith, prefix = "X")(names(.))], sum) %>%
  mutate(Province.State = "total") %>%
  dplyr::bind_rows(italy_deaths) %>%
  select(Country.Region, Province.State, Lat, Long, starts_with("X"))

readr::write_csv(confirmed, "johns-hopkins-format2/confirmed.csv", na = "0")
readr::write_csv(recovered, "johns-hopkins-format2/recovered.csv", na = "0")
readr::write_csv(deaths, "johns-hopkins-format2/deaths.csv", na = "0")
