# Carga de librerías
library(ggplot2)
library(dplyr)
library(car)
library(corrplot)
library(moments)
library(broom)
library(lawstat)
library(readxl)
library(psych)
library(tidyverse)
library(patchwork)
library(kableExtra)

# Cargar datos
data <- read_excel("datos.xlsx")

# Ejecutar scripts por secciones
source("01_descriptiva_general.R")
source("02_intervalos_y_tablas.R")
source("03_modelos_regresion.R")
source("04_inferencia_madrid_vs_barcelona.R")

