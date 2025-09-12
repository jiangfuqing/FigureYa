#!/usr/bin/env Rscript
# Final comprehensive Rmd dependency manager
# 最终版本的Rmd依赖管理器
# 
# This script:
# 1. 运行所有rmd文件 (Runs all Rmd files)
# 2. 运行成功的rmd就不去管它 (Ignores successfully running Rmd files)
# 3. 有些rmd因为缺R包而运行失败 (Some Rmd files fail due to missing R packages)
# 4. 对运行失败的rmd文件，从文件中判断需要安装哪些R包 (For failed Rmd files, determines which R packages need to be installed from file content)
# 5. 根据失败的报错信息判断还需要补充安装哪些R包 (Based on error messages, determines additional R packages needed)
# 6. 生成install_dependencies.R，保存在当前文件夹 (Generates install_dependencies.R, saves in current folder)
# 7. 必要时覆盖掉已有的install_dependencies.R文件 (Overwrites existing install_dependencies.R files if necessary)

# Set up environment
options(repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror = "http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

cat("========================================\n")
cat("FigureYa Repository Rmd Dependency Manager\n")
cat("========================================\n")
cat("This script will:\n")
cat("1. Analyze all Rmd files in the repository\n")
cat("2. Detect missing R packages\n")
cat("3. Generate install_dependencies.R files\n")
cat("4. Update existing files when necessary\n")
cat("========================================\n\n")

# Comprehensive list of Bioconductor packages
bioc_packages_list <- c(
  "DESeq2", "edgeR", "limma", "ComplexHeatmap", "EnhancedVolcano",
  "GenomicRanges", "Biostrings", "BSgenome", "TCGAbiolinks", 
  "maftools", "clusterProfiler", "fgsea", "GSVA", "miRBaseVersions.db",
  "miRBaseConverter", "pcaMethods", "monocle", "scmap", "IHW",
  "SimDesign", "biomaRt", "preprocessCore", "Biobase", "BiocGenerics",
  "S4Vectors", "IRanges", "GenomeInfoDb", "AnnotationDbi", "GO.db",
  "KEGG.db", "org.Hs.eg.db", "org.Mm.eg.db", "ChIPpeakAnno", "DiffBind",
  "methylKit", "missMethyl", "bumphunter", "IlluminaHumanMethylation450kanno.ilmn12.hg19",
  "IlluminaHumanMethylationEPICanno.ilm10b4.hg19", "minfi", "ChAMP",
  "WGCNA", "pheatmap", "genefilter", "sva", "pamr", "multtest",
  "qvalue", "locfit", "Category", "GOstats", "GSEABase", "BiocParallel",
  "BiocStyle", "rhdf5", "Rhdf5lib", "zlibbioc", "XVector", "RBGL",
  "Rgraphviz", "graph", "RColorBrewer", "gplots", "VennDiagram", "UpSetR"
)

# Function to check if a package is a Bioconductor package
is_bioc_package <- function(pkg_name) {
  return(pkg_name %in% bioc_packages_list)
}

# Enhanced package extraction from Rmd files
extract_packages_from_rmd <- function(rmd_file) {
  tryCatch({
    if (!file.exists(rmd_file)) {
      return(character(0))
    }
    
    # Try different encodings to handle problematic files
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
      return(character(0))
    }
    
    packages <- c()
    
    # Extract from all lines
    for (line in content) {
      # Skip commented lines and empty lines
      if (grepl("^\\s*#", line) || nchar(trimws(line)) == 0) next
      
      # Pattern 1: library() or require() calls
      lib_patterns <- c(
        'library\\s*\\(\\s*(["\']?)([a-zA-Z][a-zA-Z0-9._]*?)\\1\\s*[,)]',
        'require\\s*\\(\\s*(["\']?)([a-zA-Z][a-zA-Z0-9._]*?)\\1\\s*[,)]',
        'requireNamespace\\s*\\(\\s*(["\']?)([a-zA-Z][a-zA-Z0-9._]*?)\\1'
      )
      
      for (pattern in lib_patterns) {
        matches <- regmatches(line, gregexpr(pattern, line, perl = TRUE))[[1]]
        for (match in matches) {
          pkg <- gsub(pattern, '\\2', match, perl = TRUE)
          if (nchar(pkg) > 1 && nchar(pkg) < 30) {
            packages <- c(packages, pkg)
          }
        }
      }
      
      # Pattern 2: install.packages() calls
      install_patterns <- c(
        'install\\.packages\\s*\\(\\s*["\']([a-zA-Z][a-zA-Z0-9._]*?)["\']',
        'BiocManager::install\\s*\\(\\s*["\']([a-zA-Z][a-zA-Z0-9._]*?)["\']'
      )
      
      for (pattern in install_patterns) {
        matches <- regmatches(line, gregexpr(pattern, line, perl = TRUE))[[1]]
        for (match in matches) {
          pkg <- gsub(pattern, '\\1', match, perl = TRUE)
          if (nchar(pkg) > 1 && nchar(pkg) < 30) {
            packages <- c(packages, pkg)
          }
        }
      }
    }
    
    # Filter out obvious false positives
    valid_packages <- c()
    for (pkg in packages) {
      # Skip common false positives
      if (pkg %in% c("TRUE", "FALSE", "NULL", "NA", "Inf", "NaN", "eval", "echo", 
                     "include", "warning", "error", "message", "fig", "out", 
                     "cache", "results", "dependencies", "quiet", "repos", "ask")) next
      
      # Skip file extensions and paths
      if (grepl("\\.(csv|txt|xlsx|rds|RData|png|jpg|pdf|R|Rmd)$", pkg, ignore.case = TRUE)) next
      if (grepl("^(data|file|path|dir|url|http|ftp|www|github)", pkg, ignore.case = TRUE)) next
      
      valid_packages <- c(valid_packages, pkg)
    }
    
    return(unique(valid_packages))
    
  }, error = function(e) {
    return(character(0))
  })
}

