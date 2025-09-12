#!/usr/bin/env Rscript
# Enhanced script to run Rmd files, detect errors, and update install_dependencies.R
# 增强版脚本：运行Rmd文件，检测错误，并更新install_dependencies.R

# Load required libraries
suppressMessages({
  if (!require(knitr, quietly = TRUE)) {
    cat("Installing knitr...\n")
    install.packages("knitr", repos = "https://cloud.r-project.org")
    library(knitr)
  }
})

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
    "Rgraphviz", "graph", "Rcpp", "RCurl", "XML", "RJSONIO", "bitops",
    "RColorBrewer", "gplots", "VennDiagram", "UpSetR"
  )
  return(pkg_name %in% bioc_packages)
}

# Function to extract packages from error messages
extract_missing_packages_from_error <- function(error_msg) {
  packages <- c()
  
  # Common error patterns for missing packages
  patterns <- c(
    "there is no package called '([^']+)'",
    "package '([^']+)' not found",
    "could not find package \"([^\"]+)\"",
    "Error in library\\(([^)]+)\\)",
    "namespace '([^']+)' .* not available",
    "Error.*: could not find function \"([^\"]+)\"",
    "object '([^']+)' not found"
  )
  
  for (pattern in patterns) {
    matches <- regmatches(error_msg, gregexpr(pattern, error_msg, ignore.case = TRUE, perl = TRUE))
    for (match_group in matches) {
      for (match in match_group) {
        if (length(match) > 0) {
          pkg <- gsub(pattern, "\\1", match, ignore.case = TRUE, perl = TRUE)
          pkg <- gsub('["\']', '', pkg) # Remove quotes
          if (pkg != "" && !grepl("^[0-9]", pkg) && nchar(pkg) > 1 && nchar(pkg) < 30) {
            packages <- c(packages, pkg)
          }
        }
      }
    }
  }
  
  return(unique(packages))
}

# Function to run R code from Rmd file chunk by chunk
test_rmd_chunks <- function(rmd_file) {
  tryCatch({
    if (!file.exists(rmd_file)) {
      return(list(success = FALSE, error = "File not found", missing_packages = character(0)))
    }
    
    # Parse the Rmd file
    content <- readLines(rmd_file, warn = FALSE)
    
    # Extract R chunks
    r_chunks <- list()
    in_r_chunk <- FALSE
    current_chunk <- c()
    chunk_options <- ""
    
    for (i in seq_along(content)) {
      line <- content[i]
      
      if (grepl("^```\\{r", line)) {
        in_r_chunk <- TRUE
        chunk_options <- line
        current_chunk <- c()
      } else if (grepl("^```$", line) && in_r_chunk) {
        in_r_chunk <- FALSE
        if (length(current_chunk) > 0) {
          # Skip chunks with eval=FALSE or similar
          if (!grepl("eval\\s*=\\s*FALSE", chunk_options, ignore.case = TRUE)) {
            r_chunks <- append(r_chunks, list(current_chunk), length(r_chunks))
          }
        }
      } else if (in_r_chunk) {
        current_chunk <- c(current_chunk, line)
      }
    }
    
    # Test each chunk
    all_errors <- c()
    missing_packages <- c()
    
    for (i in seq_along(r_chunks)) {
      chunk <- r_chunks[[i]]
      chunk_code <- paste(chunk, collapse = "\n")
      
      # Skip empty chunks or comment-only chunks
      if (nchar(trimws(gsub("#.*", "", chunk_code))) == 0) next
      
      # Skip chunks that are just data or assignments without library calls
      if (!grepl("library|require|install\\.packages", chunk_code)) next
      
      # Try to execute the chunk
      tryCatch({
        # Create a temporary environment
        temp_env <- new.env()
        
        # Execute the code in the temporary environment
        eval(parse(text = chunk_code), envir = temp_env)
        
      }, error = function(e) {
        error_msg <- as.character(e)
        all_errors <- c(all_errors, error_msg)
        
        # Extract missing packages from error
        pkg_names <- extract_missing_packages_from_error(error_msg)
        missing_packages <<- c(missing_packages, pkg_names)
        
        cat("    Chunk", i, "error:", substr(error_msg, 1, 100), "...\n")
      })
    }
    
    missing_packages <- unique(missing_packages)
    
    if (length(all_errors) > 0) {
      return(list(
        success = FALSE, 
        error = paste(all_errors, collapse = "; "),
        missing_packages = missing_packages,
        num_chunks_tested = length(r_chunks)
      ))
    } else {
      return(list(
        success = TRUE, 
        error = NULL,
        missing_packages = character(0),
        num_chunks_tested = length(r_chunks)
      ))
    }
    
  }, error = function(e) {
    return(list(
      success = FALSE, 
      error = as.character(e),
      missing_packages = extract_missing_packages_from_error(as.character(e)),
      num_chunks_tested = 0
    ))
  })
}

