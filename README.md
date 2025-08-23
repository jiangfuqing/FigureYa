# FigureYa: A Standardized Visualization Framework for Enhancing Biomedical Data Interpretation and Research Efficiency

This repository provides the complete set of input files, analysis code, and results from the FigureYa manuscript.

## 🔎 Interactive Results Browser

All generated reports are hosted on a dedicated webpage, featuring a powerful full-text search.

**[https://ying-ge.github.io/FigureYa/](https://ying-ge.github.io/FigureYa/)**

**Note:** The initial page load may be slow depending on your network. Please allow a few seconds for the content to appear.

### Using the Search
The primary feature is the **search box** at the top of the page. You can use it to perform a full-text search across all HTML reports. The search results will display:
*   A snippet of **context** showing where your keyword appears.
*   A direct **link** to the specific FigureYa report containing the term.

This allows you to quickly pinpoint relevant information (e.g., a specific function name, R package, analysis title, or figure) across all FigureYa files.

### Manual Browsing
Alternatively, you can manually browse the reports by clicking on the thumbnails and HTML links for each FigureYa folder listed on the page.

---

## 🧬 Agents功能 / Therapeutic Agents Analysis

FigureYa提供了完整的**therapeutic agents (治疗性药物)分析功能**，用于药物发现、靶点分析和作用机制研究。

FigureYa provides comprehensive **therapeutic agents analysis functionality** for drug discovery, target analysis, and mechanism of action studies.

### 🚀 快速开始 / Quick Start
- **[快速入门指南](docs/Agents_Quick_Start.md)** - 5分钟了解Agents功能
- **[完整使用指南](docs/Agents_Functionality_Guide.md)** - 详细功能说明和最佳实践  
- **[教程示例](docs/Agents_Tutorial_Example.R)** - 可运行的R代码示例

### 🎯 核心模块 / Core Modules
- **FigureYa131CMap_update**: CMap连接性图谱分析
- **FigureYa213customizeHeatmap**: 多源证据药物筛选  
- **FigureYa212drugTargetV2**: 药物靶点敏感性分析

### 📋 典型应用 / Applications
- 🔍 **Drug Discovery**: 基于基因表达寻找候选药物
- 🎯 **Precision Medicine**: 个性化药物敏感性预测
- 🧬 **Mechanism Studies**: 药物作用机制和靶点分析
- 📈 **Drug Repurposing**: 现有药物的新适应症发现

---

## 📦 Getting the Code and Data

You have two options for accessing the files.

### 1. Download for Offline Use
All FigureYa folders are compressed as individual zip files for convenient downloading. To download a specific folder:

1.  Navigate to the [`/compressed`](https://github.com/ying-ge/FigureYa/tree/main/compressed) directory.
2.  Find the zip file with the name corresponding to the folder you want (e.g., `FigureYa123mutVSexpr.zip`).
3.  Click on the zip file, then click the **Download** button.

### 2. Browse Online on GitHub
If you want to view the raw input or output files directly, you can browse them in the file browser at the top of this repository's main page.

---

## :file_folder: Structure of a FigureYa Directory
Each `FigureYa` directory follows a consistent structure:

1. **Core Files**
   - `*.Rmd`: R Markdown script (main analysis/plotting code)  
   - `*.html`: The knitted report generated from the R Markdown file.  
2. **Input Files**  
   - `easy_input_*`: Primary data/parameters (e.g., `easy_input_data.csv`)  
   - `example.png`: Reference image specifying plot requirements (style/layout)  
3. **Output Files**  
   - `*.pdf`: Vector graphic results (editable, publication-ready)  
   - `output_*`: Text/tables (e.g., `output_results.txt`)  

**Example (`FigureYa59volcanoV2`)**  
```plaintext
FigureYa59volcanoV2/
├── FigureYa59volcanoV2.Rmd          # Main analysis script
├── FigureYa59volcanoV2.html         # HTML report
├── easy_input_limma.csv             # Input data
├── easy_input_selected.csv          # Input data
├── Volcano_classic.pdf              # Vector graphic (PDF)
├── Volcano_advanced.pdf             # Vector graphic (PDF)
└── example.png                      # Style reference for plots
```  

## ✍️ Citation
This manuscript is accepted by iMetaMed. [https://doi.org/10.1002/imm3.70005](https://doi.org/10.1002/imm3.70005)

Citation information will be updated later.
