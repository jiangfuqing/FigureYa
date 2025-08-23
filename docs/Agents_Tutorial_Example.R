# FigureYa Agents功能实例教程 / Agents Functionality Tutorial
# 本脚本演示如何使用FigureYa的药物分析功能
# This script demonstrates how to use FigureYa's drug analysis functionality

# ================================
# 环境设置 / Environment Setup
# ================================

# 设置国内镜像 / Set up domestic mirrors
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="http://mirrors.ustc.edu.cn/bioc/")

# 加载必需的包 / Load required packages
library(tidyverse)
library(limma)
library(ComplexHeatmap)
library(circlize)

# 设置工作环境 / Set up working environment
Sys.setenv(LANGUAGE = "en")
options(stringsAsFactors = FALSE)

# ================================
# 示例1: CMap连接性图谱分析
# Example 1: CMap Connectivity Map Analysis
# ================================

# Step 1: 模拟差异表达基因数据 / Simulate differential expression data
simulate_deg_data <- function(n_genes = 2000, n_samples = 100) {
  # 创建模拟表达矩阵
  set.seed(123)
  
  # 正常样本和肿瘤样本
  normal_samples <- 20
  tumor_samples <- 80
  
  # 生成基因表达数据
  expr_matrix <- matrix(
    rnorm(n_genes * n_samples, mean = 10, sd = 2),
    nrow = n_genes,
    ncol = n_samples
  )
  
  # 设置差异表达基因（前200个上调，后200个下调）
  expr_matrix[1:200, (normal_samples+1):n_samples] <- 
    expr_matrix[1:200, (normal_samples+1):n_samples] + 3
  
  expr_matrix[1801:2000, (normal_samples+1):n_samples] <- 
    expr_matrix[1801:2000, (normal_samples+1):n_samples] - 3
  
  # 添加行名和列名
  rownames(expr_matrix) <- paste0("Gene_", 1:n_genes)
  colnames(expr_matrix) <- c(
    paste0("Normal_", 1:normal_samples),
    paste0("Tumor_", 1:tumor_samples)
  )
  
  return(expr_matrix)
}

# Step 2: 差异表达分析 / Differential expression analysis
perform_deg_analysis <- function(expr_data) {
  # 创建样本信息
  sample_info <- data.frame(
    Sample = colnames(expr_data),
    Group = c(rep("Normal", 20), rep("Tumor", 80)),
    stringsAsFactors = FALSE
  )
  
  # 创建设计矩阵
  design <- model.matrix(~ -1 + factor(sample_info$Group, levels = c("Tumor", "Normal")))
  colnames(design) <- c("Tumor", "Normal")
  
  # 拟合线性模型
  fit <- lmFit(expr_data, design = design)
  
  # 创建对比矩阵
  contrast_matrix <- makeContrasts(Tumor - Normal, levels = c("Tumor", "Normal"))
  fit2 <- contrasts.fit(fit, contrasts = contrast_matrix)
  fit2 <- eBayes(fit2, 0.01)
  
  # 提取结果
  results <- topTable(fit2, adjust = "fdr", sort.by = "B", number = Inf)
  results$Gene <- rownames(results)
  colnames(results) <- c("log2FC", "AveExpr", "t", "pvalue", "padj", "B", "Gene")
  
  return(results)
}

