# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

BiocManager::install("org.Hs.eg.db", site_repository = "https://bioconductor.org/packages/3.18/data/annotation")

BiocManager::install("GOSemSim")

install.packages("ggplot2")
