# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
BiocManager::install("Biobase")
BiocManager::install("GSVA")
BiocManager::install("ComplexHeatmap")
install.packages("estimate", repos=rforge, dependencies=TRUE)
install.packages("R.utils")
