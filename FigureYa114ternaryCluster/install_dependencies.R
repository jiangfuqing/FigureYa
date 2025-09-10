# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")
Packages <- c("pheatmap","gplots") # CRAN的包 | Packages from CRAN
for(pk in Packages){
  if(!require(pk,character.only = T,quietly = T)) install.packages(pk)
  suppressMessages(library(pk,character.only = T))
if(!require("GSVA",character.only = T,quietly = T)){
  if(!require("BiocManager",character.only = T, quietly = TRUE)) install.packages("BiocManager")
  BiocManager::install("GSVA") # Bioconductor的包 | Package from Bioconductor
suppressMessages(library("GSVA",character.only = T))
Sys.setenv(LANGUAGE = "en") 
options(stringsAsFactors = FALSE)
