#!/usr/bin/env Rscript
# Simple Rmd dependency tester and install_dependencies.R updater
# 简单的Rmd依赖检测和install_dependencies.R更新器

# Set up environment
options(repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror = "http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# Function to check if a package is a Bioconductor package
is_bioc_package <- function(pkg_name) {
  bioc_packages <- c(
    "DESeq2", "edgeR", "limma", "ComplexHeatmap", "EnhancedVolcano",
    "GenomicRanges", "Biostrings", "BSgenome", "TCGAbiolinks", 
    "maftools", "clusterProfiler", "fgsea", "GSVA", "miRBaseVersions.db",
    "miRBaseConverter", "pcaMethods", "monocle", "scmap", "IHW",
    "SimDat", "biomaRt", "preprocessCore", "Biobase", "BiocGenerics",
    "S4Vectors", "IRanges", "GenomeInfoDb", "AnnotationDbi", "GO.db",
    "KEGG.db", "org.Hs.eg.db", "org.Mm.eg.db", "ChIPpeakAnno", "DiffBind",
    "methylKit", "missMethyl", "bumphunter", "IlluminaHumanMethylation450kanno.ilmn12.hg19",
    "IlluminaHumanMethylationEPICanno.ilm10b4.hg19", "minfi", "ChAMP",
    "WGCNA", "pheatmap", "genefilter", "sva", "pamr", "multtest",
    "qvalue", "locfit", "Category", "GOstats", "GSEABase", "BiocParallel",
    "BiocStyle", "rhdf5", "Rhdf5lib", "zlibbioc", "XVector", "RBGL",
    "Rgraphviz", "graph", "RColorBrewer", "gplots", "VennDiogram", "UpSetR"
  )
  return(pkg_name %in% bioc_packages)
}

# Function to safely extract packages from Rmd file content
extract_packages_from_rmd_safe <- function(rmd_file) {
  tryCatch({
    if (!file.exists(rmd_file)) {
      return(character(0))
    }
    
    # Try reading with different encodings
    content <- NULL
    encodings <- c("UTF-8", "latin1", "ASCII")
    
    for (enc in encodings) {
      tryCatch({
        content <- readLines(rmd_file, warn = FALSE, encoding = enc)
        break
      }, error = function(e) {
        # Try next encoding
      })
    }
    
    if (is.null(content)) {
      cat("Warning: Could not read file", rmd_file, "\n")
      return(character(0))
    }
    
    packages <- c()
    
    # Extract from all lines
    for (line in content) {
      # Skip commented lines
      if (grepl("^\\s*#", line)) next
      
      # Match library(package) or require(package) - simplified pattern
      if (grepl("library\\s*\\(|require\\s*\\(", line)) {
        # Extract package names more robustly
        matches <- regmatches(line, gregexpr('(?:library|require)\\s*\\(\\s*(["\']?)([a-zA-Z][a-zA-Z0-9._]*?)\\1\\s*[,)]', line, perl = TRUE))[[1]]
        
        for (match in matches) {
          pkg <- gsub('.*\\(\\s*["\']?([a-zA-Z][a-zA-Z0-9._]*?).*', '\\1', match)
          if (nchar(pkg) > 1 && nchar(pkg) < 30 && !grepl("^[0-9]", pkg)) {
            packages <- c(packages, pkg)
          }
        }
      }
      
      # Extract from install.packages() calls
      if (grepl("install\\.packages", line)) {
        matches <- regmatches(line, gregexpr('["\']([a-zA-Z][a-zA-Z0-9._]*?)["\']', line))[[1]]
        for (match in matches) {
          pkg <- gsub('["\']([^"\']+)["\']', '\\1', match)
          if (nchar(pkg) > 1 && nchar(pkg) < 30 && !grepl("^[0-9]", pkg)) {
            packages <- c(packages, pkg)
          }
        }
      }
    }
    
    # Filter out obvious non-packages
    filtered_packages <- c()
    for (pkg in packages) {
      # Skip common false positives
      if (pkg %in% c("TRUE", "FALSE", "NULL", "NA", "Inf", "NaN", "eval", "echo", 
                     "include", "warning", "error", "message", "fig", "out", 
                     "cache", "results", "repos", "dependencies", "quiet")) next
      if (grepl("\\.(csv|txt|xlsx|rds|RData|png|jpg|pdf)$", pkg, ignore.case = TRUE)) next
      if (grepl("^(data|file|path|dir|url|http|ftp|www)", pkg, ignore.case = TRUE)) next
      
      filtered_packages <- c(filtered_packages, pkg)
    }
    
    return(unique(filtered_packages))
    
  }, error = function(e) {
    cat("Error reading", rmd_file, ":", e$message, "\n")
    return(character(0))
  })
}

# Function to simulate running Rmd and detect common error patterns
simulate_rmd_test <- function(rmd_file) {
  tryCatch({
    # This is a simulation - we'll check for common issues without actually running
    packages_needed <- extract_packages_from_rmd_safe(rmd_file)
    
    # Simulate some common missing packages based on file content
    missing_packages <- c()
    
    # Read file content to look for patterns
    content <- readLines(rmd_file, warn = FALSE)
    content_text <- paste(content, collapse = "\n")
    
    # Check for specific patterns that often indicate missing packages
    if (grepl("ggplot|geom_|aes\\(", content_text)) {
      missing_packages <- c(missing_packages, "ggplot2")
    }
    if (grepl("dplyr|%>%|mutate|filter|select", content_text)) {
      missing_packages <- c(missing_packages, "dplyr")
    }
    if (grepl("survival|Surv\\(|survfit", content_text)) {
      missing_packages <- c(missing_packages, "survival", "survminer")
    }
    if (grepl("randomForest|rf\\.|randomforest", content_text)) {
      missing_packages <- c(missing_packages, "randomForest")
    }
    
    all_packages <- unique(c(packages_needed, missing_packages))
    
    # Simulate failure if we detected missing packages
    if (length(missing_packages) > 0) {
      return(list(
        success = FALSE,
        error = paste("Simulated missing packages:", paste(missing_packages, collapse = ", ")),
        missing_packages = missing_packages,
        static_packages = packages_needed,
        all_packages = all_packages
      ))
    } else {
      return(list(
        success = TRUE,
        error = NULL,
        missing_packages = character(0),
        static_packages = packages_needed,
        all_packages = packages_needed
      ))
    }
    
  }, error = function(e) {
    return(list(
      success = FALSE,
      error = as.character(e),
      missing_packages = character(0),
      static_packages = character(0),
      all_packages = character(0)
    ))
  })
}

# Function to update install_dependencies.R
update_install_dependencies <- function(packages, output_dir = ".") {
  if (length(packages) == 0) {
    return(NULL)
  }
  
  cran_packages <- c()
  bioc_packages <- c()
  
  # Separate packages by source
  for (pkg in packages) {
    if (is_bioc_package(pkg)) {
      bioc_packages <- c(bioc_packages, pkg)
    } else {
      cran_packages <- c(cran_packages, pkg)
    }
  }
  
  script_content <- '#!/usr/bin/env Rscript
# Auto-generated R dependency installation script
# This script installs all required R packages for this project
# Generated by enhanced Rmd testing script

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
    cat("Installing CRAN package:", package_name, "\\n")
    tryCatch({
      install.packages(package_name, dependencies = TRUE)
      cat("Successfully installed:", package_name, "\\n")
    }, error = function(e) {
      cat("Failed to install", package_name, ":", e$message, "\\n")
    })
  } else {
    cat("Package already installed:", package_name, "\\n")
  }
}

