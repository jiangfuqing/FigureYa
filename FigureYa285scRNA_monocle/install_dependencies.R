# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
BiocManager::install("monocle")
install.packages("https://cran.r-project.org/src/contrib/Archive/igraph/igraph_2.0.3.tar.gz",repos = NULL)

# devtools::install_github("satijalab/seurat-data")
# InstallData("pbmc3k") 
# install.packages("pbmc3k.SeuratData_3.1.4.tar.gz", repos = NULL, type = "source")
LoadData("pbmc3k")
pbmc <- UpdateSeuratObject(pbmc3k)
