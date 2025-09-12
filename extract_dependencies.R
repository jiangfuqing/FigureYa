#!/usr/bin/env Rscript
# Simplified script to extract dependencies from Rmd files and generate install_dependencies.R
# 从Rmd文件中提取依赖包并生成install_dependencies.R

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
    "Rgraphviz", "graph", "Rcpp", "RCurl", "XML", "RJSONIO", "bitops",
    "RColorBrewer", "gplots", "VennDiagram", "UpSetR"
  )
  return(pkg_name %in% bioc_packages)
}

# Function to extract packages from Rmd file content
extract_packages_from_rmd <- function(rmd_file) {
  tryCatch({
    if (!file.exists(rmd_file)) {
      cat("File does not exist:", rmd_file, "\n")
      return(character(0))
    }
    
    content <- readLines(rmd_file, warn = FALSE)
    packages <- c()
    
    # Extract from all lines (not just R blocks for simplicity)
    for (line in content) {
      # Skip commented lines
      if (grepl("^\\s*#", line)) next
      
      # Match library(package) or require(package)
      lib_patterns <- c(
        'library\\s*\\(\\s*(["\']?)([^),"\'\\s]+)\\1\\s*\\)',
        'require\\s*\\(\\s*(["\']?)([^),"\'\\s]+)\\1\\s*\\)',
        'requireNamespace\\s*\\(\\s*(["\']?)([^),"\'\\s]+)\\1'
      )
      
      for (pattern in lib_patterns) {
        matches <- gregexpr(pattern, line, perl = TRUE)[[1]]
        if (matches[1] != -1) {
          match_text <- regmatches(line, matches)
          for (match in match_text) {
            pkg <- gsub(pattern, '\\2', match, perl = TRUE)
            pkg <- gsub('["\']', '', pkg)
            if (pkg != "" && !grepl("^[0-9]", pkg) && !grepl("[^a-zA-Z0-9._]", pkg)) {
              packages <- c(packages, pkg)
            }
          }
        }
      }
      
      # Extract from install.packages() calls
      install_patterns <- c(
        'install\\.packages\\s*\\(\\s*["\']([^"\']+)["\']',
        'BiocManager::install\\s*\\(\\s*["\']([^"\']+)["\']',
        'devtools::install_github\\s*\\([^"\']*["\']([^/]+)/([^"\']+)["\']'
      )
      
      for (pattern in install_patterns) {
        matches <- gregexpr(pattern, line, perl = TRUE)[[1]]
        if (matches[1] != -1) {
          match_text <- regmatches(line, matches)
          for (match in match_text) {
            if (grepl("github", pattern)) {
              # For GitHub packages, extract package name from repo/package format
              pkg <- gsub('.*["\']([^/]+)/([^"\']+)["\'].*', '\\2', match)
            } else {
              pkg <- gsub(pattern, '\\1', match, perl = TRUE)
            }
            pkg <- gsub('["\']', '', pkg)
            if (pkg != "" && !grepl("^[0-9]", pkg) && !grepl("[^a-zA-Z0-9._]", pkg)) {
              packages <- c(packages, pkg)
            }
          }
        }
      }
      
      # Extract from c() vectors of package names
      if (grepl('c\\s*\\(', line) && grepl('["\'][a-zA-Z]', line)) {
        vec_matches <- gregexpr('["\']([a-zA-Z][a-zA-Z0-9._]*)["\']', line)[[1]]
        if (vec_matches[1] != -1) {
          vec_text <- regmatches(line, vec_matches)
          for (match in vec_text) {
            pkg <- gsub('["\']([^"\']+)["\']', '\\1', match)
            if (pkg != "" && !grepl("^[0-9]", pkg) && !grepl("[^a-zA-Z0-9._]", pkg)) {
              packages <- c(packages, pkg)
            }
          }
        }
      }
    }
    
    # Filter out obvious non-packages
    filtered_packages <- c()
    for (pkg in packages) {
      # Skip if it looks like data, file paths, or other non-package strings
      if (nchar(pkg) < 2 || nchar(pkg) > 30) next
      if (grepl("\\.(csv|txt|xlsx|rds|RData|png|jpg|pdf)$", pkg, ignore.case = TRUE)) next
      if (grepl("^(data|file|path|dir|url|http|ftp|www)", pkg, ignore.case = TRUE)) next
      if (pkg %in% c("TRUE", "FALSE", "NULL", "NA", "Inf", "NaN")) next
      
      filtered_packages <- c(filtered_packages, pkg)
    }
    
    return(unique(filtered_packages))
  }, error = function(e) {
    cat("Error reading", rmd_file, ":", e$message, "\n")
    return(character(0))
  })
}

