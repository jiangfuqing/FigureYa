#!/usr/bin/env Rscript
# Auto-generated R dependency installation script
# This script installs all required R packages for this project

# Set up mirrors for better download performance
options("repos" = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror = "http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# Function to check if a package is installed
is_package_installed <- function(package_name) {
  return(package_name %in% rownames(installed.packages()))
}

# Function to install CRAN packages
install_cran_package <- function(package_name) {
  if (!is_package_installed(package_name)) {
    cat("Installing CRAN package:", package_name, "\n")
    tryCatch({
      install.packages(package_name, dependencies = TRUE)
      cat("Successfully installed:", package_name, "\n")
    }, error = function(e) {
      cat("Failed to install", package_name, ":", e$message, "\n")
    })
  } else {
    cat("Package already installed:", package_name, "\n")
  }
}

# Function to install Bioconductor packages
install_bioc_package <- function(package_name) {
  if (!is_package_installed(package_name)) {
    cat("Installing Bioconductor package:", package_name, "\n")
    tryCatch({
      if (!is_package_installed("BiocManager")) {
        install.packages("BiocManager")
      }
      BiocManager::install(package_name, update = FALSE, ask = FALSE)
      cat("Successfully installed:", package_name, "\n")
    }, error = function(e) {
      cat("Failed to install", package_name, ":", e$message, "\n")
    })
  } else {
    cat("Package already installed:", package_name, "\n")
  }
}

cat("Starting R package installation...\n")
cat("===========================================\n")


# Installing CRAN packages
cat("\nInstalling CRAN packages...\n")
cran_packages <- c("pROC", "grey40", "repos", "BiocManager", "impute", "ClassDiscovery", "rho", "FDR", "ImmClust", "BSgenome.Hsapiens.UCSC.hg19", "tidyverse", "magrittr", "readxl", "stringr", "forcats", "deconstructSigs", "NMF", "Seurat", "dplyr", "ggVennDiagram", "export", "ggplot2", "openxlsx", "coin", "devtools", "ConsensusClusterPlus", "corrplot", "reshape2", "IFN.gamma.Response", "TCGA.Participant.Barcode", "TGF.beta.Response", "Macrophages", "Lymphocytes", "Wound.Healing", "cgdsr", "glmnet", "randomForest", "group", "AUC", "ggpubr", "plyr", "cowplot", "velocyto.R", "SDMTools", "survival", "randomForestSRC", "randomSurvivalForest", "ranger", "OS", "pec", "riskRegression", "SimDesign", "officer", "tdROC", "grey60", "new_group", "meta", "pvalue", "Groups", "givitiR", "foreign", "rms", "ResourceSelection", "response", "aplot", "ridge", "car", "RCircos", "rtracklayer", "PharmacoGx", "CoreGx", "shinyjs", "shinydashboard", "magicaxis", "lsa", "relations", "parallel", "tibble", "ggrepel", "ggthemes", "gridExtra", "tstat", "survminer", "ggpp", "Paired", "DealGPL570", "readr", "tidyr", "simple_barcode", "xgboost", "Matrix", "NR", "Boruta", "mlbench", "circlize", "ggsci", "spearman", "DDRTree", "GEOquery", "gene_biotype", "enrichplot", "hsa04110", "gtable", "grid", "panel", "ggtern", "scales", "ggstatsplot", "viridis", "iCluster_2.1.0.tar.gz", "CancerSubtypes", "forestplot", "black", "gganatogram", "TCGA", "GOSemSim", "ggtree", "ape", "statmod", "motifbreakR")

for (pkg in cran_packages) {
  install_cran_package(pkg)
}

# Installing Bioconductor packages
cat("\nInstalling Bioconductor packages...\n")
bioc_packages <- c("preprocessCore", "GO.db", "AnnotationDbi", "WGCNA", "gplots", "pheatmap", "BSgenome", "GenomeInfoDb", "ComplexHeatmap", "GSVA", "GSEABase", "limma", "pcaMethods", "monocle", "scmap", "DESeq2", "IHW", "TCGAbiolinks", "biomaRt", "sva", "clusterProfiler", "RColorBrewer", "Biobase")

for (pkg in bioc_packages) {
  install_bioc_package(pkg)
}

cat("\n===========================================\n")
cat("Package installation completed!\n")
cat("You can now run your R scripts in this directory.\n")

