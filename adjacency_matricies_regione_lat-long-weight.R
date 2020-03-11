# Create adjacency matrix for countries

library(dplyr)

## Protezione Civile data -------------

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

## Get average lat and long for all countries ----------

x1 <- x %>%
  group_by(denominazione_regione) %>%
  summarise(Long = mean(long), Lat = mean(lat))

# Create adjacency matrix

kol = ItalyCovid19::create_adjacency_matrix(x1$denominazione_regione, x1$Lat, x1$Long)
diag(kol) = max(as.numeric(kol[is.finite(as.numeric(kol))])) + 1

write.csv(kol, "protezione-civile-download/adjacency_matrix_regione_lat-long-weight.csv", row.names = TRUE)
