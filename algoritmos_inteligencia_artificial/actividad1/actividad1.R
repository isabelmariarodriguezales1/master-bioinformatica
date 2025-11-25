if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("RDRToolbox")

bioc_pkgs <- c(
  "DESeq2",   # normalización VST / RNA-seq
  "edgeR",    # filtrado CPM, TMM
  "limma",    # voom / corrección batch
  "sva",      # ComBat batch correction
  "BiocGenerics"  # dependencias básicas
)

for (pkg in bioc_pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    BiocManager::install(pkg)
  }
}

library(RDRToolbox)
library(ggplot2)
library(Rtsne)
library(uwot)
library(fastICA)
library(DESeq2)
library(edgeR)
library(limma)
library(sva)
library(cluster)
library(patchwork)
library(matrixStats)

data.raw <- read.csv('datos_500.csv')
labels.raw<- read.csv('labels.csv')

data <- round(sapply(data.raw[2:501], as.numeric))
labels <- labels.raw[,2]

stopifnot(nrow(data) == length(labels))

# Filtrar genes que nunca se expresan
keep_genes <- colSums(data) > 0
data_f <- data[, keep_genes]

# Filtrar muestras con todos los genes en cero
keep_samples <- rowSums(data_f) > 0
data_f <- data_f[keep_samples, ]
labels <- labels[keep_samples]

#NORMALIZACION
# edgeR espera: filas = genes, columnas = muestras
dge <- DGEList(counts = t(data_f))

# Normalización TMM para corregir diferencias de library size
dge <- calcNormFactors(dge)

# VST (Variance Stabilizing Transformation) con DESeq2
dds <- DESeqDataSetFromMatrix(
  countData = t(data_f),            
  colData   = data.frame(condition = labels),
  design    = ~1
)

vst_mat <- varianceStabilizingTransformation(dds, blind = TRUE)

# Extraer la matriz transformada
expr <- assay(vst_mat)

#Escalar genes
expr <- t(scale(t(expr)))

#Primera tecnica: PCA
pca_res <- prcomp(t(expr), center = TRUE, scale. = FALSE)
pct_var <- (pca_res$sdev^2)/sum(pca_res$sdev^2)
pca_df <- data.frame(PC1 = pca_res$x[,1], 
                     PC2 = pca_res$x[,2], 
                     condition = labels)

ggplot(pca_df, aes(PC1, PC2, color = condition)) +
  geom_point(size = 3) +
  labs(title = sprintf("PCA (PC1 %.1f%%, PC2 %.1f%%)", 100*pct_var[1], 100*pct_var[2])) +
  theme_minimal()


#Segunda tecnica: t-SNE
set.seed(42)
perp <- min(30, floor(ncol(expr)/5))
tsne_res <- Rtsne(t(expr), dims = 2, perplexity = perp, pca = TRUE, verbose = TRUE, max_iter = 1000)
tsne_df <- data.frame(D1 = tsne_res$Y[,1], 
                      D2 = tsne_res$Y[,2], 
                      condition = labels)

ggplot(tsne_df, aes(D1, D2, color = condition)) +
  geom_point(size = 3) +
  labs(title = sprintf("t-SNE (perplexity=%d)", perp)) +
  theme_minimal()


#tercera tecnica: UMAP
umap_res <- umap(t(expr), n_neighbors = 15, min_dist = 0.1, n_components = 2, verbose = TRUE)
umap_df <- data.frame(U1 = umap_res[,1], 
                      U2 = umap_res[,2], 
                      condition = labels)

ggplot(umap_df, aes(U1, U2, color = condition)) +
  geom_point(size = 3) +
  labs(title = "UMAP (n_neighbors=15, min_dist=0.1)") +
  theme_minimal()


#cuarta tecnica: ICA
ica_res <- fastICA(t(expr), n.comp = 10, alg.typ = "parallel", fun = "logcosh", maxit = 200)
ica_df <- data.frame(IC1 = ica_res$S[,1], 
                     IC2 = ica_res$S[,2], 
                     condition = labels)

ggplot(ica_df, aes(IC1, IC2, color = condition)) +
  geom_point(size = 3) +
  labs(title = "ICA (n.comp=10)") +
  theme_minimal()
