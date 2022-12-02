# Librerías usadas en el Proyecto
* quantmod
* lubridate
* dplyr
* tidyr
* ggplot2
* caret
* readr
* randomForest

# Descripción del Proyecto 

En este proyecto usamos los datos sobre el histórico del precio de cierre de las acciones de cierta empresa. Tomamos los datos de manera automática y en tiempo real de la API de Yahoo Finanzas. Con estos datos entrenamos un modelo de `árbol aleatorio` para predecir el comportamiento futuro de las acciones de la empresa en cuestión. Hacemos una predicción de 30 días a futuro. 