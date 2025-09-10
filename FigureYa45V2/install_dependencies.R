# Auto-generated package installation script
# Extracted from R Markdown file

#options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
if (!requireNamespace("iClusterPlus"))
  BiocManager::install("iClusterPlus")
# Installation method for R version < 3.5.0 (commented out)
#source("http://bioconductor.org/biocLite.R")
#biocLite("iClusterPlus")
library("iClusterPlus")

#BiocManager::install("DNAcopy")
#BiocManager::install("GenomicRanges")
# Installation method for R < 3.5.0 (commented out)
#source("http://bioconductor.org/biocLite.R")
#biocLite("DNAcopy")
#biocLite("GenomicRanges") 
library("DNAcopy")
library("GenomicRanges")
