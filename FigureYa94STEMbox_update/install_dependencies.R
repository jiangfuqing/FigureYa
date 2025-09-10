# Auto-generated package installation script
# Extracted from R Markdown file

# 设置CRAN镜像为清华大学镜像站（中国用户推荐使用，提升下载速度）
# Set the CRAN mirror to Tsinghua University mirror (recommended for Chinese users to improve download speed)
options("repos" = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

# 设置Bioconductor镜像为中国科学技术大学镜像站（用于安装生物信息学相关包）
# Set the Bioconductor mirror to University of Science and Technology of China mirror (for installing bioinformatics-related packages)
options(BioC_mirror = "http://mirrors.ustc.edu.cn/bioc/")

# 安装Cairo包（用于高质量图形渲染，支持多种输出格式如PDF、PNG等）
# Install the Cairo package (for high-quality graphics rendering, supporting multiple output formats like PDF, PNG, etc.)
install.packages("Cairo")

# 安装extrafont包（用于在R图形中使用系统字体，解决中文显示等字体问题）
# Install the extrafont package (for using system fonts in R graphics, solving font issues like Chinese display)
