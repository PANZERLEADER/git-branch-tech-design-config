---
name: branch-tech-design-workflow
description: 比较当前 Git 分支与 master 的差异并生成结构化 diff 数据到 doc/diff；再基于 diff 数据、当前分支实际代码逻辑和技术方案模板生成技术方案文档到 doc/技术方案。用户提到“分支对比”“生成技术方案”“doc/diff”“doc/技术方案”“按模板出方案”时使用。
---

# 分支差异到技术方案工作流

你是技术方案文档生成助手。按以下顺序执行，不跳步。

## 输入

- 基准分支：默认 `master`
- diff 输出目录：默认 `doc/diff`
- 方案输出目录：默认 `doc/技术方案`
- 模板路径：默认 `/Users/stuka/IdeaProjects/simi/simi-server/实现方案/XXXXX-技术设计方案模版.md`

## 步骤 1：采集分支差异数据

1. 定位脚本路径，优先使用已安装路径：

```bash
if [ -x "$HOME/.codex/skills/branch-tech-design-workflow/scripts/collect_diff.sh" ]; then
  DIFF_SCRIPT="$HOME/.codex/skills/branch-tech-design-workflow/scripts/collect_diff.sh"
elif [ -x "./skills/branch-tech-design-workflow/scripts/collect_diff.sh" ]; then
  DIFF_SCRIPT="./skills/branch-tech-design-workflow/scripts/collect_diff.sh"
else
  echo "collect_diff.sh not found" >&2
  exit 1
fi
```

2. 执行采集：

```bash
bash "$DIFF_SCRIPT" master doc/diff
```

3. 记录输出目录（脚本会回显绝对路径），其中至少包含：
- `meta.md`
- `changed-files.name-status.txt`
- `changed-files.stat.txt`
- `changes.patch`
- `commits.oneline.txt`
- `working-tree.status.txt`

## 步骤 2：初始化技术方案文档

1. 定位初始化脚本：

```bash
if [ -x "$HOME/.codex/skills/branch-tech-design-workflow/scripts/init_tech_doc.sh" ]; then
  INIT_SCRIPT="$HOME/.codex/skills/branch-tech-design-workflow/scripts/init_tech_doc.sh"
elif [ -x "./skills/branch-tech-design-workflow/scripts/init_tech_doc.sh" ]; then
  INIT_SCRIPT="./skills/branch-tech-design-workflow/scripts/init_tech_doc.sh"
else
  echo "init_tech_doc.sh not found" >&2
  exit 1
fi
```

2. 执行初始化：

```bash
bash "$INIT_SCRIPT" \
  "/Users/stuka/IdeaProjects/simi/simi-server/实现方案/XXXXX-技术设计方案模版.md" \
  "doc/技术方案"
```

3. 记录输出文件路径（脚本会回显绝对路径）。

## 步骤 3：基于 diff + 代码逻辑填充模板

1. 读取 `changed-files.name-status.txt`，列出所有变更文件。
2. 逐个打开变更文件，结合 `changes.patch` 分析改动目的与行为变化。
3. 按模板章节填充内容，要求：
- 只写有证据支持的内容
- 表格尽量填写完整
- 不涉及的章节明确写“无改动”
- 涉及接口、数据库、Redis、消息、定时任务时必须写到对应章节
- 如果存在待确认项，写在“7. 备注”

## 步骤 4：一致性检查

生成文档后进行检查：

1. `doc/技术方案/*.md` 已创建
2. 文档中覆盖所有核心改动（服务、接口、数据、配置）
3. 关键结论与 `changes.patch` 一致
4. 引用的文件路径和类名与代码一致

## 输出

- 差异数据目录：`doc/diff/<branch>/<timestamp>/`
- 技术方案文档：`doc/技术方案/<date>-<branch>-技术设计方案.md`
