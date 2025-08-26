# ------------------------------------------------------------------
# Script 02: Clasificación y análisis de dependencia categórica
# ------------------------------------------------------------------
# Este script transforma variables numéricas en categóricas:
#   - Agrupa VENTAS en intervalos homogéneos (agrupación cuantitativa)
#   - Clasifica las empresas por tamaño, según NÚMERO DE EMPLEADOS
#
# Posteriormente se evalúa la posible dependencia entre ambas
# clasificaciones mediante tablas de contingencia y el test
# de Chi-cuadrado.
#
# Requiere que el dataset 'data' esté previamente cargado y que
# las librerías necesarias estén importadas desde el script principal.
# ------------------------------------------------------------------


# ---------------------------------------------
# Clasificación de Ventas en Intervalos Homogéneos
# ---------------------------------------------
# Se agrupan las empresas en clases de ventas usando una fórmula
# basada en el rango y el tamaño muestral. Esto permite categorizar
# una variable continua de forma estructurada.

ventas_min <- min(data$VENTAS, na.rm = TRUE)
ventas_max <- max(data$VENTAS, na.rm = TRUE)

n_datos <- nrow(data)  # Total de observaciones

# Cálculo de la amplitud de intervalo según la regla de Sturges modificada
amplitud_intervalo <- (ventas_max - ventas_min) / sqrt(n_datos)

# Generación de puntos de corte equidistantes
intervalos_ventas <- seq(ventas_min, ventas_max, by = amplitud_intervalo)

# Asignación de cada empresa a un intervalo de ventas
data_2 <- data %>%
  mutate(
    VENTAS_INTERVALO = cut(
      VENTAS,
      breaks = intervalos_ventas,
      include.lowest = TRUE,
      labels = FALSE  # Devuelve códigos numéricos en lugar de etiquetas
    )
  )


# ---------------------------------------------
# Categorización del Número de Empleados
# ---------------------------------------------
# Se clasifica cada empresa según su tamaño, conforme a los
# estándares comunes de la Unión Europea:

#   - Microempresa:       1–9 empleados
#   - Pequeña empresa:   10–49 empleados
#   - Mediana empresa:   50–249 empleados
#   - Gran empresa:     250+ empleados

data_2 <- data_2 %>%
  mutate(
    CATEGORIA_EMPLEADOS = case_when(
      `NÚMERO DE EMPLEADOS` >= 1 & `NÚMERO DE EMPLEADOS` <= 9    ~ "Microempresa",
      `NÚMERO DE EMPLEADOS` >= 10 & `NÚMERO DE EMPLEADOS` <= 49  ~ "Pequeña Empresa",
      `NÚMERO DE EMPLEADOS` >= 50 & `NÚMERO DE EMPLEADOS` <= 249 ~ "Mediana Empresa",
      `NÚMERO DE EMPLEADOS` >= 250                               ~ "Gran Empresa",
      TRUE ~ NA_character_  # Para datos ausentes o inválidos
    )
  )


# ---------------------------------------------
# Visualización de Resultados Intermedios
# ---------------------------------------------

# Puntos de corte usados para los intervalos de VENTAS
print(intervalos_ventas)

# Frecuencia de cada categoría de empresa
print(table(data_2$CATEGORIA_EMPLEADOS))


# ---------------------------------------------
# Tabla de Contingencia: Ventas x Categoría de Empresa
# ---------------------------------------------
# Crea una tabla cruzada para analizar la distribución de las empresas
# en función de sus niveles de ventas y su tamaño (empleados).

tabla_contingencia <- table(data_2$VENTAS_INTERVALO, data_2$CATEGORIA_EMPLEADOS)

# Tabla absoluta (conteo por grupo)
print(tabla_contingencia)

# Tabla relativa (porcentajes sobre el total)
tabla_prop <- round(prop.table(tabla_contingencia) * 100, 2)
print(tabla_prop)

# Visualizar tramos de ventas (barras apiladas por % dentro de cada tramo)
tabla_row_df <- as.data.frame(prop.table(tabla_contingencia, 1) * 100)
names(tabla_row_df) <- c("VENTAS", "Tamaño", "Porcentaje")

tabla_row_df$Tamaño <- factor(
  tabla_row_df$Tamaño,
  levels = c("Microempresa", "Pequeña Empresa", "Mediana Empresa", "Gran Empresa")
)

g_tamano_vs_ventas <- ggplot(tabla_row_df, aes(x = VENTAS, y = Porcentaje, fill = Tamaño)) +
  geom_col() +
  labs(
    title = "Distribución del tamaño de empresa según tramo de ventas",
    x = "Tramos de ventas", y = "% dentro de cada tramo", fill = "Tamaño"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 70, hjust = 1, size = 6))

# Impresión en la sesión
print(g_tamano_vs_ventas)

# Guardado a archivo
if (!dir.exists("figuras")) dir.create("figuras")
ggsave(
  filename = "figuras/distribucion_tamano_vs_ventas.png",
  plot     = g_tamano_vs_ventas,
  width    = 12, height = 8, dpi = 300
)


# ---------------------------------------------
# Test de Independencia - Chi-cuadrado
# ---------------------------------------------
# Verifica si existe dependencia estadística entre los intervalos
# de ventas y el tamaño de empresa.

test_chi2 <- chisq.test(tabla_contingencia)

# Resultado del test (valor p, estadístico, etc.)
print(test_chi2)

# Frecuencias esperadas bajo hipótesis de independencia
print(round(test_chi2$expected, 2))