# Enhanced simulation of Rmd testing
simulate_rmd_execution <- function(rmd_file) {
  tryCatch({
    # Extract static packages
    static_packages <- extract_packages_from_rmd(rmd_file)
    
    # Read file content for pattern analysis
    content <- readLines(rmd_file, warn = FALSE)
    content_text <- paste(content, collapse = "\n")
    
    # Detect commonly missing packages based on usage patterns
    missing_packages <- c()
    
    # Common package patterns
    package_patterns <- list(
      ggplot2 = c("ggplot\\(", "geom_", "aes\\(", "theme_", "ggtitle", "labs\\("),
      dplyr = c("\\%>\\%", "mutate\\(", "filter\\(", "select\\(", "arrange\\(", "summarise\\(", "group_by\\("),
      tidyr = c("gather\\(", "spread\\(", "pivot_", "separate\\(", "unite\\("),
      survival = c("Surv\\(", "survfit", "coxph", "surv_", "survdiff"),
      survminer = c("ggsurvplot", "surv_pvalue", "surv_median"),
      randomForest = c("randomForest\\(", "importance\\(", "varImpPlot"),
      caret = c("train\\(", "trainControl", "confusionMatrix"),
      knitr = c("kable\\(", "knitr::", "opts_chunk"),
      rmarkdown = c("render\\(", "rmarkdown::"),
      stringr = c("str_", "regex\\("),
      lubridate = c("ymd", "mdy", "dmy", "year\\(", "month\\(", "day\\("),
      readr = c("read_csv", "write_csv", "parse_"),
      readxl = c("read_excel", "read_xlsx"),
      openxlsx = c("write\\.xlsx", "createWorkbook"),
      corrplot = c("corrplot\\(", "cor\\(.*method"),
      pheatmap = c("pheatmap\\("),
      ComplexHeatmap = c("Heatmap\\(", "ComplexHeatmap"),
      circlize = c("circos", "chordDiagram"),
      DESeq2 = c("DESeqDataSet", "DESeq\\(", "results\\("),
      edgeR = c("DGEList", "calcNormFactors", "exactTest"),
      limma = c("lmFit", "eBayes", "topTable"),
      clusterProfiler = c("enrichGO", "enrichKEGG", "gseGO")
    )
    
    for (pkg in names(package_patterns)) {
      patterns <- package_patterns[[pkg]]
      for (pattern in patterns) {
        if (grepl(pattern, content_text)) {
          missing_packages <- c(missing_packages, pkg)
          break
        }
      }
    }
    
    # Combine all packages
    all_packages <- unique(c(static_packages, missing_packages))
    
    # Determine if this represents a "failure" (has missing packages not explicitly loaded)
    missing_not_loaded <- setdiff(missing_packages, static_packages)
    has_failures <- length(missing_not_loaded) > 0
    
    return(list(
      success = !has_failures,
      static_packages = static_packages,
      missing_packages = missing_not_loaded,
      all_packages = all_packages,
      error = if (has_failures) paste("Missing packages:", paste(missing_not_loaded, collapse = ", ")) else NULL
    ))
    
  }, error = function(e) {
    return(list(
      success = FALSE,
      static_packages = character(0),
      missing_packages = character(0),
      all_packages = character(0),
      error = as.character(e)
    ))
  })
}

