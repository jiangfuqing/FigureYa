# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
install.packages("SimDesign")

if(!require(officer)) (install.packages('officer'))
library(officer)
library(dplyr)
my_doc <- read_docx()  #初始化一个docx  # Initialize a docx
  body_add_par(value = title_name, style = "table title") %>%
  body_add_table(value = table1, style = "Light List Accent 2" ) %>% 
  body_add_par(value = mynote) %>% 
  print(target = "Table.docx")
