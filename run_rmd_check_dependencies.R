#!/usr/bin/env Rscript
# Script to run all Rmd files, identify failures, and generate install_dependencies.R
# 运行所有rmd文件，运行失败的rmd文件根据报错信息生成install_dependencies.R

# Set up environment
options(repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror = "http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# Function to check if a package is available on CRAN
is_cran_package <- function(pkg_name) {
  cran_packages <- c("ggplot2", "dplyr", "tidyr", "readr", "stringr", "lubridate", 
                     "survival", "survminer", "randomForest", "e1071", "caret",
                     "ranger", "randomForestSRC", "BlandAltmanLeh", "MethComp", 
                     "smatr", "mclust", "pROC", "knitr", "rmarkdown", "devtools",
                     "remotes", "BiocManager", "DealGPL570", "jsonlite", "tidyjson")
  return(pkg_name %in% cran_packages || TRUE) # Default to CRAN unless known Bioc
}

# Function to check if a package is a Bioconductor package
is_bioc_package <- function(pkg_name) {
  bioc_packages <- c("DESeq2", "edgeR", "limma", "ComplexHeatmap", "EnhancedVolcano",
                     "GenomicRanges", "Biostrings", "BSgenome", "TCGAbiolinks", 
                     "maftools", "clusterProfiler", "fgsea", "GSVA", "miRBaseVersions.db",
                     "miRBaseConverter", "pcaMethods", "monocle", "scmap", "IHW",
                     "SimDat", "biomaRt", "preprocessCore")
  return(pkg_name %in% bioc_packages)
}

# Function to extract packages from Rmd file content
extract_packages_from_rmd <- function(rmd_file) {
  tryCatch({
    content <- readLines(rmd_file, warn = FALSE)
    
    # Find R code blocks
    r_blocks <- c()
    in_r_block <- FALSE
    current_block <- c()
    
    for (line in content) {
      if (grepl("^```\\{r", line)) {
        in_r_block <- TRUE
        current_block <- c()
      } else if (grepl("^```$", line) && in_r_block) {
        in_r_block <- FALSE
        if (length(current_block) > 0) {
          r_blocks <- c(r_blocks, current_block)
        }
      } else if (in_r_block) {
        current_block <- c(current_block, line)
      }
    }
    
    # Extract package names from library() and require() calls
    packages <- c()
    for (line in r_blocks) {
      # Match library(package) or require(package)
      lib_matches <- regmatches(line, gregexpr('(?:library|require)\\s*\\(\\s*(["\']?)([^),"\'\\s]+)\\1\\s*\\)', line, perl = TRUE))
      for (match in lib_matches[[1]]) {
        if (length(match) > 0 && match != "") {
          pkg <- gsub('.*\\(\\s*["\']?([^),"\'\\s]+)["\']?.*', '\\1', match)
          if (pkg != "" && !grepl("^[0-9]", pkg)) {
            packages <- c(packages, pkg)
          }
        }
      }
      
      # Also look for install.packages() calls
      install_matches <- regmatches(line, gregexpr('install\\.packages\\s*\\(\\s*["\']([^"\']+)["\']', line, perl = TRUE))
      for (match in install_matches[[1]]) {
        if (length(match) > 0 && match != "") {
          pkg <- gsub('.*["\']([^"\']+)["\'].*', '\\1', match)
          if (pkg != "" && !grepl("^[0-9]", pkg)) {
            packages <- c(packages, pkg)
          }
        }
      }
    }
    
    return(unique(packages))
  }, error = function(e) {
    cat("Error reading", rmd_file, ":", e$message, "\n")
    return(character(0))
  })
}

# Function to run Rmd file and capture errors
run_rmd_file <- function(rmd_file) {
  tryCatch({
    # Change to the directory of the Rmd file
    original_dir <- getwd()
    rmd_dir <- dirname(rmd_file)
    rmd_filename <- basename(rmd_file)
    
    setwd(rmd_dir)
    
    # Try to render the Rmd file
    output <- capture.output({
      result <- tryCatch({
        rmarkdown::render(rmd_filename, quiet = TRUE)
        return(list(success = TRUE, error = NULL))
      }, error = function(e) {
        return(list(success = FALSE, error = as.character(e)))
      })
    }, type = "message")
    
    setwd(original_dir)
    
    if (!result$success) {
      return(list(success = FALSE, error = result$error, output = paste(output, collapse = "\n")))
    } else {
      return(list(success = TRUE, error = NULL, output = NULL))
    }
    
  }, error = function(e) {
    return(list(success = FALSE, error = as.character(e), output = NULL))
  })
}

# Function to extract missing packages from error messages
extract_missing_packages_from_error <- function(error_msg) {
  packages <- c()
  
  # Common error patterns for missing packages
  patterns <- c(
    "there is no package called '([^']+)'",
    "package '([^']+)' not found",
    "could not find package \"([^\"]+)\"",
    "Error in library\\(([^)]+)\\)",
    "namespace '([^']+)' .* not available"
  )
  
  for (pattern in patterns) {
    matches <- regmatches(error_msg, gregexpr(pattern, error_msg, ignore.case = TRUE))
    for (match_group in matches) {
      for (match in match_group) {
        if (length(match) > 0) {
          pkg <- gsub(pattern, "\\1", match, ignore.case = TRUE)
          pkg <- gsub('["\']', '', pkg) # Remove quotes
          if (pkg != "" && !grepl("^[0-9]", pkg)) {
            packages <- c(packages, pkg)
          }
        }
      }
    }
  }
  
  return(unique(packages))
}

# Function to generate install_dependencies.R script
generate_install_dependencies <- function(packages, output_dir = ".") {
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
  
  # Make script executable
  Sys.chmod(script_path, mode = "0755")
  
  cat("Generated install_dependencies.R with", length(packages), "packages\\n")
  cat("CRAN packages:", length(cran_packages), "\\n")
  cat("Bioconductor packages:", length(bioc_packages), "\\n")
  
  return(script_path)
}

# Main function
main <- function() {
  cat("Starting Rmd dependency check...\\n")
  
  # Find all Rmd files
  rmd_files <- list.files(".", pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  cat("Found", length(rmd_files), "Rmd files\\n")
  
  failed_files <- list()
  all_missing_packages <- c()
  
  # Process each Rmd file
  for (i in seq_along(rmd_files)) {
    rmd_file <- rmd_files[i]
    cat("\\n[", i, "/", length(rmd_files), "] Processing:", rmd_file, "\\n")
    
    # First, extract packages from the file content
    packages_from_content <- extract_packages_from_rmd(rmd_file)
    
    # Try to run the Rmd file
    result <- run_rmd_file(rmd_file)
    
    if (!result$success) {
      cat("FAILED:", rmd_file, "\\n")
      
      # Extract missing packages from error messages
      packages_from_error <- extract_missing_packages_from_error(result$error)
      
      # Combine packages from content and errors
      all_packages <- unique(c(packages_from_content, packages_from_error))
      
      failed_files[[rmd_file]] <- list(
        packages_from_content = packages_from_content,
        packages_from_error = packages_from_error,
        all_packages = all_packages,
        error = result$error
      )
      
      all_missing_packages <- c(all_missing_packages, all_packages)
      
      # Generate install_dependencies.R for this specific directory
      rmd_dir <- dirname(rmd_file)
      if (length(all_packages) > 0) {
        generate_install_dependencies(all_packages, rmd_dir)
      }
      
    } else {
      cat("SUCCESS:", rmd_file, "\\n")
    }
  }
  
  # Generate main install_dependencies.R in current directory
  if (length(all_missing_packages) > 0) {
    all_missing_packages <- unique(all_missing_packages)
    cat("\\nGenerating main install_dependencies.R...\\n")
    generate_install_dependencies(all_missing_packages, ".")
  }
  
  # Summary
  cat("\\n===========================================\\n")
  cat("SUMMARY\\n")
  cat("===========================================\\n")
  cat("Total Rmd files processed:", length(rmd_files), "\\n")
  cat("Failed files:", length(failed_files), "\\n")
  cat("Successful files:", length(rmd_files) - length(failed_files), "\\n")
  cat("Total unique missing packages:", length(unique(all_missing_packages)), "\\n")
  
  if (length(failed_files) > 0) {
    cat("\\nFailed files and their missing packages:\\n")
    for (file in names(failed_files)) {
      info <- failed_files[[file]]
      cat("- ", file, ": ", length(info$all_packages), " packages\\n")
      if (length(info$all_packages) > 0) {
        cat("  Packages:", paste(info$all_packages, collapse = ", "), "\\n")
      }
    }
  }
}

# Install required packages if not available
if (!require(rmarkdown, quietly = TRUE)) {
  install.packages("rmarkdown")
  library(rmarkdown)
}

if (!require(knitr, quietly = TRUE)) {
  install.packages("knitr")  
  library(knitr)
}

# Run main function
main()