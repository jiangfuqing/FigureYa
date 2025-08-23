# FigureYa Agents功能使用总结 / Summary of FigureYa Agents Functionality

## 🎉 恭喜！您现在已经了解了FigureYa的Agents功能

**Agents功能**是FigureYa框架中专门用于**治疗性药物分析**的完整工具集，帮助研究人员进行药物发现、靶点分析和作用机制研究。

## 📁 您获得的文档资源 / Documentation Resources You Now Have

```
docs/
├── README.md                     # 📋 文档索引和概览
├── Agents_Quick_Start.md         # 🚀 5分钟快速入门指南  
├── Agents_Functionality_Guide.md # 📚 完整使用指南
└── Agents_Tutorial_Example.R     # 💻 可运行的R教程脚本
```

## 🎯 核心功能模块 / Core Modules

### 1️⃣ CMap连接性图谱分析
**模块**: `FigureYa131CMap_update`
**功能**: 基于基因表达寻找候选治疗药物
```r
# 工作流程示例
差异基因列表 → CMap查询 → 候选药物 → 机制分析
```

### 2️⃣ 多源证据药物筛选  
**模块**: `FigureYa213customizeHeatmap`
**功能**: 整合多个数据库的药物筛选结果
```r
# 证据来源
PRISM + CTRP + CMap + 靶点表达 + 文献证据
```

### 3️⃣ 药物敏感性分析
**模块**: `FigureYa212drugTargetV2` 
**功能**: 患者分层和个性化治疗预测
```r
# 应用场景
基因表达 → PPS评分 → 药物敏感性 → 个性化治疗
```

## 🛠️ 如何开始使用 / How to Get Started

### 方式1: 快速体验 (推荐新手)
1. 阅读 [`docs/Agents_Quick_Start.md`](docs/Agents_Quick_Start.md)
2. 按照5分钟教程操作
3. 运行示例代码

### 方式2: 深入学习 (推荐进阶用户)
1. 学习 [`docs/Agents_Functionality_Guide.md`](docs/Agents_Functionality_Guide.md)
2. 运行 [`docs/Agents_Tutorial_Example.R`](docs/Agents_Tutorial_Example.R)
3. 使用自己的数据

### 方式3: 直接实战 (推荐有经验用户)
1. 打开相应的FigureYa模块文件夹
2. 查看`.Rmd`脚本和`example.png`参考图
3. 根据自己的需求修改参数

## 📊 典型使用场景 / Typical Use Cases

| 研究目标 | 推荐模块 | 输入数据 | 预期输出 |
|---------|---------|---------|---------|
| 🔍 寻找治疗药物 | FigureYa131CMap_update | 差异表达基因 | 候选药物列表 |
| 🎯 验证药物候选 | FigureYa213customizeHeatmap | 多源药物数据 | 证据整合热图 |
| 👥 患者分层治疗 | FigureYa212drugTargetV2 | 表达谱+药物敏感性 | 个性化治疗方案 |
| 🧬 机制研究 | 所有模块组合 | 基因+药物+通路 | 作用机制网络 |

## 🎨 可视化输出示例 / Visualization Examples

### CMap富集热图
```
化合物1  ████████▓▓░░░░  -0.85 (治疗潜力高)
化合物2  ██████▓▓░░░░░░  -0.62 (治疗潜力中)  
化合物3  ████▓▓░░░░░░░░  -0.33 (治疗潜力低)
```

### 多源证据热图
```
药物      PRISM  CTRP  CMap  靶点  文献
BI-2536    ████   ███   ██    ████   ███
methotrexate ███   ████   ███   ███   ████
vincristine  ██    ███   ████   ██    ███
```

## 🔗 相关数据库和工具 / Related Databases & Tools

- **[CLUE.io](https://clue.io/)** - 新一代连接性图谱平台
- **[CMap Build 02](https://portals.broadinstitute.org/cmap/)** - 经典CMap数据库
- **[GDSC](https://www.cancerrxgene.org/)** - 基因组学药物敏感性
- **[CTRP](https://portals.broadinstitute.org/ctrp/)** - 癌症治疗反应门户

## ⚡ 效率提升建议 / Efficiency Tips

### 🎯 目标明确
- 明确研究问题：是寻找新药、验证已知药物，还是研究机制？
- 选择合适的模块：不同模块适用于不同的研究目标

### 📊 数据准备
- 确保基因ID格式正确（GPL96平台）
- 预处理差异表达数据（去除低表达基因，批次校正）
- 准备充足的对照组样本

### 🔍 结果验证
- 多数据库交叉验证
- 文献检索支持
- 实验验证（如可能）

## 🆘 获取帮助 / Getting Help

### 常见问题解决
1. **安装问题**: 使用国内镜像加速包安装
2. **数据格式**: 参考示例文件格式
3. **参数设置**: 查看完整指南中的参数优化建议

### 技术支持
- **GitHub Issues**: 报告bug和功能建议
- **文档查询**: 查看详细使用指南
- **社区讨论**: 与其他用户交流经验

## 🎓 下一步学习 / Next Steps

1. **熟悉基础操作**: 完成快速入门教程
2. **深入理解原理**: 学习CMap和药物敏感性分析原理
3. **实际项目应用**: 将方法应用到自己的研究项目
4. **分享经验**: 向社区分享使用心得和改进建议

---

## 📝 总结 / Conclusion

通过本指南，您已经掌握了：
- ✅ FigureYa Agents功能的核心概念
- ✅ 三大主要模块的使用方法
- ✅ 完整的分析工作流程
- ✅ 最佳实践和故障排除方法
- ✅ 丰富的学习资源和参考文档

现在您可以开始使用FigureYa的Agents功能进行您的药物发现和分析研究了！

**祝您研究顺利！🎉**

---
*如有问题，请随时查阅文档或在GitHub Issues中提问*