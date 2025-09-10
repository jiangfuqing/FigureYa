# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
install.packages("ggthemes")

#install.packages("networkD3")
library(magrittr)
library(networkD3)
                       group= as.factor(nodes$Global_Cluster))
linkData <- data.frame(source = (match(networkData$specificSubtype, nodeData$name)-1),
                       target = (match(networkData$otherSubtype, nodeData$name)-1))
  Source = "source",
  Target = "target",
  NodeID = "name",Group = "group", legend = T, opacityNoHover = 1,zoom=T)
