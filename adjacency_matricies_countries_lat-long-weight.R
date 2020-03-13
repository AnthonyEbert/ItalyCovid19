# Create adjacency matrix for countries

library(dplyr)

## Johns Hopkins data -------------

x = read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")

iso3166 <- read.csv("https://raw.githubusercontent.com/AnthonyEbert/COVID-19_ISO-3166/master/JohnsHopkins-to-A3.csv")

x <- x %>%
  left_join(iso3166) %>%
  mutate(Country.Region = alpha3) %>%
  select(-alpha3)

## Get average lat and long for all countries ----------

x1 <- x %>%
  group_by(Country.Region) %>%
  summarise(Long = mean(Long), Lat = mean(Lat))

# Create adjacency matrix

kol = ItalyCovid19::create_adjacency_matrix(x1$Country.Region, x1$Lat, x1$Long)
diag(kol) = max(as.numeric(kol[is.finite(as.numeric(kol))])) + 1

write.csv(kol, "johns-hopkins-download/adjacency_matrix_countries_lat-long-weight.csv", row.names = TRUE)
