# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#BiocManager::install("ComplexHeatmap")
library(tidyverse)      # 数据处理和可视化工具集 | Data processing and visualization toolkit
library(magrittr)       # 提供管道操作符 %>% | Provides pipe operator %>%
library(readxl)         # 读取Excel文件 | Read Excel files
library(stringr)        # 字符串处理工具 | String processing tools
library(forcats)        # 因子处理工具 | Factor processing tools
library(ComplexHeatmap) # 复杂热图绘制 | Complex heatmap plotting
library(RColorBrewer)   # 颜色方案 | Color schemes
Sys.setenv(LANGUAGE = "en") # 显示英文报错信息 | Display error messages in English
options(stringsAsFactors = FALSE) # 禁止chr转成factor | Prevent converting strings to factors
