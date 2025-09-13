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


# Installing CRAN packages
cat("\nInstalling CRAN packages...\n")
cran_packages <- c("B.cells.memory", "B.cells.naive", "Dendritic.cells.activated", "Dendritic.cells.resting", "Eosinophils", "Fibroblasts", "Macrophages.M0", "Macrophages.M1", "Macrophages.M2", "Mast.cells.activated", "Mast.cells.resting", "Monocytes", "NK.cells.activated", "NK.cells.resting", "Neutrophils", "Plasma.cells", "R.utils", "T.cells.CD4.memory.activated", "T.cells.CD4.memory.resting", "T.cells.CD4.naive", "T.cells.CD8", "T.cells.follicular.helper", "T.cells.gamma.delta", "T.cells.regulatory..Tregs.", "cg12069309", "cg20425130", "cg20792833", "cg21554552", "cg23642747", "data.table", "estimate", "gplots", "utils", "viridis")

for (pkg in cran_packages) {
  install_cran_package(pkg)
}

# Installing Bioconductor packages
cat("\nInstalling Bioconductor packages...\n")
bioc_packages <- c("Biobase", "circlize", "ComplexHeatmap", "GSVA")

for (pkg in bioc_packages) {
  install_bioc_package(pkg)
}

cat("\n===========================================\n")
cat("Package installation completed!\n")
cat("You can now run your R scripts in this directory.\n")
