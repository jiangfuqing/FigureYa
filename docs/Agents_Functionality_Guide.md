# FigureYa Agents功能使用指南 / Agents Functionality User Guide

## 概述 / Overview

FigureYa框架中的"Agents功能"是指**therapeutic agents (治疗性药物)分析功能**，这是一套完整的药物发现和药物作用机制分析工具。本指南将详细介绍如何使用这些功能进行药物筛选、作用机制分析和可视化。

The "Agents Functionality" in the FigureYa framework refers to **therapeutic agents analysis capabilities**, which is a comprehensive set of tools for drug discovery and mechanism of action analysis. This guide provides detailed instructions on how to use these features for drug screening, mechanism analysis, and visualization.

## 主要组件 / Main Components

### 1. CMap (Connectivity Map) 分析
- **FigureYa131CMap_update**: 基础CMap分析和作用机制研究
- **FigureYa213customizeHeatmap**: 定制化热图显示多源数据证据

### 2. 药物敏感性分析 / Drug Sensitivity Analysis
- **FigureYa212drugTargetV2**: 药物靶点和敏感性分析
- **FigureYa294HCCdrug**: 特定癌种的药物分析

---

## 快速开始 / Quick Start

### 前置要求 / Prerequisites

```r
# 安装必需的R包 / Install required R packages
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")

# 基础包 / Basic packages
install.packages(c("tidyverse", "devtools", "xlsx", "circlize"))

# Bioconductor包 / Bioconductor packages
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(c("ComplexHeatmap", "GEOquery", "limma"))

# GitHub版ComplexHeatmap (推荐) / GitHub version ComplexHeatmap (recommended)
devtools::install_github("jokergoo/ComplexHeatmap")
```

---

## 功能模块详解 / Detailed Module Guide

## 1. CMap连接性图谱分析 / CMap Connectivity Map Analysis

### 📂 使用模块: FigureYa131CMap_update

#### 🎯 应用场景 / Use Cases
- 基于差异表达基因寻找潜在靶向药物
- 癌症干性特征的药物抑制剂发现
- 机制研究和药物重定位

#### 📋 输入数据 / Input Data
1. **差异表达基因列表** / Differential gene expression list
2. **基因注释信息** (GPL96 platform)
3. **癌症类型数据** / Cancer type data

#### 🔧 工作流程 / Workflow

##### Step 1: 准备差异表达基因数据
```r
# 示例：从TCGA数据计算差异表达基因
library(limma)
library(GEOquery)

# 获取GPL96注释平台
GPL96 <- getGEO("GPL96", destdir = getwd())
GPL96 <- Table(GPL96)[, c("ID", "Gene Symbol")]

# 读取您的表达数据
expr_data <- read.table("your_expression_data.txt", header=T, row.names=1)

# 进行差异表达分析
# (详细代码见FigureYa131CMap_update.Rmd)
```

##### Step 2: 生成CMap查询文件
```r
# 选择top500上调和下调基因
ngene <- 500
degs <- na.omit(resData[order(resData$log2fc, decreasing = T),])
updegs <- rownames(degs)[1:ngene]
dndegs <- rownames(degs)[(nrow(degs)-ngene + 1):nrow(degs)]

# 生成grp格式文件用于CMap查询
write.table(updegs, "upregulated_genes.grp", 
           row.names = F, sep = "\t", quote = F, col.names = F)
write.table(dndegs, "downregulated_genes.grp", 
           row.names = F, sep = "\t", quote = F, col.names = F)
```

