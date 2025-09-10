# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages("pheatmap")
require(pheatmap)
df<-read.table("easy_input.txt",header = T, row.names = 1,as.is = 1)
annotation_col = data.frame(group = factor(rep(c("group1","group2"),c(6,12))))
rownames(annotation_col) = colnames(df)
ann_colors = list(Stage = c(group1 = "#FFFFCC", group2 = "#FEFF23"))
p1<-pheatmap(df,method="spearman", cluster_rows=T, cluster_cols=T,
         color = colorRampPalette(c("navy", "white", "firebrick3"))(20),
         scale="row", show_colnames=F,
         annotation_colors = ann_colors)
pdf(file="heatmap.pdf")
dev.off()

#install.packages(c("seqinr","ape"))
require(seqinr)
myAlignment <- msaConvert(myFirstAlignment, type="seqinr::alignment")
d <- dist.alignment(myAlignment, "identity")
require(ape)
tree <- nj(d)
require(ggtree)
p2 <- ggtree(tree, layout='circular') + geom_tiplab2(size=3, offset=.1) + xlim(-.2, 3) 
pdf(file="ggtree.pdf")
dev.off()
