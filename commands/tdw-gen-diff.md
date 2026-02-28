---
name: tdw-gen-diff
description: 仅生成当前分支相对 master 的差异数据到 doc/diff。
invokes: branch-tech-design-workflow
---

# 仅生成差异数据

只执行工作流的第 1 步：
- 产物输出目录：`doc/diff/<branch>/<timestamp>/`
- 产物包含：meta、name-status、stat、patch、commit、working-tree 状态

## 使用方式

```bash
/tdw-gen-diff

# 等价自然语言
执行 branch-tech-design-workflow，只做 step1（diff 采集）。
```
