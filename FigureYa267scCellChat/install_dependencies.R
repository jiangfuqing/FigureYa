# Auto-generated package installation script
# Extracted from R Markdown file

# 设置R包安装源为清华镜像（Set CRAN mirror to Tsinghua University）
options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
# 设置Bioconductor镜像为清华源（Set Bioconductor mirror to Tsinghua University）
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
# 安装管道操作符包（Install the magrittr package for pipe operators）
install.packages("magrittr")
# 从GitHub安装Seurat-data包（Install the Seurat-data package from GitHub）
devtools::install_github('satijalab/seurat-data')
# 从GitHub安装CellChat包用于细胞间通讯分析（Install the CellChat package from GitHub for cell-cell communication analysis）
devtools::install_github("jinworks/CellChat") 
install.packages("ifnb.SeuratData_3.1.0.tar.gz", repos = NULL, type = "source")
devtools::install_github('immunogenomics/presto')
