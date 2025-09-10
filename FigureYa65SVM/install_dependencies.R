# Auto-generated package installation script
# Extracted from R Markdown file

#options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
#options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
#install.packages("glmnet") 
#if (!requireNamespace("BiocManager", quietly = TRUE))
    #install.packages("BiocManager")
#BiocManager::install("sigFeature", version = "3.8") 
library(tidyverse)
library(glmnet)
source('msvmRFE.R')   #文件夹内自带 it comes with it in the folder
library(VennDiagram)
library(sigFeature)
library(e1071)
library(caret)
library(randomForest)
