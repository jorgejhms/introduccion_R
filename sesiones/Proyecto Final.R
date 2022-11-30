library(tidyverse)

url <- "https://www.datosabiertos.gob.pe/node/3008/download"

# posible base a trabajar

data <- read.csv(url)
names(data)

data |> 
  group_by(Diagnostico) |>
  summarise(sum = sum(Atendidos)) |> 
  arrange(-sum)
  

# Limpiar la base