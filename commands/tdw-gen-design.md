---
name: tdw-gen-design
description: 基于 doc/diff 差异数据和当前代码逻辑，按模板生成技术方案文档到 doc/技术方案。
invokes: branch-tech-design-workflow
---

# 仅生成技术方案文档

执行工作流的第 2 步和第 3 步：
- 读取 `doc/diff/` 最新差异数据
- 读取当前分支实际改动代码
- 使用模板生成技术方案：`doc/技术方案/<date>-<branch>-技术设计方案.md`

## 使用方式

```bash
/tdw-gen-design

# 使用默认模板（工程内置）
执行 branch-tech-design-workflow，使用默认模板生成技术方案。

# 指定模板
执行 branch-tech-design-workflow，模板使用 /path/to/your-template.md。
```
