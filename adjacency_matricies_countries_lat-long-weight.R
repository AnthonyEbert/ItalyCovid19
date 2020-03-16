
x = readr::read_csv("countries_list.csv")
kol = ItalyCovid19::create_adjacency_matrix(x$alpha3, x$lat, x$long)
diag(kol) = max(as.numeric(kol[is.finite(as.numeric(kol))])) + 1
write.csv(kol, "johns-hopkins-download/adjacency_matrix_countries_lat-long-weight.csv", row.names = TRUE)
