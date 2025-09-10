# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages("forestplot")
library("forestplot")
#读取输入文件，输入数据一般包括分类、样本数、风险比及置信区间（上限及下限）等，需要注意的是输入文件的布局(包括文字缩进)将展示在最后结果中，所见即所得。
#Read the input file, the input data generally includes classification, sample size, hazard ratio and confidence interval (upper and lower limits), etc. It should be noted that the layout of the input file (including text indentation) will be displayed in the final results, what you see is what you get.
data <- read.csv("easy_input.csv", stringsAsFactors=FALSE)
head(data)
np <- ifelse(!is.na(data$Count), paste(data$Count," (",data$Percent,")",sep=""), NA)#合并count和percent，这一步非必要 Merge count and percent, this step is not necessary
head(np)
tabletext <- cbind(c("\nSubgroup",NA,NA,data$Variable,NA),
                   c("No. of\nPatients (%)",NA,NA,np,NA),
                   c("Hazard Ratio\n(95% CI)",NA,NA,ifelse(!is.na(data$Count), paste(format(data$Point.Estimate,nsmall=2)," (",format(data$Low,nsmall = 2)," to ",format(data$High,nsmall = 2),")",sep=""), NA),NA),
                   #c("P-value", NA, NA, ifelse(data$P < 0.001, "<0.001", round(data$P,3)), NA))
                   c("P-value", NA, NA, data$P, NA)) #如果没有pvalue，就删掉这行 If there is no p-value, delete this line
head(tabletext)
