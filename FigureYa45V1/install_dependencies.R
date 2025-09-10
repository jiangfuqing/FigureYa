# Auto-generated package installation script
# Extracted from R Markdown file

#options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
if ( ! require(iClusterPlus)) BiocInstaller::biocLite("iClusterPlus")

#install.packages("gplots")
library(gplots)
library(lattice)
data(gbm)
