# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("motifbreakR")

BiocManager::install("SNPlocs.Hsapiens.dbSNP142.GRCh37")

BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
