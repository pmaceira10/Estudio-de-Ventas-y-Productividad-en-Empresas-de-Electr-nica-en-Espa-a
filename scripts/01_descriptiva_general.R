# ------------------------------------------------------------------
# Script 01: Análisis descriptivo y visual de variables numéricas
# ------------------------------------------------------------------
# Este script realiza un resumen estadístico y análisis gráfico
# para tres variables clave del dataset: VENTAS, NÚMERO DE EMPLEADOS
# y PRODUCTIVIDAD. Además, evalúa la correlación entre ellas.
# 
# Requiere que el dataset 'data' esté previamente cargado y que
# las librerías necesarias estén importadas desde el script principal.
# ------------------------------------------------------------------


# -------------------------
# Función descriptiva
# -------------------------
# Calcula medidas estadísticas para una variable numérica dada:
# - Media, mediana, desviación estándar, cuartiles, min/max
# - Asimetría y curtosis (usando 'describe' del paquete psych)

resumen_variable <- function(df, variable) {
  var_data <- df[[variable]]
  var_data <- var_data[!is.na(var_data)]  # Eliminar NA
  
  descr <- describe(var_data)  # ps: requiere librería 'psych'
  
  resumen <- tibble(
    variable = variable,
    media = descr$mean,
    sd = descr$sd,
    min = min(var_data),
    Q1 = quantile(var_data, 0.25),
    mediana = descr$median,
    Q3 = quantile(var_data, 0.75),
    max = max(var_data),
    asimetria = descr$skew,
    curtosis = descr$kurtosis
  )
  
  return(resumen)
}


# -----------------------------------
# Estadísticos descriptivos por var
# -----------------------------------

estadisticos_ventas <- resumen_variable(data, "VENTAS")
estadisticos_empleados <- resumen_variable(data, "NÚMERO DE EMPLEADOS")
estadisticos_productividad <- resumen_variable(data, "PRODUCTIVIDAD")

print(estadisticos_ventas)
print(estadisticos_empleados)
print(estadisticos_productividad)


# =============================================================
# Gráficos descriptivos dobles (Histograma + Boxplot)
# =============================================================

# Crear carpeta para guardar si no existe
if (!dir.exists("figuras")) dir.create("figuras")

# --- Ventas ---
g_hist_ventas <- ggplot(data, aes(x = VENTAS)) +
  geom_histogram(aes(y = ..density..), bins = 30,
                 fill = "#0072B2", alpha = 0.6, color = "white") +
  geom_density(color = "#D55E00", size = 1.2) +
  labs(title = "Distribución de Ventas", x = "Ventas", y = "Densidad") +
  theme_minimal()

g_box_ventas <- ggplot(data, aes(y = VENTAS)) +
  geom_boxplot(fill = "#009E73", alpha = 0.7, outlier.color = "red") +
  labs(title = "Boxplot de Ventas", y = "Ventas") +
  theme_minimal()

g_ventas <- g_hist_ventas + g_box_ventas
ggsave("figuras/ventas_panel.png", g_ventas, width = 14, height = 5, dpi = 300)
print(g_ventas)


# --- Número de empleados ---
g_hist_emp <- ggplot(data, aes(x = `NÚMERO DE EMPLEADOS`)) +
  geom_histogram(aes(y = ..density..), bins = 30,
                 fill = "#0072B2", alpha = 0.6, color = "white") +
  geom_density(color = "#D55E00", size = 1.2) +
  labs(title = "Distribución de Número de Empleados", x = "Número de empleados", y = "Densidad") +
  theme_minimal()

g_box_emp <- ggplot(data, aes(y = `NÚMERO DE EMPLEADOS`)) +
  geom_boxplot(fill = "#009E73", alpha = 0.7, outlier.color = "red") +
  labs(title = "Boxplot de Número de Empleados", y = "Número de empleados") +
  theme_minimal()

g_emp <- g_hist_emp + g_box_emp
ggsave("figuras/empleados_panel.png", g_emp, width = 14, height = 5, dpi = 300)
print(g_emp)


# --- Productividad ---
g_hist_prod <- ggplot(data, aes(x = PRODUCTIVIDAD)) +
  geom_histogram(aes(y = ..density..), bins = 30,
                 fill = "#0072B2", alpha = 0.6, color = "white") +
  geom_density(color = "#D55E00", size = 1.2) +
  labs(title = "Distribución de Productividad", x = "Productividad", y = "Densidad") +
  theme_minimal()

g_box_prod <- ggplot(data, aes(y = PRODUCTIVIDAD)) +
  geom_boxplot(fill = "#009E73", alpha = 0.7, outlier.color = "red") +
  labs(title = "Boxplot de Productividad", y = "Productividad") +
  theme_minimal()

g_prod <- g_hist_prod + g_box_prod
ggsave("figuras/productividad_panel.png", g_prod, width = 14, height = 5, dpi = 300)
print(g_prod)


# -------------------------
# Matriz de correlaciones
# -------------------------
# Calcula la correlación de Pearson entre variables numéricas
# y la visualiza con 'corrplot'

datos_numericos <- data[sapply(data, is.numeric)]

matriz_correlacion <- cor(datos_numericos, use = "complete.obs")

print(round(matriz_correlacion, 2))  

# Crear carpeta para guardar si no existe
if (!dir.exists("figuras")) dir.create("figuras")

# Guardar gráfico como PNG
png("figuras/matriz_correlacion.png", width = 1000, height = 800)
corrplot(
  matriz_correlacion, 
  method = "color",
  type = "upper",
  order = "hclust",
  addCoef.col = "black",
  tl.cex = 0.6,
  number.cex = 0.55,
  cl.cex = 0.8
)
dev.off()

# Mostrar también en la salida de R
corrplot(
  matriz_correlacion, 
  method = "color",
  type = "upper",
  order = "hclust",
  addCoef.col = "black",
  tl.cex = 0.6,
  number.cex = 0.55,
  cl.cex = 0.8
)

