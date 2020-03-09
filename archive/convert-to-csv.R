
# Convert xlsx files to csv

## Region-level

x <- readxl::read_xlsx("Italy_Region.xlsx")
x$Date <- lubridate::as_date(x$Date)
readr::write_excel_csv(x, "Italy_Region.csv")

## Province-level

y <- readxl::read_xlsx("Italy_Province_Infected.xlsx", skip = 1)
y$Date <- lubridate::as_date(y$Date)
readr::write_excel_csv(y, "Italy_Province_Infected.csv")