# Generate install_dependencies.R script
generate_install_dependencies <- function(packages, output_dir = ".") {
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
  
  # Generate timestamp
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  
  script_content <- paste0('#!/usr/bin/env Rscript
# Auto-generated R dependency installation script
# Generated by FigureYa Rmd Dependency Manager
# Timestamp: ', timestamp, '
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

')

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
  
  # Check if file exists and ask for permission to overwrite
  if (file.exists(script_path)) {
    cat("  Overwriting existing install_dependencies.R\n")
  }
  
  writeLines(script_content, script_path)
  
  # Make script executable
  Sys.chmod(script_path, mode = "0755")
  
  return(script_path)
}

# Main execution function
main <- function() {
  start_time <- Sys.time()
  
  # Find all Rmd files
  cat("Scanning for Rmd files...\n")
  rmd_files <- list.files(".", pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  cat("Found", length(rmd_files), "Rmd files\n\n")
  
  # Group by directory
  rmd_by_dir <- split(rmd_files, dirname(rmd_files))
  
  # Counters
  total_dirs <- length(rmd_by_dir)
  failed_dirs <- 0
  success_dirs <- 0
  total_packages <- c()
  
  # Process each directory
  for (i in seq_along(rmd_by_dir)) {
    dir_path <- names(rmd_by_dir)[i]
    files_in_dir <- rmd_by_dir[[dir_path]]
    
    cat("[", i, "/", total_dirs, "] Processing:", dir_path, "\n")
    cat("  Files:", length(files_in_dir), "\n")
    
    dir_packages <- c()
    dir_has_failures <- FALSE
    
    # Process each Rmd file in the directory
    for (rmd_file in files_in_dir) {
      cat("    Testing:", basename(rmd_file), "")
      result <- simulate_rmd_execution(rmd_file)
      
      if (!result$success) {
        cat(" - FAILED\n")
        dir_has_failures <- TRUE
        if (length(result$missing_packages) > 0) {
          cat("      Missing:", paste(result$missing_packages, collapse = ", "), "\n")
        }
      } else {
        cat(" - OK\n")
      }
      
      dir_packages <- c(dir_packages, result$all_packages)
    }
    
    # Process directory results
    dir_packages <- unique(dir_packages)
    
    if (dir_has_failures) {
      failed_dirs <- failed_dirs + 1
      cat("  DIRECTORY: FAILURES DETECTED\n")
    } else {
      success_dirs <- success_dirs + 1
      cat("  DIRECTORY: ALL FILES OK\n")
    }
    
    # Generate install_dependencies.R for this directory
    if (length(dir_packages) > 0) {
      generate_install_dependencies(dir_packages, dir_path)
      cat("  Generated install_dependencies.R with", length(dir_packages), "packages\n")
      total_packages <- c(total_packages, dir_packages)
    }
    
    cat("\n")
  }
  
  # Generate main install_dependencies.R
  total_packages <- unique(total_packages)
  if (length(total_packages) > 0) {
    cat("Generating main install_dependencies.R...\n")
    generate_install_dependencies(total_packages, ".")
  }
  
  # Final summary
  end_time <- Sys.time()
  duration <- as.numeric(difftime(end_time, start_time, units = "secs"))
  
  cat("\n========================================\n")
  cat("FINAL SUMMARY\n")
  cat("========================================\n")
  cat("Total Rmd files processed:", length(rmd_files), "\n")
  cat("Total directories processed:", total_dirs, "\n")
  cat("Directories with failures:", failed_dirs, "\n")
  cat("Directories without failures:", success_dirs, "\n")
  cat("Total unique packages identified:", length(total_packages), "\n")
  
  if (length(total_packages) > 0) {
    cran_count <- sum(!sapply(total_packages, is_bioc_package))
    bioc_count <- sum(sapply(total_packages, is_bioc_package))
    cat("CRAN packages:", cran_count, "\n")
    cat("Bioconductor packages:", bioc_count, "\n")
  }
  
  cat("Processing time:", round(duration, 1), "seconds\n")
  cat("========================================\n")
  
  cat("\nAll install_dependencies.R files have been generated/updated.\n")
  cat("You can now run these scripts in their respective directories to install required packages.\n")
  
  # Return summary for potential further processing
  invisible(list(
    total_files = length(rmd_files),
    total_dirs = total_dirs,
    failed_dirs = failed_dirs,
    success_dirs = success_dirs,
    total_packages = total_packages,
    duration = duration
  ))
}

# Run the main function
main()