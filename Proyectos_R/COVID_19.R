# Invocando las librerías necesarias
library("quantmod")
library("lubridate")
library("dplyr")
library("tidyr")
library("ggplot2")
library("caret")
library(readr)

Confirmados_Nacionales <- read_csv("Casos_Diarios_Estado_Nacional_Confirmados_20220613.csv")

Confirmados_Nacionales <- as.data.frame(Confirmados_Nacionales[33,5:(ncol(Confirmados_Nacionales)-2)])
Confirmados_Nacionales <- as.data.frame(t(Confirmados_Nacionales))

rownames(Confirmados_Nacionales) = NULL
colnames(Confirmados_Nacionales) = "Confirmados"

vector_tiempos <- 1:nrow(Confirmados_Nacionales)

Confirmados_Nacionales <- cbind(Confirmados_Nacionales,vector_tiempos)
colnames(Confirmados_Nacionales)[2] = "Tiempo_días"

ggplot() + geom_line(data = Confirmados_Nacionales, aes(x = Tiempo_días, y = Confirmados), color = "blue")

rango_tiempos <- (nrow(Confirmados_Nacionales)+1):(nrow(Confirmados_Nacionales) + 3)
Confir <- as.numeric(NA)
CN_aux <- as.data.frame(cbind(Confir,rango_tiempos))
colnames(CN_aux)[1] = "Confirmados"
colnames(CN_aux)[2] = "Tiempo_días"
Confirmados_Nacionales <- rbind(Confirmados_Nacionales,CN_aux)

Confirmados_Nacionales_sc <- as.data.frame(cbind(Confirmados_Nacionales$Confirmados, scale(Confirmados_Nacionales$Tiempo_días)))
colnames(Confirmados_Nacionales_sc) = c("Confirmados","Tiempo_días")

library(randomForest)
set.seed(5000)
index <- max(na.omit(Confirmados_Nacionales)$Tiempo_días)
train <- createDataPartition(na.omit(subset(Confirmados_Nacionales, Confirmados_Nacionales$Tiempo_días < index))$Confirmados, 
                             p = 0.7, list = F)
test <- rbind(na.omit(Confirmados_Nacionales[-train,]),subset(Confirmados_Nacionales, Confirmados_Nacionales$Tiempo_días > index))

mod_rf <- randomForest(Confirmados ~ Tiempo_días, data = Confirmados_Nacionales[train,],
                       type = "regression", ntree = 400)
pred_rf = predict(mod_rf, test)

datos_rf <- cbind(pred_rf, test)
ggplot() + geom_line(data = datos_rf, aes(x = Tiempo_días, y = Confirmados), color = "blue") + geom_line(data = datos_rf, aes(x = Tiempo_días, y = pred_rf, color = "red"))

