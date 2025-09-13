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

# System dependency note for png/jpeg
cat("\nNOTE: ComplexHeatmap requires system libraries.\n")
cat("For Ubuntu/Debian, run this in shell BEFORE using this script:\n")
cat("  sudo apt-get update\n")
cat("  sudo apt-get install libpng-dev libjpeg-dev\n\n")

# Installing ComplexHeatmap dependencies first
cat("\nInstalling ComplexHeatmap dependencies...\n")
heatmap_deps <- c("png", "jpeg")

for (pkg in heatmap_deps) {
  install_cran_package(pkg)
}


# Installing CRAN packages
cat("\nInstalling CRAN packages...\n")
cran_packages <- c("BART", "RColorBrewer", "compareC", "devtools", "dplyr", "gbm", "ggbreak", "ggplot2", "ggsci", "glmnet", "miscTools", "plsRcox", "randomForestSRC", "rlang", "superpc", "survival", "survivalsvm", "tibble", "tidyr")

for (pkg in cran_packages) {
  install_cran_package(pkg)
}

# Installing Bioconductor packages
cat("\nInstalling Bioconductor packages...\n")
bioc_packages <- c("ComplexHeatmap", "circlize", "mixOmics", "survcomp")

for (pkg in bioc_packages) {
  install_bioc_package(pkg)
}

# Installing GitHub packages
cat("\nInstalling GitHub packages...\n")
if (!is_package_installed("CoxBoost")) {
  cat("Installing CoxBoost from GitHub...\n")
  tryCatch({
    if (!is_package_installed("devtools")) {
      install.packages("devtools")
    }
    devtools::install_github("binderh/CoxBoost")
    cat("Successfully installed CoxBoost from GitHub\n")
  }, error = function(e) {
    cat("Failed to install CoxBoost from GitHub:", e$message, "\n")
  })
} else {
  cat("Package already installed: CoxBoost\n")
}

cat("\n===========================================\n")
cat("Package installation completed!\n")
cat("You can now run your R scripts in this directory.\n")
