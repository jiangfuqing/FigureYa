# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
BiocManager::install("survRM2")
BiocManager::install("ComparisonSurv")
install.packages(c("ComparisonSurv", "ggpubr", "survminer", "survRM2"))
