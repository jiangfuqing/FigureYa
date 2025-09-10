# Auto-generated package installation script
# Extracted from R Markdown file

options(BioC_mirror="https://mirrors.tuna.tsinghua.edu.cn/bioconductor")
options(repos=structure(c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))) 
if (!require("pacman")) install.packages("pacman")
pacman::p_load(svglite, ggplot2, magrittr,patchwork,Rmisc,Cairo,stringr,tidyr,tidyfst,data.table,rlist,Hmisc,grid,gtable,gridExtra,ggpubr)
if (!require("DESeq2")) BiocManager::install("DESeq2")
if (!require("S4Vectors")) BiocManager::install("S4Vectors")
if (!require("BiocParallel")) BiocManager::install("BiocParallel")
