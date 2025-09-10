# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages(c("survival","survminer","ggplot2"))
library(survival)
library("survminer")
library(ggplot2)
svdata<-read.table("dsg1.txt",header=T,as.is=T)
head(svdata)
sortsv<-svdata[order(svdata$expression),]
