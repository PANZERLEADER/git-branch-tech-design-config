---
name: tdw-run
description: 一次性执行“分支 diff 采集 + 技术方案生成”工作流。
invokes: branch-tech-design-workflow
---

# 分支差异到技术方案（全流程）

执行完整流程：
1. 比较当前分支与 `master`，将差异数据写入 `doc/diff/`
2. 基于差异数据、当前代码逻辑和技术方案模板，生成 `doc/技术方案/*.md`

## 使用方式

```bash
/tdw-run

# 等价自然语言
执行 branch-tech-design-workflow，使用 master 作为基准，输出到 doc/diff 和 doc/技术方案。
```
