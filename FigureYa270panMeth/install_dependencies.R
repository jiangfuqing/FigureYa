# Auto-generated package installation script
# Extracted from R Markdown file

# 设置CRAN镜像为清华大学镜像源，加速R包下载
# Set CRAN mirror to Tsinghua University mirror source to speed up R package downloads
options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

# 设置Bioconductor镜像为清华大学镜像源，加速生物信息学相关包的下载
# Set Bioconductor mirror to Tsinghua University mirror source to speed up downloads of bioinformatics-related packages
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# 使用BiocManager安装ChAMP包，用于DNA甲基化数据分析
# Install the ChAMP package using BiocManager for DNA methylation data analysis
BiocManager::install("ChAMP")

# 使用BiocManager安装ChAMPdata包，包含ChAMP分析所需的示例数据集
# Install the ChAMPdata package using BiocManager, which contains example datasets required for ChAMP analysis
BiocManager::install("ChAMPdata")

# 使用BiocManager安装ComplexHeatmap包，用于创建复杂热图可视化
# Install the ComplexHeatmap package using BiocManager for creating complex heatmap visualizations
BiocManager::install("ComplexHeatmap")

# 安装ggpubr包用于增强ggplot2的统计可视化功能，以及randomcoloR包用于生成随机配色方案
# Install the ggpubr package to enhance ggplot2's statistical visualization capabilities, and the randomcoloR package to generate random color schemes
install.packages(c("ggpubr", "randomcoloR"))