##### Step 3: CMap网站查询
1. 访问 [CMap Build 02](https://portals.broadinstitute.org/cmap/) 或 [CLUE.io](https://clue.io/)
2. 上传上调和下调基因列表
3. 下载查询结果

##### Step 4: 结果可视化
```r
library(ComplexHeatmap)
library(circlize)

# 读取CMap查询结果
cmap_results <- read.table("CMap_results.txt", header=T, sep="\t")

# 筛选显著富集的化合物 (p < 0.05)
significant_compounds <- cmap_results[cmap_results$p < 0.05, ]

# 创建热图矩阵
heatmap_matrix <- create_heatmap_matrix(significant_compounds)

# 绘制热图
col_fun <- colorRamp2(c(-1, 0, 1), c("#377EB8", "white", "#E41A1C"))
heatmap <- Heatmap(heatmap_matrix, col = col_fun, name = "Enrichment Score")
```

#### 📊 输出结果 / Output
- **CMap_heatmap.pdf**: 化合物富集得分热图
- **MoA.pdf**: 作用机制分析图
- **compound_list.txt**: 候选化合物列表

---

## 2. 多源证据药物筛选 / Multi-Source Evidence Drug Screening

### 📂 使用模块: FigureYa213customizeHeatmap

#### 🎯 应用场景 / Use Cases
- 整合多个数据库的药物筛选结果
- 可视化不同证据来源的支持程度
- 识别最有前景的治疗药物

#### 📋 四种证据类型 / Four Types of Evidence

1. **证据1&2**: PRISM和CTRP药物敏感性数据
2. **证据3**: CMap分析结果
3. **证据4**: 药物靶点表达水平变化
4. **证据5**: PubMed文献支持证据

#### 🔧 工作流程 / Workflow

##### Step 1: 收集多源数据
```r
# 从不同来源收集数据
prism_data <- read.table("PRISM_sensitivity.txt", header=T)
ctrp_data <- read.table("CTRP_sensitivity.txt", header=T)
cmap_data <- read.table("CMap_results.txt", header=T)
target_expr <- read.table("target_expression.txt", header=T)
```

##### Step 2: 数据整合和标准化
```r
# 整合不同数据源
integrated_data <- merge_multiple_sources(
  prism = prism_data,
  ctrp = ctrp_data,
  cmap = cmap_data,
  targets = target_expr
)

# 标准化评分
normalized_scores <- normalize_drug_scores(integrated_data)
```

##### Step 3: 创建定制化热图
```r
# 准备热图数据
drug_candidates <- c("BI-2536", "Leptomycin B", "methotrexate", 
                    "narciclasine", "SR-II-138A", "vincristine")

# 构建热图矩阵
dt <- create_custom_heatmap_matrix(normalized_scores, drug_candidates)

# 设置颜色和标签
colors <- list(
  evidence1 = "#E41A1C",  # PRISM
  evidence2 = "#377EB8",  # CTRP  
  evidence3 = "#4DAF4A",  # CMap
  evidence4 = "#984EA3"   # Target expression
)

# 绘制定制化热图
custom_heatmap <- create_evidence_heatmap(dt, colors)
```

#### 📊 输出结果 / Output
- **heatmap.pdf**: 多源证据整合热图
- **drug_ranking.txt**: 药物候选排名
- **evidence_summary.csv**: 证据总结表

---

## 3. 药物靶点分析 / Drug Target Analysis

### 📂 使用模块: FigureYa212drugTargetV2

#### 🎯 应用场景 / Use Cases
- 药物敏感性与基因表达关联分析
- 患者分层和个性化治疗
- 药物作用靶点验证

#### 🔧 核心功能 / Core Features

##### PPS评分计算 / PPS Score Calculation
```r
# 计算患者优先评分(Patient Prioritization Score)
calculate_pps_score <- function(expression_data, drug_sensitivity) {
  # 基于基因表达谱计算PPS评分
  pps_scores <- compute_patient_scores(expression_data)
  return(pps_scores)
}
```

##### 药物敏感性分析 / Drug Sensitivity Analysis
```r
# 分析高PPS评分患者的药物敏感性
analyze_drug_sensitivity <- function(pps_scores, drug_data) {
  high_pps_patients <- pps_scores[pps_scores > median(pps_scores)]
  sensitivity_results <- correlate_drugs_with_pps(high_pps_patients, drug_data)
  return(sensitivity_results)
}
```

---

## 4. 机制作用分析 / Mechanism of Action Analysis

### 🎯 MoA分析流程 / MoA Analysis Workflow

#### Step 1: 收集靶点信息
```r
# 从CLUE数据库获取药物靶点信息
drug_targets <- get_drug_targets_from_clue()
mechanism_data <- get_mechanism_of_action()
```

#### Step 2: 通路富集分析
```r
# 分析药物作用通路
pathway_enrichment <- analyze_drug_pathways(drug_targets)
shared_mechanisms <- find_shared_mechanisms(mechanism_data)
```

#### Step 3: 网络可视化
```r
# 创建药物-靶点-通路网络图
drug_network <- create_drug_target_network(
  drugs = candidate_drugs,
  targets = drug_targets,
  pathways = pathway_enrichment
)
```

---

## 实用技巧和最佳实践 / Tips and Best Practices

### ✅ 数据准备建议 / Data Preparation Tips

1. **基因ID转换**: 确保使用正确的基因ID格式
```r
# GPL96平台ID转换
convert_gene_ids <- function(gene_list, from="SYMBOL", to="PROBEID") {
  # 使用biomaRt或org.Hs.eg.db进行ID转换
}
```

2. **数据质量控制**: 检查和过滤低质量数据
```r
# 移除表达量过低的基因
filter_low_expression <- function(expr_data, threshold=1) {
  keep_genes <- rowMeans(expr_data) > threshold
  return(expr_data[keep_genes, ])
}
```

3. **批次效应校正**: 处理不同数据源的批次效应
```r
library(sva)
# 使用ComBat进行批次校正
corrected_data <- ComBat(dat=expr_data, batch=batch_info)
```

### ⚙️ 参数优化建议 / Parameter Optimization

1. **基因数量选择**: 
   - CMap Build 02: 最多1000个基因 (500上调 + 500下调)
   - CLUE.io: 最多300个基因 (150上调 + 150下调)

2. **显著性阈值**: 
   - p-value < 0.05 (基础筛选)
   - FDR < 0.1 (严格筛选)

3. **富集得分解读**:
   - 正值: 药物引起的基因表达变化与疾病相似
   - 负值: 药物引起的基因表达变化与疾病相反(治疗潜力)

---

## 故障排除 / Troubleshooting

### ❗ 常见问题 / Common Issues

#### 问题1: CMap查询失败
**可能原因**: 基因ID格式不正确
**解决方案**: 
```r
# 检查基因ID格式
check_gene_format <- function(gene_list) {
  # 确保使用GPL96平台的probe ID
  valid_ids <- gene_list %in% GPL96$ID
  return(sum(valid_ids) / length(gene_list))
}
```

#### 问题2: 热图显示异常
**可能原因**: 数据矩阵包含NA值或无穷值
**解决方案**:
```r
# 清理数据矩阵
clean_matrix <- function(mat) {
  mat[is.na(mat)] <- 0
  mat[is.infinite(mat)] <- 0
  return(mat)
}
```

#### 问题3: 包安装失败
**可能原因**: 网络连接或依赖问题
**解决方案**:
```r
# 使用国内镜像
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")

# 手动安装依赖
install.packages("依赖包名", dependencies = TRUE)
```

---

## 参考资源 / References

### 📚 相关文献 / Related Publications
1. Lamb, J. et al. The Connectivity Map: using gene-expression signatures to connect small molecules, genes, and disease. Science (2006)
2. Subramanian, A. et al. A Next Generation Connectivity Map: L1000 Platform and the First 1,000,000 Profiles. Cell (2017)

### 🔗 有用链接 / Useful Links
- [CMap Build 02](https://portals.broadinstitute.org/cmap/)
- [CLUE.io](https://clue.io/)
- [GDSC Database](https://www.cancerrxgene.org/)
- [CTRP Database](https://portals.broadinstitute.org/ctrp/)

### 📖 FigureYa相关模块 / Related FigureYa Modules
- **FigureYa105GDSC**: GDSC数据库药物敏感性分析
- **FigureYa145target**: 药物靶点可视化
- **FigureYa147interaction**: 药物-靶点相互作用网络

---

## 引用说明 / Citation

如果您在研究中使用了FigureYa的Agents功能，请引用:

If you use FigureYa's Agents functionality in your research, please cite:

```
FigureYa: A Standardized Visualization Framework for Enhancing Biomedical Data Interpretation and Research Efficiency
DOI: https://doi.org/10.1002/imm3.70005
```

---

## 获取帮助 / Getting Help

- **GitHub Issues**: [FigureYa Issues](https://github.com/ying-ge/FigureYa/issues)
- **在线文档**: [FigureYa Documentation](https://ying-ge.github.io/FigureYa/)
- **社区讨论**: 欢迎在GitHub Discussions中提问

---

*最后更新 / Last Updated: 2025-01-16*