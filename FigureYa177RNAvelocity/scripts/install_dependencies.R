# Auto-generated package installation script
# Extracted from R Markdown file

install.packages('devtools')
BiocManager::install("NMF")
devtools::install_github("cran/SDMTools")
devtools::install_version(package = 'Seurat', version = package_version('2.2.0'))
BiocManager::install("pcaMethods")
devtools::install_github("velocyto-team/velocyto.R")
BiocManager::install("monocle")
BiocManager::install(c("scmap"))
BiocManager::install("DESeq2")
BiocManager::install("IHW")
