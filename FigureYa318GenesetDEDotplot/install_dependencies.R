# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
install.packages("BiocManager")
install.packages("SeuratObject")
BiocManager::install("GEOquery")
BiocManager::install("AUCell")
BiocManager::install("clusterProfiler")
BiocManager::install("limma")
BiocManager::install("GSVA")
