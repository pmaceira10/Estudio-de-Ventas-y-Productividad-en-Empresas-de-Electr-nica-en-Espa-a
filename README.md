# Estudio de Ventas y Productividad en Empresas de Electrónica en España

## Descripción del proyecto
Este proyecto tiene como objetivo analizar el comportamiento de las **ventas de dispositivos móviles y electrónicos** de una franquicia que opera en diferentes provincias de España.  

A partir de los datos disponibles, se realiza un análisis estadístico completo que incluye:  
- Análisis descriptivo de variables clave (Ventas, Número de empleados y Productividad).  
- Construcción de una matriz de correlaciones para identificar relaciones lineales.  
- Clasificación de empresas en categorías de ventas y empleados, junto con análisis de dependencia.  
- Modelos de regresión lineal (simple y múltiple) para explicar las ventas en función de diferentes factores.  
- Análisis inferencial para comparar las ventas entre las provincias de **Madrid y Barcelona**.  

El proyecto sigue una metodología estructurada, apoyándose en técnicas estadísticas y visualización de datos con **R**.

---

## Objetivos
1. **Exploración descriptiva**: estudiar la distribución de las variables principales y detectar patrones.  
2. **Relaciones entre variables**: identificar correlaciones y dependencias relevantes.  
3. **Modelización**: construir modelos de regresión lineal que expliquen el comportamiento de las ventas.  
4. **Inferencia estadística**: evaluar si existen diferencias significativas en las ventas entre Madrid y Barcelona.  

---

## Flujo de trabajo
El análisis se estructura en cuatro bloques principales, cada uno implementado en un script de R independiente:

1. **01_descriptiva_general.R**  
   - Estadísticos descriptivos (media, mediana, desviación típica, asimetría, curtosis).  
   - Visualizaciones: histogramas, boxplots y gráficos de densidad.  
   - Matriz de correlaciones con interpretación.

2. **02_intervalos_y_tablas.R**  
   - Clasificación de ventas en intervalos homogéneos.  
   - Categorización de empresas según número de empleados (micro, pequeñas, medianas).  
   - Construcción de tabla de contingencia y test de independencia Chi-cuadrado.  
   - Gráfico de barras apiladas para representar la distribución conjunta.

3. **03_modelos_regresion.R**  
   - Ajuste de un modelo de regresión lineal simple (**Ventas ~ Número de empleados**).  
   - Ajuste de un modelo de regresión lineal múltiple con predictores adicionales (cuota de mercado, edad de la empresa, número de establecimientos, forma jurídica).  
   - Evaluación de supuestos clásicos de la regresión (linealidad, normalidad de residuos, homocedasticidad e independencia).  

4. **04_inferencia_madrid_vs_barcelona.R**  
   - Comparación de ventas entre Madrid y Barcelona.  
   - Verificación de supuestos de normalidad y homogeneidad de varianzas.  
   - Aplicación de tests estadísticos:  
     - Mann-Whitney-Wilcoxon.  
     - Transformación logarítmica y t-test de Welch.  
     - Test robusto de Brunner-Munzel.  

El informe final (`informe_final.Rmd`) integra los resultados de todos los scripts en un único documento reproducible.

---

## Estructura del repositorio

```bash
├── data/
│   ├── datos.xlsx                 # Datos principales del análisis
│   ├── variables.xlsx             # Diccionario de variables
├── figuras/                       # Carpeta de gráficos exportados
├── scripts/                       # Carpeta con todos los scripts
│   ├── 01_descriptiva_general.R       # Script 1: Análisis descriptivo
│   ├── 02_intervalos_y_tablas.R       # Script 2: Clasificación y tablas
│   ├── 03_modelos_regresion.R         # Script 3: Modelos de regresión
│   ├── 04_inferencia_madrid_vs_barcelona.R  # Script 4: Inferencia
│   └── main.R                         # Script principal que ejecuta todo
├── informe_final.Rmd              # Informe en formato R Markdown (editable)
├── informe_final.html             # Informe final renderizado (listo para ver)
└── README.md                      # Descripción del proyecto
```


---

## Herramientas utilizadas
- **Lenguaje**: R  
- **Librerías principales**:  
  - `ggplot2`, `patchwork` → visualización de datos  
  - `dplyr`, `tidyverse` → manipulación de datos  
  - `corrplot` → matriz de correlaciones  
  - `car`, `lawstat` → contrastes estadísticos  
  - `broom` → extracción ordenada de resultados de modelos  
  - `kableExtra` → tablas formateadas en el informe  
- **Entorno de desarrollo**: RStudio  

---

## Cómo ejecutar el proyecto
1. Clonar el repositorio:  
   ```bash



