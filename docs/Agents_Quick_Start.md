# FigureYa Agents功能快速入门 / Quick Start Guide for Agents Functionality

## 什么是Agents功能？/ What is Agents Functionality?

FigureYa的**Agents功能**专门用于**治疗性药物分析**，包括：
- 🔍 **药物发现** (Drug Discovery)
- 🎯 **靶点分析** (Target Analysis)  
- 🧬 **作用机制研究** (Mechanism of Action)
- 📊 **多源数据整合** (Multi-source Data Integration)

## 核心模块 / Core Modules

| 模块 | 功能 | 适用场景 |
|------|------|----------|
| **FigureYa131CMap_update** | CMap连接性图谱分析 | 基于基因表达寻找候选药物 |
| **FigureYa213customizeHeatmap** | 多源证据整合 | 整合多个数据库结果 |
| **FigureYa212drugTargetV2** | 药物敏感性分析 | 患者分层和个性化治疗 |

## 5分钟快速开始 / 5-Minute Quick Start

### 步骤1: 环境准备 / Environment Setup
```r
# 安装必需包 / Install required packages
install.packages(c("tidyverse", "ComplexHeatmap", "circlize"))

# 加载包 / Load packages  
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
```

### 步骤2: 准备数据 / Prepare Data
```r
# 示例：准备差异表达基因列表 / Example: Prepare DEG list
upregulated_genes <- c("TP53", "BRCA1", "MYC", "EGFR", "KRAS")  # 上调基因
downregulated_genes <- c("APC", "RB1", "PTEN", "ATM", "MLH1")   # 下调基因

# 保存为CMap输入格式 / Save as CMap input format
deg_input <- data.frame(
  up = upregulated_genes,
  down = downregulated_genes
)
write.table(deg_input, "CMap_input.txt", sep="\t", row.names=F, quote=F)
```

### 步骤3: CMap查询 / CMap Query
1. 访问 [CLUE.io](https://clue.io/) 或 [CMap Build 02](https://portals.broadinstitute.org/cmap/)
2. 上传基因列表文件
3. 下载查询结果

### 步骤4: 结果可视化 / Result Visualization
```r
# 模拟CMap结果 / Simulate CMap results
cmap_results <- data.frame(
  compound = c("BI-2536", "methotrexate", "vincristine"),
  enrichment_score = c(-0.85, -0.62, -0.75),
  p_value = c(0.001, 0.005, 0.003)
)

# 创建简单条形图 / Create simple bar plot
library(ggplot2)
ggplot(cmap_results, aes(x=compound, y=enrichment_score, fill=p_value<0.05)) +
  geom_col() +
  coord_flip() +
  theme_minimal() +
  labs(title="候选药物富集得分", x="化合物", y="富集得分")
```

## 典型应用场景 / Typical Use Cases

### 🎯 场景1: 寻找癌症治疗药物
```r
# 1. 获取肿瘤vs正常的差异基因
# 2. 提交CMap查询
# 3. 筛选负富集得分的化合物（治疗潜力）
# 4. 验证文献支持
```

### 🔬 场景2: 药物重定位研究  
```r
# 1. 分析现有药物的基因表达谱
# 2. 寻找具有相似模式的疾病
# 3. 预测新的治疗适应症
```

### 🧬 场景3: 作用机制研究
```r
# 1. 收集候选药物列表
# 2. 查询靶点信息
# 3. 分析共同作用通路
# 4. 绘制机制网络图
```

## 文件结构说明 / File Structure

```
FigureYa131CMap_update/           # CMap分析模块
├── FigureYa131CMap_update.Rmd    # 主分析脚本
├── example.png                   # 参考图片
├── CMap_heatmap.pdf              # 输出热图
└── moa_target_export.txt         # 靶点信息

FigureYa213customizeHeatmap/      # 定制热图模块  
├── FigureYa213customizeHeatmap.Rmd
├── CMap_input.txt                # CMap输入
├── CMap_export.txt               # CMap输出
└── heatmap.pdf                   # 最终热图
```

## 常用参数设置 / Common Parameter Settings

### CMap查询参数 / CMap Query Parameters
- **基因数量**: CLUE.io最多300个 (150上调+150下调)
- **平台选择**: GPL96 (Affymetrix Human Genome U133A Array)
- **显著性阈值**: p < 0.05

### 可视化参数 / Visualization Parameters
```r
# 热图颜色设置 / Heatmap color settings
col_fun <- colorRamp2(c(-1, 0, 1), c("blue", "white", "red"))

# 基本热图参数 / Basic heatmap parameters
Heatmap(data, 
        col = col_fun,
        name = "Enrichment Score",
        show_row_names = TRUE,
        cluster_rows = TRUE)
```

## 结果解读 / Result Interpretation

### 富集得分含义 / Enrichment Score Meaning
- **正值 (+)**: 药物使基因表达变化与疾病**相同方向** → 可能加重疾病
- **负值 (-)**: 药物使基因表达变化与疾病**相反方向** → 具有**治疗潜力**

### 显著性评估 / Significance Assessment
- **p < 0.05**: 基础筛选标准
- **p < 0.01**: 高可信度候选
- **|enrichment_score| > 0.5**: 强效应化合物

## 下一步 / Next Steps

1. **深入学习**: 查看完整教程 `docs/Agents_Functionality_Guide.md`
2. **实践操作**: 运行示例脚本 `docs/Agents_Tutorial_Example.R`  
3. **真实数据**: 使用自己的基因表达数据
4. **结果验证**: 查询文献验证候选药物

## 获取帮助 / Get Help

- 📖 **完整文档**: `/docs/Agents_Functionality_Guide.md`
- 💻 **示例代码**: `/docs/Agents_Tutorial_Example.R`
- 🔗 **在线文档**: [FigureYa官网](https://ying-ge.github.io/FigureYa/)
- ❓ **问题反馈**: [GitHub Issues](https://github.com/ying-ge/FigureYa/issues)

---
*创建时间: 2025-01-16 | 适用版本: FigureYa v1.0+*