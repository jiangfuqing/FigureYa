# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
BiocManager::install("biomaRt")
install.packages("arrow") # for store large matrix, data.frame or data.table
install.packages("reticulate")
install.packages("Rmagic") # R interface for magic package
