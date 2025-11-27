#Lista de dependencias
libs <- c("ggplot2", "patchwork", "pheatmap", "dplyr", "tidyr")

#Instalar las librerías que no estén instaladas
for (lib in libs) {
  if (!require(lib, character.only = TRUE)) {
    install.packages(lib, dependencies = TRUE)
  }
}

if (!requireNamespace("ComplexHeatmap", quietly = TRUE)) {
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  BiocManager::install("ComplexHeatmap")
}

#Librerías necesarias
library(ggplot2)
library(patchwork)
library(pheatmap)
library(ComplexHeatmap)
library(dplyr)
library(tidyr)

#Semilla para reproducibilidad
set.seed(1995)

#Cargar dataset
datos <- read.csv("MUBioinfo_dataset_genes_oct2025.csv")

################################################################################
#Primera parte
#lista de genes
genes <- c("AQ_esr1", "AQ_her2", "AQ_brca1", "AQ_brca2", "AQ_mki67",
           "AQ_gata3", "AQ_foxa1", "AQ_ccnd1", "AQ_cdh1", "AQ_tp53")

#Me he creado una lista para almacenar los plots
plots <- list()

for (g in genes){
  p <- ggplot(datos, aes(x = tratamiento, y = .data[[g]], fill = tratamiento)) +
    geom_boxplot() +
    labs(title = paste("Expresión de", g),
         subtitle = "Comparación por tipo de tratamiento",
         x = "Tratamiento",
         y = "expresión génica") +
    theme_minimal() +
    scale_fill_brewer(palette = "Set2")
  plots[[g]] <- p
}


#Combinar todos los plots en un solo gráfico
combined_plot <- wrap_plots(plots, ncol = 3) +
  plot_annotation(
    theme = theme(plot.title = element_text(size = 16, face = "bold"),
                  plot.subtitle = element_text(size = 12))
  )
combined_plot

################################################################################
#Segunda parte
bioquimicas <- c("glucosa","leucocitos","linfocitos","neutrofilos",
                 "chol","hdl","hierro","iga","ige","igg","ign",
                 "ldl","pcr","transferrina","trigliceridos","cpk")

plots_bio <- list()

for (v in bioquimicas){
  p <- ggplot(datos, aes(x = .data[[v]])) +
    geom_histogram(aes(y = ..density..), bins = 30, fill = "skyblue", color = "black") +
    geom_density(color = "red", size = 1) +
    labs(title = paste("Distribución de", v),
         x = v,
         y = "Densidad") +
    theme_minimal()
  plots_bio[[v]] <- p
}

#Combinar gráficos
combined_bio <- wrap_plots(plots_bio, ncol = 3)
combined_bio

################################################################################
#Tercera parte
genes_AQ <- grep("^AQ_", names(datos), value = TRUE)
datos_genes <- datos[, genes_AQ]

#Escalado
datos_scaled <- scale(datos_genes)

#Heatmap con pheatmap
pheatmap(datos_scaled,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = FALSE,
         show_colnames = TRUE,
         main = "Heatmap de expresión génica",
         color = colorRampPalette(c("navy", "white", "red"))(50))
