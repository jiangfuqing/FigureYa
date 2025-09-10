# Auto-generated package installation script
# Extracted from R Markdown file

# 设置CRAN镜像为清华大学镜像源，提高包下载速度（Set CRAN mirror to Tsinghua University source for faster package downloads）
options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

# 设置Bioconductor镜像为清华大学镜像源，用于生物信息学相关包的下载（Set Bioconductor mirror to Tsinghua University source for bioinformatics package downloads）
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# 安装ggstatsplot包，该包集成了ggplot2和统计测试功能（Install the ggstatsplot package, which integrates ggplot2 and statistical testing functions）
install.packages("ggstatsplot")
