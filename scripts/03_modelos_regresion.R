# ------------------------------------------------------------------
# Script 03: Modelos de Regresión Lineal para Explicación de Ventas
# ------------------------------------------------------------------
# Este script desarrolla dos modelos de regresión lineal:
#   - Modelo simple: VENTAS ~ NÚMERO DE EMPLEADOS
#   - Modelo múltiple: VENTAS ~ NÚMERO DE EMPLEADOS + otras variables relevantes
#
# Además, se evalúan los supuestos clásicos de la regresión lineal:
#   1. Linealidad
#   2. Normalidad de los errores
#   3. Homocedasticidad
#   4. Independencia de los errores
#
# Requiere que el dataset 'data_2' esté previamente preparado y que
# las librerías necesarias estén importadas desde el script principal.
# ------------------------------------------------------------------


# ---------------------------------------------
# Modelo 1: Regresión Lineal Simple
# ---------------------------------------------
# Se utiliza como predictor el NÚMERO DE EMPLEADOS,
# dado que fue la variable más correlacionada con VENTAS.

modelo_simple <- lm(VENTAS ~ `NÚMERO DE EMPLEADOS`, data = data_2)
summary(modelo_simple)  # Muestra coeficientes, R², p-valores, etc.


# ---------------------------------------------
# Modelo 2: Regresión Lineal Múltiple
# ---------------------------------------------
# Se incorporan variables adicionales con alta correlación con VENTAS.
# PRODUCTIVIDAD se excluye por tener baja correlación.

modelo_multiple <- lm(VENTAS ~ `NÚMERO DE EMPLEADOS` + coe + edad + numest + fju, data = data_2)
summary(modelo_multiple)  # Resumen estadístico del modelo extendido


# ---------------------------------------------
# Diagnóstico de Multicolinealidad
# ---------------------------------------------
# Se evalúa si las variables independientes están correlacionadas entre sí.
# VIF > 5 sugiere colinealidad preocupante.

vif(modelo_multiple)


# ---------------------------------------------
# Preparación de Datos para Análisis de Supuestos
# ---------------------------------------------

# Crear un data frame con información del modelo ajustado
diagnostico_df <- augment(modelo_multiple)

# Asegurar que los residuos estandarizados están disponibles
diagnostico_df$.std.resid <- rstandard(modelo_multiple)


# ---------------------------------------------
# Evaluación de Supuestos del Modelo
# ---------------------------------------------

# Supuesto 1: Linealidad
graf_linealidad <- ggplot(
  data.frame(.fitted = fitted(modelo_multiple), .resid = resid(modelo_multiple)), 
  aes(x = .fitted, y = .resid)
) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_smooth(method = "loess", se = FALSE, color = "red", linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(
    title = "Supuesto 1: Linealidad",
    x = "Valores ajustados",
    y = "Residuales"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5))


# Supuesto 2: Normalidad de los errores
graf_normalidad <- ggplot(
  data.frame(residuales = resid(modelo_multiple)), 
  aes(sample = residuales)
) +
  stat_qq(color = "steelblue") +
  stat_qq_line(color = "red", linewidth = 1) +
  labs(
    title = "Supuesto 2: Normalidad de los errores",
    x = "Cuantiles teóricos",
    y = "Cuantiles muestrales"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5))


# Supuesto 3: Homocedasticidad
graf_homocedasticidad <- ggplot(
  data.frame(.fitted = fitted(modelo_multiple), .resid = resid(modelo_multiple)), 
  aes(x = .fitted, y = abs(.resid))
) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_smooth(method = "loess", se = FALSE, color = "red", linewidth = 1) +
  labs(
    title = "Supuesto 3: Homocedasticidad",
    x = "Valores ajustados",
    y = "|Residuales|"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5))


# Supuesto 4: Independencia de los errores
graf_independencia <- ggplot(
  data.frame(index = 1:length(resid(modelo_multiple)), residuales = resid(modelo_multiple)), 
  aes(x = index, y = residuales)
) +
  geom_line(color = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40") +
  labs(
    title = "Supuesto 4: Independencia de los errores",
    x = "Índice de observación",
    y = "Residuales"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5))


# ---------------------------------------------
# Visualización conjunta de los supuestos
# ---------------------------------------------

# Muestra los cuatro gráficos en una cuadrícula 2x2
(graf_linealidad | graf_normalidad) / (graf_homocedasticidad | graf_independencia)

# Aseguro carpeta
if (!dir.exists("figuras")) dir.create("figuras")

# Combino los 4 gráficos en un layout 2x2 con patchwork
g_supuestos <- (graf_linealidad | graf_normalidad) / (graf_homocedasticidad | graf_independencia)

# 1) Lo imprimo en la sesión
print(g_supuestos)

# 2) Lo guardo como PNG
ggsave(
  filename = "figuras/supuestos_regresion.png",
  plot     = g_supuestos,
  width    = 12, height = 10, dpi = 300
)
