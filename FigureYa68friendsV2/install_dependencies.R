# Auto-generated package installation script
# Extracted from R Markdown file

# 设置CRAN镜像源为清华镜像站 / Set CRAN mirror to Tsinghua TUNA mirror
options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

# 设置Bioconductor镜像源为清华镜像站 / Set Bioconductor mirror to Tsinghua TUNA mirror
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# 使用BiocManager安装人类基因注释数据库 / Install human gene annotation database using BiocManager
BiocManager::install("org.Hs.eg.db", site_repository = "https://bioconductor.org/packages/3.18/data/annotation")

# 安装基因本体语义相似度计算包 / Install GO semantic similarity calculation package
BiocManager::install("GOSemSim")

# 安装ggplot2绘图包 / Install ggplot2 plotting package
install.packages("ggplot2")
