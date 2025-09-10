# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
if(!require(survival)){ 
  install.packages("survival")
} else {library(survival)}  
if(!require(glmnet)){ 
  install.packages("glmnet")
} else {library(glmnet)}  
if(!require(pbapply)){ 
  install.packages("pbapply")
} else {library(pbapply)}  
if(!require(survivalROC)){ 
  install.packages("survivalROC")
} else {library(survivalROC)}