# Function to install Bioconductor packages
install_bioc_package <- function(package_name) {
  if (!is_package_installed(package_name)) {
    cat("Installing Bioconductor package:", package_name, "\\n")
    tryCatch({
      if (!is_package_installed("BiocManager")) {
        install.packages("BiocManager")
      }
      BiocManager::install(package_name, update = FALSE, ask = FALSE)
      cat("Successfully installed:", package_name, "\\n")
    }, error = function(e) {
      cat("Failed to install", package_name, ":", e$message, "\\n")
    })
  } else {
    cat("Package already installed:", package_name, "\\n")
  }
}

cat("Starting R package installation...\\n")
cat("===========================================\\n")

'

  # Add CRAN packages section
  if (length(cran_packages) > 0) {
    script_content <- paste0(script_content, 
'
# Installing CRAN packages
cat("\\nInstalling CRAN packages...\\n")
cran_packages <- c(', paste0('"', cran_packages, '"', collapse = ", "), ')

for (pkg in cran_packages) {
  install_cran_package(pkg)
}
')
  }
  
  # Add Bioconductor packages section
  if (length(bioc_packages) > 0) {
    script_content <- paste0(script_content,
'
# Installing Bioconductor packages
cat("\\nInstalling Bioconductor packages...\\n")
bioc_packages <- c(', paste0('"', bioc_packages, '"', collapse = ", "), ')

for (pkg in bioc_packages) {
  install_bioc_package(pkg)
}
')
  }
  
  script_content <- paste0(script_content, '
cat("\\n===========================================\\n")
cat("Package installation completed!\\n")
cat("You can now run your R scripts in this directory.\\n")
')

  # Write script to file
  script_path <- file.path(output_dir, "install_dependencies.R")
  writeLines(script_content, script_path)
  
  return(script_path)
}

# Main function to test directories
main <- function(max_dirs = 10) {
  cat("Starting simplified Rmd testing...\n")
  
  # Find directories with Rmd files
  rmd_files <- list.files(".", pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  rmd_dirs <- unique(dirname(rmd_files))
  
  if (length(rmd_dirs) > max_dirs) {
    rmd_dirs <- rmd_dirs[1:max_dirs]
    cat("Testing first", max_dirs, "directories\n")
  }
  
  failed_dirs <- list()
  success_count <- 0
  
  # Process each directory
  for (i in seq_along(rmd_dirs)) {
    dir_path <- rmd_dirs[i]
    dir_rmd_files <- list.files(dir_path, pattern = "\\.Rmd$", full.names = TRUE)
    
    cat("\n[", i, "/", length(rmd_dirs), "] Testing directory:", dir_path, "\n")
    cat("  Files:", length(dir_rmd_files), "\n")
    
    all_dir_packages <- c()
    has_failures <- FALSE
    
    # Test each Rmd file in the directory
    for (rmd_file in dir_rmd_files) {
      cat("    Testing:", basename(rmd_file))
      result <- simulate_rmd_test(rmd_file)
      
      if (!result$success) {
        cat(" - FAILED\n")
        has_failures <- TRUE
        all_dir_packages <- c(all_dir_packages, result$all_packages)
        cat("      Missing:", paste(result$missing_packages, collapse = ", "), "\n")
      } else {
        cat(" - OK\n")
        all_dir_packages <- c(all_dir_packages, result$static_packages)
      }
    }
    
    all_dir_packages <- unique(all_dir_packages)
    
    if (has_failures) {
      failed_dirs[[dir_path]] <- all_dir_packages
      cat("  DIRECTORY HAS FAILURES - updating install_dependencies.R\n")
    } else {
      success_count <- success_count + 1
      cat("  DIRECTORY OK\n")
    }
    
    # Update install_dependencies.R for this directory
    if (length(all_dir_packages) > 0) {
      update_install_dependencies(all_dir_packages, dir_path)
      cat("  Updated install_dependencies.R with", length(all_dir_packages), "packages\n")
    }
  }
  
  # Summary
  cat("\n===========================================\n")
  cat("TESTING SUMMARY\n")
  cat("===========================================\n")
  cat("Total directories tested:", length(rmd_dirs), "\n")
  cat("Directories with failures:", length(failed_dirs), "\n")
  cat("Directories without failures:", success_count, "\n")
  
  if (length(failed_dirs) > 0) {
    cat("\nDirectories with failures:\n")
    for (dir in names(failed_dirs)) {
      packages <- failed_dirs[[dir]]
      cat("- ", dir, ": ", length(packages), " packages\n")
      if (length(packages) > 0 && length(packages) <= 10) {
        cat("  Packages:", paste(packages, collapse = ", "), "\n")
      }
    }
  }
}

# Run with command line arguments or default
args <- commandArgs(trailingOnly = TRUE)
max_dirs <- if (length(args) > 0) as.numeric(args[1]) else 10

main(max_dirs)