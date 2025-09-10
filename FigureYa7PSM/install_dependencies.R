# Auto-generated package installation script
# Extracted from R Markdown file

#install.packages("wakefield")
library(wakefield)
set.seed(1234)
                                name = 'Age'), 
                            sex(x = c("Male", "Female"), 
                                prob = c(0.70, 0.30), 
                                name = "Sex"))
df.patients$Sample <- as.factor('CASE')
df.patients$ID<-paste("CASE",rownames(df.patients),sep = "")
summary(df.patients)

#install.packages("MatchIt")
library(MatchIt)
#To find the nearest age, use method='nearest'.
set.seed(1234)
match.it <- matchit(Group ~ Age + Sex, data = mydata, method="nearest", ratio=1)
plot(match.it, type = 'jitter', interactive = FALSE)
