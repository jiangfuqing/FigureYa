# Auto-generated package installation script
# Extracted from R Markdown file

options(BioC_mirror="https://mirrors.tuna.tsinghua.edu.cn/bioconductor")
if (!require("pacman")) install.packages("pacman")
if (!require("DESeq2")) BiocManager::install("DESeq2")
if (!require("S4Vectors")) BiocManager::install("S4Vectors")
if (!require("BiocParallel")) BiocManager::install("BiocParallel")
