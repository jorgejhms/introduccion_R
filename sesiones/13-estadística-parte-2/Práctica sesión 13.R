## Creamos la base

id <- seq(1:200)
set.seed(100) # para fijar los números aleatorios
edad <- sample(c("16-29", "30-44"), 200, replace = TRUE)
sexo <- sample(c("Hombre", "Mujer"), 200, replace = TRUE)
peso <- sample(c(50.5:90.3), 200, replace = TRUE)
altura <- sample(c(152:190), 200, replace = TRUE) |>
  as.numeric()
datos <- data.frame(edad, sexo, peso, altura)

## Prueba T

prueba_1 <- t.test(peso ~ edad)

tabla_t <- data.frame(prueba_1$statistic,
                   prueba_1$p.value,
                   t(prueba_1$conf.int))

names(tabla_t) <- c("t_statistic", "p_value", "inf_ic", "sup_ic")

rownames(tabla_t) <- 1

t(tabla_t)

# Prueba de proporciones

library(dplyr)

n_total <- nrow(datos) # frequencia total
hombres <- nrow(filter(datos, sexo == "Hombre")) # frecuencia hombres
mujeres <- nrow(filter(datos, sexo == "Mujer")) # frecuencia mujeres

prueba_2 <- prop.test(c(hombres, mujeres),
                      c(n_total, n_total))

prueba_2

# Prueba de correlaciones

# creemos niveles de glucosa y colesterol (ml)
set.seed(100)
glucosa <- sample(c(138.5:160), 200, replace = TRUE)
colesterol <- sample(c(137.5:200), 200, replace = TRUE)

# juntemos con nuestra base anterior
datos_2 <- cbind(datos, glucosa, colesterol)

# prueba de correlación

prueba_cor <- round(cor(datos_2[,-c(1:2)]),2)

# graficar correlación

# install.packages("corrplot")
library(corrplot)

corrplot(prueba_cor)

grafico <- corrplot(prueba_cor,
                    method = "number",
                    title = "Gráfico de Correlaciones",
                    mar = c(1,1,1,1),
                    tl.cex = 0.7,
                    cl.cex = 0.7,
                    cl.align.text = "l")