# ------------------------------------------------------------------
# Script 04: Comparación de Ventas entre Madrid y Barcelona
# ------------------------------------------------------------------
# Este script compara las ventas (VENTAS) entre Madrid y Barcelona
# mediante tests estadísticos apropiados.
#
# Se analizan los supuestos de normalidad y homogeneidad de varianzas
# y, en caso de no cumplimiento, se aplican alternativas como:
#   - Transformación logarítmica
#   - Tests no paramétricos (Mann-Whitney, Brunner-Munzel)
#
# Requiere que el dataset 'data_2' esté previamente preparado y que
# las librerías necesarias estén importadas desde el script principal.
# ------------------------------------------------------------------


# ---------------------------------------------
# Filtrado del dataset
# ---------------------------------------------
data_mad_bar <- data_2 %>%
  filter(PROVINCIA %in% c("Madrid", "Barcelona"))


# ---------------------------------------------
# Estadísticos descriptivos
# ---------------------------------------------
data_mad_bar %>%
  group_by(PROVINCIA) %>%
  summarise(
    media_ventas = mean(VENTAS, na.rm = TRUE),
    sd_ventas = sd(VENTAS, na.rm = TRUE),
    n = n()
  )


# ---------------------------------------------
# Visualización de la distribución de ventas
# ---------------------------------------------
if (!dir.exists("figuras")) dir.create("figuras")

g_mad_bar <- ggplot(data_mad_bar, aes(x = PROVINCIA, y = VENTAS, fill = PROVINCIA)) +
  geom_boxplot(alpha = 0.6) +
  geom_jitter(width = 0.1, alpha = 0.3, color = "black") +
  labs(title = "Distribución de ventas en Madrid y Barcelona",
       y = "Ventas", x = "") +
  theme_minimal()

# 1) Mostrar en la sesión
print(g_mad_bar)

# 2) Guardar como PNG
ggsave(
  filename = "figuras/distribucion_madrid_barcelona.png",
  plot     = g_mad_bar,
  width    = 8, height = 6, dpi = 300
)


# ---------------------------------------------
# Evaluación de supuestos
# ---------------------------------------------

# Test de normalidad (Shapiro-Wilk)
shapiro_madrid <- shapiro.test(data_mad_bar$VENTAS[data_mad_bar$PROVINCIA == "Madrid"])
shapiro_barcelona <- shapiro.test(data_mad_bar$VENTAS[data_mad_bar$PROVINCIA == "Barcelona"])

print(shapiro_madrid)
print(shapiro_barcelona)

# Test de igualdad de varianzas (Levene)
leveneTest(VENTAS ~ PROVINCIA, data = data_mad_bar)


# ---------------------------------------------
# Interpretación inicial
# ---------------------------------------------
# Los resultados del test de Shapiro-Wilk indican que los datos
# NO siguen una distribución normal en al menos uno de los grupos.
# Por tanto, se prioriza el uso de tests no paramétricos y transformación.


# ---------------------------------------------
# Test no paramétrico: Mann-Whitney-Wilcoxon
# ---------------------------------------------
wilcox_test <- wilcox.test(VENTAS ~ PROVINCIA, data = data_mad_bar)
print(wilcox_test)


# -------------------------------------------------------------
# Transformación logarítmica y análisis sobre LOG_VENTAS
# -------------------------------------------------------------
data_mad_bar_log <- data_mad_bar %>%
  mutate(LOG_VENTAS = log1p(VENTAS))  # log1p evita errores con ceros

# Evaluación de normalidad tras transformación
shapiro_madrid_log <- shapiro.test(data_mad_bar_log$LOG_VENTAS[data_mad_bar_log$PROVINCIA == "Madrid"])
shapiro_barcelona_log <- shapiro.test(data_mad_bar_log$LOG_VENTAS[data_mad_bar_log$PROVINCIA == "Barcelona"])

print(shapiro_madrid_log)
print(shapiro_barcelona_log)

# t-test de Welch (permite varianzas desiguales)
t_test_log <- t.test(LOG_VENTAS ~ PROVINCIA, data = data_mad_bar_log)
print(t_test_log)

# Test de Levene sobre datos transformados
leveneTest(LOG_VENTAS ~ PROVINCIA, data = data_mad_bar_log)


# -------------------------------------------------------------
# Test robusto: Brunner-Munzel
# -------------------------------------------------------------
data_mad_bar$PROVINCIA <- as.factor(data_mad_bar$PROVINCIA)

ventas_madrid <- data_mad_bar$VENTAS[data_mad_bar$PROVINCIA == "Madrid"]
ventas_barcelona <- data_mad_bar$VENTAS[data_mad_bar$PROVINCIA == "Barcelona"]

bm_test <- brunner.munzel.test(ventas_barcelona, ventas_madrid)
print(bm_test)
