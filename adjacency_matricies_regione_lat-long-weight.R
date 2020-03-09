# Create adjacency matrix for countries

library(dplyr)

## Johns Hopkins data -------------

x = read.csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv")

## Get average lat and long for all countries ----------

x1 <- x %>%
  group_by(denominazione_regione) %>%
  summarise(Long = mean(long), Lat = mean(lat))

# Create adjacency matrix

kol = ItalyCovid19::create_adjacency_matrix(x1$denominazione_regione, x1$Lat, x1$Long)
diag(kol) = max(as.numeric(kol[is.finite(as.numeric(kol))])) + 1

write.csv(kol, "protezione-civile-download/adjacency_matrix_regione_lat-long-weight.csv", row.names = TRUE)
