# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages("devtools")
#library(devtools)
#devtools::install_github("GuangchuangYu/yyplot")
#devtools::install_github('fawda123/ggord')
library(ggplot2)
library(plyr)
library(ggord)
library(yyplot)
#source('./geom_ord_ellipse.R') #该文件位于当前文件夹 the file is located in the current folder
      cols = mycol[1:length(unique(meta_df$group))],
      arrow = NULL,txt = NULL) + #不画箭头和箭头上的文字 no drawing of arrows and text on arrows
  theme(panel.grid =element_blank()) + #去除网格线 remove gridlines
                   lty=1 ) #实线 solid line
ggsave("PCA_classic.pdf", width = 6, height = 6)

#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("plyr")
library(ggplot2)
library(dplyr)
library(plyr)
pca.pv <- summary(pca.results)$importance[2,]
