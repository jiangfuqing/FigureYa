# Auto-generated package installation script
# Extracted from R Markdown file

if(!require(caret))(install.packages(caret))
set.seed(121)
samdata<- createDataPartition(clin_mRNA_miRNA$`EVENT`, p=0.7, list=F)
summary(valid)
sur2<-Surv(time=valid$`OS`,event = valid$`EVENT`)#数据集需要修改 dataset needs to be modified
univarcox<- function(x){
  formu<-as.formula(paste0('sur2~',x))
  unicox<-coxph(formu,data=valid)##数据集更改 dataset modification
  unisum<-summary(unicox)#汇总数据 summarize data
  HR<-round(unisum$coefficients[,2],3)# HR风险比 HR hazard rate
  CI95<-paste0(round(unisum$conf.int[,c(3,4)],3),collapse = '-') #95%置信区间 95% confidence interval
  univarcox<-data.frame('characteristics'=x,
                        'Hazard Ration'= HR,
                        'CI95'= CI95,
                        'pvalue'= ifelse(Pvalue < 0.001, "< 0.001", round(Pvalue,3)))
  return(univarcox)#返回数据表 return to dataframe
(variable_names<-colnames(valid)[c(2:9,12,13)])
univar<-lapply(variable_names,univarcox)
univartable<-do.call(rbind,lapply(univar,data.frame))
univartable$`HR(95%CI)`<-paste0(univartable$Hazard.Ration,'(',univartable$CI95,')')
univartable2<-dplyr::select(univartable,characteristics,`HR(95%CI)`,pvalue,-CI95,-Hazard.Ration)
(names2<-as.character(univartable2$characteristics[univartable2$pvalue<0.05]))
(form<-as.formula(paste0('sur2~',paste0(names2,collapse = '+'))))
multicox<-coxph(formula = form,data = valid)#数据集需要更改 dataset needs to be modified
multisum<-summary(multicox)##汇总 summarize
muHR<-round(multisum$coefficients[,2],3)#风险比 hazard rate
muCIdown<-round(multisum$conf.int[,3],3)#下 down
muCIup<-round(multisum$conf.int[,4],3)#上 up
muCI<-paste0(muCIdown,'-',muCIup)##95%置信区间 95% confidence interval
multicox2<-data.frame('characteristics'=names2,
                     'muHazard Ration'=muHR,
                     'muCI95'=muCI,
                     'mupvalue'=ifelse(muPvalue < 0.001, "< 0.001", round(muPvalue,3)))
rownames(multicox2)<-NULL
multicox2$`HR(95%CI)`<-paste0(multicox2$muHazard.Ration,'(',multicox2$muCI95,')')
multicox2<-dplyr::select(multicox2,characteristics,`HR(95%CI)`,mupvalue,-muCI95,-muHazard.Ration)
uni_multi2<-dplyr::full_join(univartable2,multicox2,by="characteristics")
uni_multi2$characteristics <- as.character(uni_multi2$characteristics)

if(!require(officer)) (install.packages('officer'))
library(officer)
my_doc <- read_docx()  #初始化一个docx initialize a docx
  body_add_par(value = title_name, style = "table title") %>%
  body_add_table(value = table1, style = "Light List Accent 2" ) %>% 
  body_add_par(value = mynote) %>% 
  print(target = "Table2.docx")
read_docx() %>% styles_info() %>% 
  subset( style_type %in% "table" )