# Function to generate install_dependencies.R script
generate_install_dependencies <- function(packages, output_dir = ".") {
  if (length(packages) == 0) {
    cat("No packages to install for", output_dir, "\n")
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
  
  cat("Generated install_dependencies.R in", output_dir, "with", length(packages), "packages\n")
  cat("  CRAN packages:", length(cran_packages), "\n")
  cat("  Bioconductor packages:", length(bioc_packages), "\n")
  
  return(script_path)
}

# Main function
main <- function() {
  cat("Starting dependency extraction from Rmd files...\n")
  
  # Find all Rmd files
  rmd_files <- list.files(".", pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  cat("Found", length(rmd_files), "Rmd files\n")
  
  # Group by directory
  rmd_by_dir <- split(rmd_files, dirname(rmd_files))
  
  all_packages <- c()
  processed_dirs <- 0
  
  # Process each directory
  for (dir_path in names(rmd_by_dir)) {
    files_in_dir <- rmd_by_dir[[dir_path]]
    cat("\n[", processed_dirs + 1, "/", length(rmd_by_dir), "] Processing directory:", dir_path, "\n")
    cat("  Files:", length(files_in_dir), "\n")
    
    # Extract packages from all Rmd files in this directory
    dir_packages <- c()
    for (rmd_file in files_in_dir) {
      cat("    Processing:", basename(rmd_file))
      packages <- extract_packages_from_rmd(rmd_file)
      cat(" -", length(packages), "packages found\n")
      dir_packages <- c(dir_packages, packages)
    }
    
    dir_packages <- unique(dir_packages)
    
    # Generate install_dependencies.R for this directory if packages found
    if (length(dir_packages) > 0) {
      generate_install_dependencies(dir_packages, dir_path)
      all_packages <- c(all_packages, dir_packages)
    } else {
      cat("  No packages found in", dir_path, "\n")
    }
    
    processed_dirs <- processed_dirs + 1
  }
  
  # Generate main install_dependencies.R in current directory
  all_packages <- unique(all_packages)
  if (length(all_packages) > 0) {
    cat("\nGenerating main install_dependencies.R...\n")
    generate_install_dependencies(all_packages, ".")
  }
  
  # Summary
  cat("\n===========================================\n")
  cat("SUMMARY\n")
  cat("===========================================\n")
  cat("Total Rmd files processed:", length(rmd_files), "\n")
  cat("Total directories processed:", length(rmd_by_dir), "\n")
  cat("Total unique packages found:", length(all_packages), "\n")
  
  if (length(all_packages) > 0) {
    cran_count <- sum(!sapply(all_packages, is_bioc_package))
    bioc_count <- sum(sapply(all_packages, is_bioc_package))
    cat("CRAN packages:", cran_count, "\n")
    cat("Bioconductor packages:", bioc_count, "\n")
    
    cat("\nAll packages found:\n")
    for (i in seq_along(all_packages)) {
      pkg <- all_packages[i]
      source_type <- if (is_bioc_package(pkg)) "Bioc" else "CRAN"
      cat(sprintf("  %3d. %-30s [%s]\n", i, pkg, source_type))
    }
  }
}

# Run main function
main()