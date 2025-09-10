# Auto-generated package installation script
# Extracted from R Markdown file

# 设置CRAN镜像为清华大学镜像源（Set CRAN mirror to Tsinghua University mirror source）
options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
# 设置Bioconductor镜像为清华大学镜像源（Set Bioconductor mirror to Tsinghua University mirror source）
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# 下载DealGPL570，下载地址https://cran.r-project.org/src/contrib/Archive/DealGPL570/
# DealGPL570 package version 2.0 will report errors during operation, so I installed version 1.0 locally. 
# Place the compressed package DealGPL570_0.0.1.tar.gz in the current working directory. 
# In Rstudio, click Install in the lower right corner, select the second option for "Install from", 
# click Browse and select DealGPL570_0.0.1.tar.gz, then click Install.
# Or install from the command line
# 从本地源安装DealGPL570包（Install the DealGPL570 package from a local source）
install.packages("DealGPL570", repos = NULL, type = "source")
