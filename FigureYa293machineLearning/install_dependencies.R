# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
BiocManager::install("mixOmics")
install.packages("plsRcox")
BiocManager::install("survcomp")
install.packages("rlang")
library(devtools)
install_github("binderh/CoxBoost")
