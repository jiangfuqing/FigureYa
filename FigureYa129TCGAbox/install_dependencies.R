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

# Installing core CRAN dependencies first
cat("\nInstalling core CRAN dependencies...\n")
core_packages <- c("curl", "httr", "gargle", "googledrive", "googlesheets4", "ragg", "rvest")

for (pkg in core_packages) {
  install_cran_package(pkg)
}

# ---- 补充部分开始 ----

# 先安装 DealGPL570 的特定历史版本（通过URL）
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

# 安装系统依赖提醒（仅显示，实际需手工操作）
cat("\nNOTE: If you encounter errors for packages like 'systemfonts' or 'curl',\n")
cat("please ensure you have installed the necessary system libraries.\n")
cat("For Ubuntu/Debian, run this in shell BEFORE using this script:\n")
cat("  sudo apt-get update\n")
cat("  sudo apt-get install libfontconfig1-dev libcurl4-openssl-dev libxml2-dev libssl-dev\n\n")

# ---- 补充部分结束 ----

# Installing CRAN packages
cat("\nInstalling CRAN packages...\n")
cran_packages <- c("data.table", "ggplot2", "ggpubr", "ggsignif", "gtools", "tidyverse")

for (pkg in cran_packages) {
  install_cran_package(pkg)
}

cat("\n===========================================\n")
cat("Package installation completed!\n")
cat("You can now run your R scripts in this directory.\n")
