# Proyecto Final - Taller Introductorio a R

# 1. Cargar las librerías a usar: dplyr, ggplot2 y janitor

library(dplyr)
library(ggplot2)
library(janitor)

# 2. Guardar la dirección web a usar. Para este ejercicio la dirección
# es "https://www.datosabiertos.gob.pe/node/3008/download"
# Nombrar a este objeto como: url.


# 3. La direción url contiene una base en csv delimitada por comas.
# Hay que abrir el archivo csv y guardar el objeto como "data_salud"


#4. Revisar como están escritos los nombres de la base. Limpiar los nombres.
# La nueva base guardarla con el nombre dat_salud_limpia.
# Adicionalmente, notaron que la primera variable está escrita como Anio.
# Cambiar el nombre de "anio" por "año"


#5. Ahora con la base limpia empecemos a crear tablas resumen.
# Saquemos el número de atendidos por diagnosticos dentro de la base y quedemonos
# con el top 5. A esta tabla llamemos la: tabla_diagnostico


# 6. Calculemos el porcentaje de personas atendidas por cada uno
# de los trastornos nuevos. Para ellos crearemos una nueva variable en la
# tabla llamada "porcentaje".
# Se realizará una operación matemática entre la suma de diagnosticos atendidos
# entre el número total de atendidos. El número total de atendido lo extraemos
# de la base dat_salud_limpia. Sobreescribimos la tabla_trastorno
# la nueva variable solo debe tener dos decimales (agregarla a la tabla)


# 7a. Este ejercicio lo veremos en dos partes. Veamos por sexo si hay diferencias por género entre el número de atentidos
# por el diagnostico con mayor porcentaje de atendidos.
# Para ello crearemos diferentes vectores.
# Calcularemos el total de hombres y el total de mujeres atendidos por separado
# Acto seguido, calcularemos el total de hombres y mujeres atendidas por 
# el diganostico número 1 en el ranking.
# Cada vector calculado le asignaremos un nombre a criterio del estudiante,


# 7b. Ahora que tengo mis cuatro vectores sacaré la prueba de proporciones
# para saber si hay diferencias entre el número de atentidos 
# de hombre y mujeres. Es una diferencia significativa
# Guarderemos la prop.test como prueba


# 8. Finalmente haremos un gráfico de barras para ilustrar las diferencias
# Para estos usaremos el paquete ggplot2.
# En primer lugar crearemos un data frame llamado data_barras.
# convertiremos en data frame el objeto estimate de la prueba que guardamos
# usaremos el siguiente código

# data_barras <- data.frame(porcentaje = prueba$estimate,
#                          genero = c("Hombres","Mujeres"))


# Ahora pasaremos a crear las barras. 
# Usaremos la opción geom_bar y en stat colocaremos "identity"
# el color de las barras se escogerá a criterio del estudiante
# Asimismo agregaremos etiquetas al grafico con el siguiente código

# geom_text(aes(label = round(porcentaje,2), vjust = -1)
          
# Para los títulos usaremos el siguiente código:

# labs(title = "Porcentaje Casos de Violencia Familiar",
#      x = NULL,
#      y = "%")


# Guardar el grafico con el nombre: grafico_barras