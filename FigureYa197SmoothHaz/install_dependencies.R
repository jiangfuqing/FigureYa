# Auto-generated package installation script
# Extracted from R Markdown file

options("repos"= c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.tuna.tsinghua.edu.cn/bioconductor/")
install.packages("muhaz")
install.packages("export")
install.packages(c("rvg", "flextable", "rgl", "stargazer"))
install.packages("export_0.2.2.tar.gz", repos = NULL, type = "source")

# install.packages("extrafont")
# install.packages("extrafontdb")
#install.packages("extrafont_0.19.tar.gz")
#install.packages("extrafontdb_1.0.tar.gz")
library(extrafont)
library(extrafontdb)
# font_import() # 导入字体，这个过程需要几分钟 # Import fonts, the process takes a few minutes
# loadfonts(device = "win") #加载字体 # Load font
# windowsFonts(Arial = windowsFont('Arial'))        
orange <- "#EB292A"
blue <- "#2271B4"
p1 <- ggplot(smoothhazp, aes(x=Months, y=Hazard, colour= factor(Subgroup,labels = c("Male","Female")))) +
  geom_line() + ggtitle("Kernel-smoothing hazard function plot")+
  #scale_color_brewer(palette = "Set1") + #用色板配色 # Match colors with color swatches
  scale_color_manual(values = c(blue, orange)) + #自己设置颜色代码 # Set the color code yourself
  theme_classic() +                        # 设置主题 # Set up a theme
  theme(plot.title = element_text(hjust=-0.1,size=8,vjust=0.2,face = "bold"), # 调整标题位置 # Adjust the position of the title
        axis.text = element_text(size=8,#family='Arial'
                                 ,colour="black"),  # 坐标轴文字 # Axis text
        axis.title = element_text(size=8,#family='Arial'
                                  ,colour="black"), # 坐标轴标题 # Axis title
        legend.title = element_blank(),                                  # 删除图例标题 #Delete the legend title
        legend.position = c(0.8,0.9)) +
  scale_x_continuous(name = "",breaks = seq(0,72,12)) #设置x轴刻度，与risk table一致 # Set the X-axis scale to be consistent with the risk table