# Step 3: 生成CMap输入文件 / Generate CMap input files
generate_cmap_input <- function(deg_results, n_genes = 150) {
  # 按log2FC排序
  deg_sorted <- deg_results[order(deg_results$log2FC, decreasing = TRUE), ]
  
  # 选择前150个上调基因和后150个下调基因
  up_genes <- head(deg_sorted$Gene, n_genes)
  down_genes <- tail(deg_sorted$Gene, n_genes)
  
  # 创建CMap输入格式
  cmap_input <- data.frame(
    up = up_genes,
    down = down_genes,
    stringsAsFactors = FALSE
  )
  
  # 保存文件
  write.table(cmap_input, "CMap_input_example.txt", 
              sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
  
  # 也保存为grp格式（CMap Build 02使用）
  write.table(up_genes, "upregulated_genes_example.grp", 
              row.names = FALSE, sep = "\t", quote = FALSE, col.names = FALSE)
  write.table(down_genes, "downregulated_genes_example.grp", 
              row.names = FALSE, sep = "\t", quote = FALSE, col.names = FALSE)
  
  cat("CMap输入文件已生成:\n")
  cat("- CMap_input_example.txt (CLUE.io格式)\n")
  cat("- upregulated_genes_example.grp (CMap Build 02格式)\n")
  cat("- downregulated_genes_example.grp (CMap Build 02格式)\n")
  
  return(list(up = up_genes, down = down_genes))
}

# Step 4: 模拟CMap查询结果并可视化 / Simulate CMap results and visualization
simulate_cmap_results <- function() {
  # 模拟CMap查询结果
  set.seed(456)
  
  # 模拟化合物名称
  compounds <- c(
    "BI-2536", "Leptomycin B", "methotrexate", "narciclasine", 
    "SR-II-138A", "vincristine", "paclitaxel", "doxorubicin",
    "5-fluorouracil", "cisplatin", "tamoxifen", "imatinib"
  )
  
  # 模拟多个癌症类型
  cancer_types <- c("BRCA", "LUAD", "COAD", "PRAD", "LIHC", "STAD")
  
  # 生成模拟结果
  cmap_results <- expand.grid(
    compound = compounds,
    cancer_type = cancer_types,
    stringsAsFactors = FALSE
  )
  
  # 添加模拟的富集得分和p值
  cmap_results$enrichment_score <- runif(nrow(cmap_results), -1, 1)
  cmap_results$p_value <- runif(nrow(cmap_results), 0.001, 0.1)
  
  # 筛选显著结果 (p < 0.05)
  significant_results <- cmap_results[cmap_results$p_value < 0.05, ]
  
  return(significant_results)
}

# Step 5: 创建CMap结果热图 / Create CMap results heatmap
create_cmap_heatmap <- function(cmap_results) {
  # 转换为矩阵格式
  heatmap_data <- cmap_results %>%
    select(compound, cancer_type, enrichment_score) %>%
    pivot_wider(names_from = cancer_type, values_from = enrichment_score) %>%
    column_to_rownames("compound") %>%
    as.matrix()
  
  # 处理NA值
  heatmap_data[is.na(heatmap_data)] <- 0
  
  # 设置颜色
  col_fun <- colorRamp2(c(-1, 0, 1), c("#377EB8", "white", "#E41A1C"))
  
  # 创建热图
  ht <- Heatmap(
    heatmap_data,
    col = col_fun,
    name = "Enrichment Score",
    show_row_names = TRUE,
    show_column_names = TRUE,
    cluster_rows = TRUE,
    cluster_columns = TRUE,
    row_names_gp = gpar(fontsize = 10),
    column_names_gp = gpar(fontsize = 10),
    heatmap_legend_param = list(
      title = "Enrichment\nScore",
      grid_width = unit(4, "mm"),
      grid_height = unit(4, "mm")
    )
  )
  
  # 保存热图
  pdf("CMap_example_heatmap.pdf", width = 8, height = 6)
  draw(ht, heatmap_legend_side = "right")
  dev.off()
  
  cat("CMap结果热图已保存为: CMap_example_heatmap.pdf\n")
  
  return(ht)
}

# ================================
# 示例2: 多源证据药物筛选
# Example 2: Multi-source Evidence Drug Screening
# ================================

# 模拟多源药物数据 / Simulate multi-source drug data
simulate_multi_source_data <- function() {
  drugs <- c("BI-2536", "Leptomycin B", "methotrexate", "narciclasine", "SR-II-138A", "vincristine")
  
  # 模拟不同数据源
  evidence_data <- data.frame(
    Drug = drugs,
    PRISM_Score = runif(length(drugs), -2, 2),
    CTRP_Score = runif(length(drugs), -2, 2),
    CMap_Score = runif(length(drugs), -1, 1),
    Target_Expression = runif(length(drugs), 0.5, 3),
    Literature_Evidence = sample(0:5, length(drugs), replace = TRUE),
    stringsAsFactors = FALSE
  )
  
  return(evidence_data)
}

# 创建多源证据热图 / Create multi-source evidence heatmap
create_evidence_heatmap <- function(evidence_data) {
  # 准备数据矩阵
  drug_matrix <- evidence_data %>%
    column_to_rownames("Drug") %>%
    as.matrix()
  
  # 标准化数据（每列独立标准化）
  drug_matrix_scaled <- scale(drug_matrix)
  
  # 创建注释
  evidence_types <- colnames(drug_matrix_scaled)
  colors <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00")
  names(colors) <- evidence_types
  
  # 创建复合热图
  col_fun <- colorRamp2(c(-2, 0, 2), c("#377EB8", "white", "#E41A1C"))
  
  ht <- Heatmap(
    drug_matrix_scaled,
    col = col_fun,
    name = "Evidence Score\n(Standardized)",
    show_row_names = TRUE,
    show_column_names = TRUE,
    cluster_rows = FALSE,
    cluster_columns = FALSE,
    column_title = "Multi-source Drug Evidence",
    row_names_gp = gpar(fontsize = 12),
    column_names_gp = gpar(fontsize = 10),
    rect_gp = gpar(col = "white", lwd = 1),
    heatmap_legend_param = list(
      title = "Evidence\nScore",
      grid_width = unit(4, "mm"),
      grid_height = unit(4, "mm")
    )
  )
  
  # 保存热图
  pdf("Multi_source_evidence_heatmap.pdf", width = 10, height = 6)
  draw(ht, heatmap_legend_side = "right")
  dev.off()
  
  cat("多源证据热图已保存为: Multi_source_evidence_heatmap.pdf\n")
  
  return(ht)
}

# ================================
# 示例3: 药物作用机制分析
# Example 3: Mechanism of Action Analysis
# ================================

# 模拟MoA数据 / Simulate MoA data
simulate_moa_data <- function() {
  drugs <- c("BI-2536", "Leptomycin B", "methotrexate", "narciclasine", 
             "paclitaxel", "doxorubicin", "5-fluorouracil", "cisplatin")
  
  mechanisms <- c("Cell cycle inhibitor", "Nuclear export inhibitor", 
                  "DNA synthesis inhibitor", "Protein synthesis inhibitor",
                  "Microtubule stabilizer", "DNA intercalator",
                  "Antimetabolite", "DNA crosslinker")
  
  moa_data <- data.frame(
    Drug = drugs,
    Mechanism = mechanisms,
    Target_Pathway = c("PLK1", "CRM1", "DHFR", "Ribosome",
                      "Tubulin", "DNA", "Thymidine synthase", "DNA"),
    stringsAsFactors = FALSE
  )
  
  return(moa_data)
}

# 创建MoA网络图 / Create MoA network plot
create_moa_visualization <- function(moa_data) {
  # 这里使用简化的表格展示，实际应用中可以使用网络图
  
  # 按机制分组
  moa_summary <- moa_data %>%
    group_by(Mechanism) %>%
    summarise(
      Drugs = paste(Drug, collapse = ", "),
      Targets = paste(unique(Target_Pathway), collapse = ", "),
      .groups = "drop"
    )
  
  # 保存结果
  write.csv(moa_summary, "MoA_analysis_results.csv", row.names = FALSE)
  
  cat("药物作用机制分析结果已保存为: MoA_analysis_results.csv\n")
  cat("\n机制作用总结:\n")
  print(moa_summary)
  
  return(moa_summary)
}

# ================================
# 主执行函数 / Main execution function
# ================================

run_agents_tutorial <- function() {
  cat("=== FigureYa Agents功能教程开始 ===\n\n")
  
  # 1. CMap分析示例
  cat("1. 执行CMap连接性图谱分析...\n")
  expr_data <- simulate_deg_data()
  deg_results <- perform_deg_analysis(expr_data)
  cmap_input <- generate_cmap_input(deg_results)
  cmap_results <- simulate_cmap_results()
  cmap_heatmap <- create_cmap_heatmap(cmap_results)
  
  cat("\n")
  
  # 2. 多源证据分析示例
  cat("2. 执行多源证据药物筛选...\n")
  evidence_data <- simulate_multi_source_data()
  evidence_heatmap <- create_evidence_heatmap(evidence_data)
  
  cat("\n")
  
  # 3. MoA分析示例
  cat("3. 执行药物作用机制分析...\n")
  moa_data <- simulate_moa_data()
  moa_results <- create_moa_visualization(moa_data)
  
  cat("\n=== 教程完成 ===\n")
  cat("生成的文件:\n")
  cat("- CMap_input_example.txt\n")
  cat("- upregulated_genes_example.grp\n")
  cat("- downregulated_genes_example.grp\n")
  cat("- CMap_example_heatmap.pdf\n")
  cat("- Multi_source_evidence_heatmap.pdf\n")
  cat("- MoA_analysis_results.csv\n")
  
  # 返回结果供进一步分析
  return(list(
    deg_results = deg_results,
    cmap_results = cmap_results,
    evidence_data = evidence_data,
    moa_data = moa_data
  ))
}

# ================================
# 运行教程 / Run tutorial
# ================================

# 取消注释下面这行来运行完整教程
# results <- run_agents_tutorial()

cat("教程脚本已加载完毕。\n")
cat("运行 'results <- run_agents_tutorial()' 来执行完整的Agents功能演示。\n")