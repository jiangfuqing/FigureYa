# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
install.packages("magrittr")
devtools::install_github('satijalab/seurat-data')
devtools::install_github("jinworks/CellChat") 
install.packages("ifnb.SeuratData_3.1.0.tar.gz", repos = NULL, type = "source")
devtools::install_github('immunogenomics/presto')
