# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
BiocManager::install("randomForest")

#install.packages("Ckmeans.1d.dp")
#Error in install.packages : ERROR: failed to lock directory ‘C:\Users\96251\Documents\R\win-library\4.1’ for modifying
#install.packages("Ckmeans.1d.dp")
#Error in install.packages : ERROR: failed to lock directory ‘C:\Users\96251\Documents\R\win-library\4.1’ for modifying
#Try removing the ‘00LOCK’ folder at the specified path (e.g., C:\Users\96251\Documents\R\win-library\4.1/)
matrix <- sparse.model.matrix(group ~ .-1, data = data)
label <- as.numeric(ifelse(data$group=="NR", 0, 1))
fin <- list(data=matrix,label=label) 
dmatrix <- xgb.DMatrix(data = fin$data, label = fin$label) 
               objective='binary:logistic', nround=25)
xgb.importance <- xgb.importance(matrix@Dimnames[[2]], model = xgb)  
head(xgb.importance)
write.table(xgb.importance, "output_importance_XGBoost.txt", col.names = T, row.names = T, sep = "\t", quote = F)
pdf("XGBoost.pdf", width = 5, height = 5)
xgb.ggplot.importance(xgb.importance)
dev.off()
