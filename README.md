# ItalyCovid19

Data interface to official sources from [Johns Hopkins (International)](https://github.com/CSSEGISandData/COVID-19) and [Protezione Civile (Italy: regione and provincia)](https://github.com/pcm-dpc/COVID-19). These data are downloaded directly from their github repositories and then formatted according to our needs. 

For each level (international, regional, and provincal) we need:

1. an adjacency matrix to measure distances between nodes, and
2. a transition matrix to record the progression of Novel Coronavirus.

## International

### Adjacency matrix (international)

#### Distance between geocoordinates 

Weighted are computed based on distances between geocoordinates. The weights are inversely proportional to the square of the distance between the geocoordinates. The diagonal line is the maximum value of this number plus one. 

#### Distance based on heuristics

...

### Transition matricies (international)

Transition matricies are downloaded and formatted with the R script `johns-hopkins-download.R`. 

## Regional (Italy)

#### Distance between geocoordinates 

Same as international

Transition matricies are downloaded and formatted with the R script `protezione-civile-download.R`. 

