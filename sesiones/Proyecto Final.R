# Proyecto Final - Taller Introductorio a R

###---Cargar paquetes----

# 1. Cargar las librerías a usar: dplyr, ggplot2 y janitor

library(dplyr)
library(ggplot2)
library(janitor)

###---Ejercicio 2----

# 2. Guardar la dirección web a usar. Para este ejercicio la dirección
# es "https://www.datosabiertos.gob.pe/node/3008/download"
# Nombrar a este objeto como: url.

url <- "https://www.datosabiertos.gob.pe/node/3008/download"

###---Ejercicio 3----

# 3. La direción url contiene una base en csv delimitada por comas.
# Hay que abrir el archivo csv y guardar el objeto como "data_salud"

data_salud <- read.csv(url, sep = ",")

str(data_salud)
head(data_salud, 2)
summary(data_salud)
names(data_salud)

###---Ejercicio 4----

#4. Revisar como están escritos los nombres de la base. Limpiar los nombres.
# La nueva base guardarla con el nombre dat_salud_limpia.
# Adicionalmente, notaron que la primera variable está escrita como Anio.
# Cambiar el nombre de "anio" por "año"

dat_salud_limpia <- data_salud |>
  clean_names() |>
  rename(año = anio)

names(dat_salud_limpia)

###---Ejercicio 5----

#5. Ahora con la base limpia empecemos a crear tablas resumen.
# Saquemos el número de atendidos por diagnosticos dentro de la base y quedemonos
# con el top 5. A esta tabla llamemos la: tabla_diagnostico

tabla_diagnostico <-  dat_salud_limpia |>
  group_by(diagnostico) |>
  summarise(total = sum(atendidos)) |>
  arrange(-total) |>
  slice(c(1:5))

###---Ejercicio 6----

# 6. Calculemos el porcentaje de personas atendidas por cada uno
# de los trastornos nuevos. Para ellos crearemos una nueva variable en la
# tabla llamada "porcentaje".
# Se realizará una operación matemática entre la suma de diagnosticos atendidos
# entre el número total de atendidos. El número total de atendido lo extraemos
# de la base dat_salud_limpia. Sobreescribimos la tabla_trastorno
# la nueva variable solo debe tener dos decimales (agregarla a la tabla)

n_total <- sum(dat_salud_limpia$atendidos)

tabla_diagnostico <- tabla_diagnostico |>
  mutate(porcentaje = round(total / n_total,2 ))

tabla_diagnostico

###---Ejercicio 7----

# 7a. Este ejercicio lo veremos en dos partes. Veamos por sexo si hay diferencias por género entre el número de atentidos
# por el diagnostico con mayor porcentaje de atendidos.
# Para ello crearemos diferentes vectores.
# Calcularemos el total de hombres y el total de mujeres atendidos por separado
# Acto seguido, calcularemos el total de hombres y mujeres atendidas por 
# el diganostico número 1 en el ranking.
# Cada vector calculado le asignaremos un nombre a criterio del estudiante,

total_gen <- function(base, genero){
  base |>
    filter(sexo == {{genero}}) |>
    summarise(total = sum(atendidos)) |>
    pull()
  }

total_masculino <- total_gen(dat_salud_limpia, "M")
total_femenino <- total_gen(dat_salud_limpia, "F")

violencia_masculino <- dat_salud_limpia |>
    filter(sexo == "M",
           diagnostico == "VIOLENCIA FAMILIAR/MALTRATO INFANTIL") |>
  summarise(total = sum(atendidos)) |> pull()

violencia_femenino <- dat_salud_limpia |>
  filter(sexo == "F",
         diagnostico == "VIOLENCIA FAMILIAR/MALTRATO INFANTIL") |>
  summarise(total = sum(atendidos)) |> pull()

# 7b. Ahora que tengo mis cuatro vectores sacaré la prueba de proporciones
# para saber si hay diferencias entre el número de atentidos 
# de hombre y mujeres. Es una diferencia significativa
# Guarderemos la prop.test como prueba

prueba <- prop.test(c(violencia_masculino, violencia_femenino),
          c(n_total, n_total))

###--Ejercicio 8----

# 8. Finalmente haremos un gráfico de barras para ilustrar las diferencias
# Para estos usaremos el paquete ggplot2.
# En primer lugar crearemos un data frame llamado data_barras.
# convertiremos en data frame el objeto estimate de la prueba que guardamos
# usaremos el siguiente código

data_barras <- data.frame(porcentaje = round(prueba$estimate,2),
                          genero = c("Masculino","Femenino"))


# Ahora pasaremos a crear las barras. 
# Usaremos la opción geom_bar y en stat colocaremos "identity"
# el color de las barras se escogerá a criterio del estudiante
# Asimismo agregaremos etiquetas al grafico con el siguiente código

# geom_text(aes(label = porcentaje, vjust = -1)
          
# Para los títulos usaremos el siguiente código:

# labs(title = "Porcentaje Casos de Violencia Familiar",
#      x = NULL,
#      y = "%")


# Guardar el grafico con el nombre: grafico_barras

grafico_barras <- data_barras |> 
  ggplot(aes(x = genero,
             y = porcentaje)) +
  geom_bar(stat = "identity",
           fill = "dark green") +
  geom_text(aes(label = porcentaje, vjust = -1)) +
  labs(title = "Porcentaje Casos de Violencia Familiar",
       x = NULL,
       y = "%") +
  ylim(0,1)

grafico_barras
