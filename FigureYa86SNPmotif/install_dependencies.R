# Auto-generated package installation script
# Extracted from R Markdown file

# 设置R包安装源为清华大学镜像（中文注释）
# Set R package installation source to Tsinghua University mirror (English comment)
options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))

# 设置Bioconductor包镜像为清华大学镜像（中文注释）
# Set Bioconductor package mirror to Tsinghua University mirror (English comment)
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")

# 检查是否安装了BiocManager包，如果没有则安装（中文注释）
# Check if BiocManager package is installed, install if not (English comment)
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

# 使用BiocManager安装motifbreakR包（中文注释）
# Install the motifbreakR package using BiocManager (English comment)
BiocManager::install("motifbreakR")

# 如果你只提供rs ID，就需要安装这个包（中文注释）
# If you only provide rs IDs, you need to install this package (English comment)
# SNP locations and alleles for Homo sapiens extracted from NCBI dbSNP Build 151. The source data files used for this package were created by NCBI between February 16-22, 2018, and contain SNPs mapped to reference genome GRCh38.p7
# 这个版本的SNP文件480M，其他版本更大，建议下载后本地安装，<http://bioconductor.org/packages/3.8/data/annotation/src/contrib/SNPlocs.Hsapiens.dbSNP142.GRCh37_0.99.5.tar.gz>
# This version of the SNP file is 480M, other versions are even larger. It is recommended to download and install locally. <http://bioconductor.org/packages/3.8/data/annotation/src/contrib/SNPlocs.Hsapiens.dbSNP142.GRCh37_0.99.5.tar.gz>
BiocManager::install("SNPlocs.Hsapiens.dbSNP142.GRCh37")

# 如果你提供bed或vcf，有下面这个包就够了（中文注释）
# If you provide bed or vcf files, this package is sufficient (English comment)
# Full genome sequences for Homo sapiens (Human) as provided by UCSC (hg19, Feb. 2009) and stored in Biostrings objects.
BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
