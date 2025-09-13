#!/usr/bin/env Rscript
# Auto-generated R dependency installation script
# This script installs all required R packages for this project

# Set up mirrors for better download performance
options("repos" = c(CRAN = "https://cloud.r-project.org/"))
options(BioC_mirror = "https://bioconductor.org/")

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

# 安装 Seurat 相关依赖
seurat_deps <- c("httr", "plotly", "png", "reticulate", "mixtools")
cat("\nInstalling Seurat dependency packages...\n")
for (pkg in seurat_deps) {
  install_cran_package(pkg)
}

# 安装 DealGPL570 的特定历史版本（通过 CRAN Archive URL）
deal_pkg_url <- "https://cran.r-project.org/src/contrib/Archive/DealGPL570/DealGPL570_0.0.1.tar.gz"
deal_pkg_name <- "DealGPL570"
if (!is_package_installed(deal_pkg_name)) {
  cat("Installing archived DealGPL570 version 0.0.1 from CRAN Archive...\n")
  tryCatch({
    install.packages(deal_pkg_url, repos = NULL, type = "source")
    cat("Successfully installed DealGPL570_0.0.1\n")
  }, error = function(e) {
    cat("Failed to install DealGPL570_0.0.1:", e$message, "\n")
  })
} else {
  cat("Package already installed:", deal_pkg_name, "\n")
}

# 系统依赖提醒（如在 Linux 环境，需提前手动安装）
cat("\nNOTE: If you encounter errors for packages like 'systemfonts', 'curl', or 'xml2',\n")
cat("please ensure you have installed the necessary system libraries.\n")
cat("For Ubuntu/Debian, run this in shell BEFORE using this script:\n")
cat("  sudo apt-get update\n")
cat("  sudo apt-get install libfontconfig1-dev libcurl4-openssl-dev libxml2-dev libssl-dev\n\n")

# Installing CRAN packages
cat("\nInstalling CRAN packages...\n")
cran_packages <- c(
  "RColorBrewer", "Seurat",
  "dplyr", "ggplot2", "ggrepel", "magrittr", "patchwork", "reshape2"
)

for (pkg in cran_packages) {
  install_cran_package(pkg)
}

# 如有 Bioconductor 包需求可在此处补充
# bioc_packages <- c("Rhtslib", "maftools")
# for (pkg in bioc_packages) {
#   install_bioc_package(pkg)
# }

cat("\n===========================================\n")
cat("Package installation completed!\n")
cat("You can now run your R scripts in this directory.\n")
