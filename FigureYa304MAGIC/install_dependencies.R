# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
BiocManager::install("biomaRt")
install.packages("arrow") # for store large matrix, data.frame or data.table
install.packages("reticulate")
reticulate::install_miniconda() # if no conda env in your PC or server
reticulate::py_install("magic-impute") # this will install py packages: `magic` and `scprep`
install.packages("Rmagic") # R interface for magic package
