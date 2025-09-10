# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages("pROC")
library("pROC")
mycol <- c("slateblue","seagreen3","dodgerblue","firebrick1","lightgoldenrod","magenta","orange2")
pdf("ROC.pdf",height=6,width=6)
auc.out <- c()
x <- plot.roc(df[,1],df[,2],ylim=c(0,1),xlim=c(1,0),
              main="",
              #print.thres="best", #把阈值写在图上，其sensitivity+ specificity之和最大 write the threshold on the graph with the sum of its sensitivity and specificity maximized
              legacy.axes=T)#采用大多数paper的画法，横坐标是“1-specificity”，从0到1 adopt the way most papers are drawn, the horizontal coordinate is "1-specificity", from 0 to 1.
ci.lower <- round(as.numeric(x$ci[1]),3) #置信区间下限 lower bound of the confidence interval
ci.upper <- round(as.numeric(x$ci[3]),3) #置信区间上限 upper bound of the confidence interval
auc.ci <- c(colnames(df)[2],round(as.numeric(x$auc),3),paste(ci.lower,ci.upper,sep="-"))
auc.out <- rbind(auc.out,auc.ci)
for (i in 3:ncol(df)){
                legacy.axes=T)
  ci.lower <- round(as.numeric(x$ci[1]),3)
  ci.upper <- round(as.numeric(x$ci[3]),3)
  auc.ci <- c(colnames(df)[i],round(as.numeric(x$auc),3),paste(ci.lower,ci.upper,sep="-"))
  auc.out <- rbind(auc.out,auc.ci)
#after the parameter `method=`, there are three methods to choose from "delong", "bootstrap" or "venkatraman", calculate p-value
p.out <- c()
for (i in 2:(ncol(df)-1)){
  for (j in (i+1):ncol(df)){
    p <- roc.test(df[,1],df[,i],df[,j], method="bootstrap")
    p.tmp <- c(colnames(df)[i],colnames(df)[j],p$p.value)
    p.out <- rbind(p.out,p.tmp)
p.out <- as.data.frame(p.out)
colnames(p.out) <- c("ROC1","ROC2","p.value")
write.table(p.out,"pvalue_output.xls",sep="\t",quote=F,row.names = F,col.names = T)
#There are 4 lines and 6 sets of comparisons here. It's too much to write.
#text(0.4, 0.3, labels=paste("miRNA1 vs. miRNA2\np-value =", p.out[1,3]), adj=c(0, .5))
auc.out <- as.data.frame(auc.out)
colnames(auc.out) <- c("Name","AUC","AUC CI")
write.table(auc.out,"auc_output.xls",sep="\t",quote = F,row.names = F,col.names = T)
legend.name <- paste(colnames(df)[2:length(df)],"AUC",auc.out$AUC,sep=" ")
legend("bottomright", 
       col = mycol[2:length(df)],
       bty="n")
dev.off()
