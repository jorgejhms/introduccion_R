library(dplyr)
library(janitor)

# Cargando BBDD----

db_juntos <- read.csv("03-Dataset-JUNTOS-informacion-usuarios-I-bimestre-2020.csv", 
                                sep = ";") |>
  clean_names()

# Separando BBDD de Cusco y Arequipa----

db_cusco <- db_juntos |> filter(departamento == "CUSCO")

db_aqp <- db_juntos |> filter(departamento == "AREQUIPA")

# Creando nuevos vectores de no_abonados----

no_abonados_cus <- db_cusco$hogares_afiliados - db_cusco$hogares_abonados

no_abonados_aqp <- db_aqp$hogares_afiliados - db_aqp$hogares_abonados

# Comprobando la extensión de filas

length(no_abonados_cus) == count(db_cusco) 

length(no_abonados_aqp) == count(db_aqp) 

# Juntando columnas----

db_cusco_nueva <- cbind(db_cusco, no_abonados_cus)

db_aqp_nueva <- cbind(db_aqp, no_abonados_aqp)

# Juntando filas----

db_cusco_nueva <- cbind(db_cusco, no_abonados_cus)

db_aqp_nueva <- cbind(db_aqp, no_abonados_aqp)

# Tratando de juntar vectores con diferentes dimensiones----

cbind(db_cusco, no_abonados_aqp)

# Juntando las bases----

db_cusco_nueva <- db_cusco_nueva |> rename(
  no_abonados = no_abonados_cus)

db_aqp_nueva <- db_aqp_nueva |> rename(
  no_abonados = no_abonados_aqp)

db_cus_aqp <- rbind(db_cusco_nueva, db_aqp_nueva)

# ¿Qué pasa si tratamos de juntar dos bases con diferentes columnas?

rbind(db_cusco, db_aqp_nueva)

# Usando groupby y summarise----

db_cus_aqp |>
  group_by(departamento) |>
  summarise(suma_no_abonados = sum(no_abonados))

# que pasa si no coloco group_by

db_cus_aqp |>
  summarise(suma_no_abonados = sum(no_abonados))

# agrupando por provincias

db_cus_aqp |>
  group_by(provincia) |> 
  summarise(suma_no_abonados = sum(no_abonados)) 

# agrupando por provincias y por departamento

db_cus_aqp |>
  group_by(departamento, provincia) |> 
  summarise(suma_no_abonados = sum(no_abonados)) 

# Usando groupby para sacar promedios----

# Recordar que en este caso primero hay que sacar el promedio de transferencias
# por hogar, luego podemos saber el promedio por zona de interés

db_cus_aqp |>
  group_by(departamento) |> 
  summarise(suma_no_abonados = sum(no_abonados),
            prom_transferencias = mean(transferencia/hogares_abonados)) 

resumen_cus_aqp <- db_cus_aqp |>
  group_by(departamento, provincia) |> 
  summarise(suma_no_abonados = sum(no_abonados),
            prom_transferencias = mean(transferencia/hogares_abonados)) 

# Cruzando datos de dos bases----

# Primero bajo datos INEI de epoblación

archivo_pob <- "https://cloud.minsa.gob.pe/s/Jwck8Z59snYAK8S/download"

db_poblacion <- read.csv(archivo_pob, sep = ",") %>%
  clean_names()

# Explora para ver mi información

str(db_poblacion)

## identifico la variable cantidad como la variable de población
## tendré que hacer transformaciones

poblacion_datos <- db_poblacion |>
  select(departamento, provincia, cantidad) |>
  filter(departamento %in% c("CUSCO", "AREQUIPA")) |>
  group_by(departamento, provincia) |>
  summarise(poblacion = sum(cantidad))

## ahora juntaré con right_join la tabla anterior

right_join(resumen_cus_aqp, poblacion_datos, by ="provincia")

