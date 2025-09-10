# Auto-generated package installation script
# Extracted from R Markdown file

# 设置CRAN镜像为清华大学镜像源（Set CRAN mirror to Tsinghua University mirror source）
options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

# 设置Bioconductor镜像为清华大学镜像源（Set Bioconductor mirror to Tsinghua University mirror source）
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# 安装clusterProfiler包：用于基因富集分析和可视化（Install the clusterProfiler package: for gene enrichment analysis and visualization）
BiocManager::install("clusterProfiler")

# 安装GSVA包：用于基因集变异分析（Install the GSVA package: for gene set variation analysis）
BiocManager::install("GSVA")
