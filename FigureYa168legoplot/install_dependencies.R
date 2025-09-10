# Auto-generated package installation script
# Extracted from R Markdown file

  install.packages("BiocManager")
if (!("BSgenome.Hsapiens.UCSC.hg19" %in% rownames(installed.packages()))) {
  BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
if (!("VariantAnnotation" %in% rownames(installed.packages()))) {
  BiocManager::install("VariantAnnotation")
if (!("rgl" %in% rownames(installed.packages()))) {
  install.packages("rgl")
Sys.setenv(LANGUAGE = "en") #显示英文报错信息 #Display English error message
options(stringsAsFactors = FALSE) #禁止chr转成factor # Disable conversion of chr to factor
