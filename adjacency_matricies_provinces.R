# Adjacency matrix provinces

x = readr::read_csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province.csv")

z = readxl::read_xlsx("Francesco/Adj matrix PROVINCE ITALIA_1.xlsx", skip = 1)

# Change factor levels to those used by the Italian government.

z$Provincia <- factor(z$Provincia) %>%
  forcats::fct_recode(
    `Ascoli Piceno` = "Ascoli-Piceno",
    `Forlì-Cesena` = "Forli-Cesena",
    `La Spezia` = "La-Spezia",
    `Massa Carrara` = "Massa-Carrara",
    `Monza e della Brianza` = "Monza-Brianza",
    `Pesaro e Urbino` = "Pesaro-Urbino",
    `Reggio di Calabria` = "Reggio-Calabria",
    `Reggio nell'Emilia` = "Reggio-Emilia",
    `Vibo Valentia` = "Vibo-Valentia"
  )

readr::write_excel_csv(z[,-1], path = "protezione-civile-download/adjacency_matrix_provinces_3-weights.csv")
