library(raster)
library(sp)

setwd("NCEP_DOE_Reanalysis_data")
# Load the combined daily mean stack
daily_mean_stack <- brick("raster_data.tif")

# Define the points with their adjusted longitudes and given latitudes
points <- data.frame(
  lat = c(-1, -2, -3, -4, -7, -11, -12, -16, -19, -22, -24, -26, -28, -30, -32),
  lon = c(-44, -42, -38, -35, -33, -35, -37, -38, -39, -39, -43, -47, -47, -49, -51)
)

# Ajustar as longitudes
points$lon_adjusted <- ifelse(points$lon < 0, points$lon + 360, points$lon)

# Definir as coordenadas espaciais
coordinates(points) <- c("lon_adjusted", "lat")

# Sequência de datas de 1979 a 2023
dates <- seq(as.Date("1979-01-01"), as.Date("2023-12-31"), by = "1 day")

# Inicializar um data frame para armazenar os resultados
extracted_data <- data.frame(date = dates)

# Loop para cada ponto e extrair a série temporal diária
for (i in 1:nrow(points)) {
  # Criar um objeto SpatialPoints para o ponto atual
  point <- points[i, ]
  
  # Extrair a série temporal para o ponto atual
  time_series <- as.vector(extract(daily_mean_stack, point))
  
  # Verificar se a extração foi bem-sucedida
  if (!is.null(time_series)) {
    # Adicionar a série temporal ao data frame como uma nova coluna
    extracted_data <- cbind(extracted_data, time_series)
    
    # Mensagem de sucesso para o ponto atual
    cat(paste("Extração para o ponto", i, "foi bem-sucedida.\n"))
  } else {
    # Mensagem de falha para o ponto atual
    cat(paste("Falha na extração para o ponto", i, ".\n"))
  }
}

names(extracted_data) <- c("date", paste0(points$lon,"_",points$lat))

# Visualizar o data frame extraído
head(extracted_data)

plot(extracted_data[,2], t="l")
write.csv(extracted_data, "extracted_data.csv", row.names = F)