# Function to extract packages from Rmd file content (static analysis)
extract_packages_from_rmd <- function(rmd_file) {
  tryCatch({
    if (!file.exists(rmd_file)) {
      return(character(0))
    }
    
    content <- readLines(rmd_file, warn = FALSE)
    packages <- c()
    
    # Extract from all lines
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
            if (pkg != "" && !grepl("^[0-9]", pkg) && !grepl("[^a-zA-Z0-9._]", pkg) && nchar(pkg) > 1) {
              packages <- c(packages, pkg)
            }
          }
        }
      }
    }
    
    return(unique(packages))
  }, error = function(e) {
    return(character(0))
  })
}

# Function to update install_dependencies.R with additional packages
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
# Generated by enhanced error detection script

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
  
  cat("  Updated install_dependencies.R with", length(packages), "packages\n")
  
  return(script_path)
}

# Main function to test a specific directory or all directories
main <- function(target_dir = NULL, max_files = NULL) {
  cat("Starting enhanced Rmd testing with error detection...\n")
  
  if (!is.null(target_dir) && dir.exists(target_dir)) {
    # Test specific directory
    rmd_files <- list.files(target_dir, pattern = "\\.Rmd$", recursive = FALSE, full.names = TRUE)
    cat("Testing directory:", target_dir, "with", length(rmd_files), "Rmd files\n")
  } else {
    # Find all Rmd files
    rmd_files <- list.files(".", pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
    if (!is.null(max_files)) {
      rmd_files <- rmd_files[1:min(length(rmd_files), max_files)]
    }
    cat("Found", length(rmd_files), "Rmd files to test\n")
  }
  
  failed_files <- list()
  success_count <- 0
  
  # Process each Rmd file
  for (i in seq_along(rmd_files)) {
    rmd_file <- rmd_files[i]
    rmd_dir <- dirname(rmd_file)
    
    cat("\n[", i, "/", length(rmd_files), "] Testing:", rmd_file, "\n")
    
    # Get packages from static analysis
    static_packages <- extract_packages_from_rmd(rmd_file)
    cat("  Static analysis found", length(static_packages), "packages\n")
    
    # Test chunks for runtime errors
    result <- test_rmd_chunks(rmd_file)
    cat("  Tested", result$num_chunks_tested, "R chunks\n")
    
    if (!result$success) {
      cat("  RUNTIME ERRORS DETECTED\n")
      
      # Combine packages from static analysis and error detection
      all_packages <- unique(c(static_packages, result$missing_packages))
      
      failed_files[[rmd_file]] <- list(
        static_packages = static_packages,
        error_packages = result$missing_packages,
        all_packages = all_packages,
        error = result$error
      )
      
      # Update install_dependencies.R for this directory
      if (length(all_packages) > 0) {
        update_install_dependencies(all_packages, rmd_dir)
        cat("  Updated install_dependencies.R with", length(all_packages), "packages\n")
      }
      
    } else {
      success_count <- success_count + 1
      cat("  SUCCESS - No runtime errors detected\n")
      
      # Still update install_dependencies.R with static packages if any
      if (length(static_packages) > 0) {
        update_install_dependencies(static_packages, rmd_dir)
        cat("  Updated install_dependencies.R with", length(static_packages), "static packages\n")
      }
    }
  }
  
  # Summary
  cat("\n===========================================\n")
  cat("ENHANCED TESTING SUMMARY\n")
  cat("===========================================\n")
  cat("Total Rmd files tested:", length(rmd_files), "\n")
  cat("Files with runtime errors:", length(failed_files), "\n")
  cat("Files without errors:", success_count, "\n")
  
  if (length(failed_files) > 0) {
    cat("\nFiles with runtime errors:\n")
    for (file in names(failed_files)) {
      info <- failed_files[[file]]
      cat("- ", file, "\n")
      cat("  Static packages:", length(info$static_packages), "\n")
      cat("  Error packages:", length(info$error_packages), "\n")
      if (length(info$error_packages) > 0) {
        cat("  Missing packages:", paste(info$error_packages, collapse = ", "), "\n")
      }
    }
  }
}

# Check command line arguments
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) {
  if (args[1] == "--help") {
    cat("Usage:\n")
    cat("  Rscript test_rmd_with_error_detection.R [directory] [max_files]\n")
    cat("  directory: specific directory to test (optional)\n") 
    cat("  max_files: maximum number of files to test (optional)\n")
    quit()
  }
  
  target_dir <- if (length(args) >= 1) args[1] else NULL
  max_files <- if (length(args) >= 2) as.numeric(args[2]) else NULL
  
  main(target_dir, max_files)
} else {
  # Default: test first 5 files for demonstration
  main(NULL, 5)
}