# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages("circlize")
#install.packages("stringi")
library(stringi)
library(circlize)
pdf("circlize.pdf",width = 8,height = 6)
par(mar=rep(0,4))
circos.clear()
           track.margin = c(0,0.15), #gap.degree规定了左右，track.margin规定上下 gap.degree specifies left and right, track.margin specifies top and bottom
           cell.padding = c(0,0,0,0) #？
           )
#### 根据"Gene_ID.txt"画组
                  xlim = cbind(GeneID$Gene_Start, GeneID$Gene_End))
circos.trackPlotRegion(ylim = c(0, 1), factors = GeneID$GeneID, track.height=0.1,
                       panel.fun = function(x, y) {
                         name = get.cell.meta.data("sector.index") 
                         i = get.cell.meta.data("sector.numeric.index") 
                         xlim = get.cell.meta.data("xlim")
                         ylim = get.cell.meta.data("ylim")
                         circos.text(x = mean(xlim), 
                                     #col = "darkgrey", #组ID的颜色 group ID color
                                     adj = c(0.5,-0.8)
                                     #facing = "reverse.clockwise",
                                     #adj = c(1.5, -0.8) #组ID的位置 location of group ID
                                     )
                                     col = "white",
                                     border = NA)
                         })
#### 根据"Gene_feature.txt"画亚组
#The requester also wants each square in the circle chart to have a different color, displaying a rainbow effect overall, similar to the effect in circlize_rainbow.pdf. Just replace the line "col = ..." in the for loop below with "col = bgcol[i], ".
library(graphics)
bgcol <- rainbow(sum(GeneID$Gene_End), s = 1, v = 1, start = 0, end = max(1, sum(GeneID$Gene_End) - 1)/sum(GeneID$Gene_End), alpha = 1)
for (i in 1:nrow(GeneFe)){
  ylim = c(0, 1)
              col = paste("#", GeneFe$bar_col[i], sep = ""), 
              border = "black")
for (i in 1:nrow(GeneFe)){
  ylim = c(0, 1)
              facing = "inside",
              cex = 0.8)
#### 根据"Links.txt"画连线
for(i in 1:nrow(Links)){
              col = paste("#", Links$link_col[i], sep = ""), 
              #If you don't want to write the color in the input file, you can also run the following line and specify the color here
              #col = "red", 
              rou = 0.7, #连线起始和终止点的y值（圆半径的百分比） y-value of the start and end points of the line (percentage of circle radius)
  )
GeneCol<-data.frame(legendID=GeneFe$GeneID,legendCol=GeneFe$bar_col)
GeneCol_uniq<-base::unique(GeneCol) 
       bty = "n",#不要边框 no borders
       col = paste0("#",GeneCol_uniq$legendCol),
       horiz = FALSE)
LinksCol<-data.frame(Links$link_col)
LinksCol_uniq<-base::unique(LinksCol) 
       bty = "n",
       legend = c("Pos.","Neg."),
       col = paste0("#",LinksCol_uniq$Links.link_col),
       horiz = FALSE)
dev.off()
