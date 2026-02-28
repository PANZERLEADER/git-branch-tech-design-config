# Git 分支差异 → 技术方案 工作流配置

这个工程参考 `springboot-codex-config` 的组织方式，提供一个可复用的 Codex 工作流：

1. 对当前分支与 `master` 的差异进行采集，输出到 `doc/diff/`
2. 基于 `doc/diff/` 数据、当前分支代码逻辑和技术方案模板，生成技术方案文档到 `doc/技术方案/`

## 目录结构

```text
git-branch-tech-design-config/
├── skills/
│   └── branch-tech-design-workflow/
│       ├── SKILL.md
│       ├── scripts/
│       │   ├── collect_diff.sh
│       │   └── init_tech_doc.sh
│       └── assets/
│           └── tech-design-template.md
├── commands/
│   ├── tdw-run.md
│   ├── tdw-gen-diff.md
│   └── tdw-gen-design.md
├── install.sh
├── README.md
└── INDEX.md
```

## 安装

```bash
cd git-branch-tech-design-config
./install.sh
```

安装后技能路径：`~/.codex/skills/branch-tech-design-workflow`

## 使用方式（在目标业务仓库中）

- 全流程：
  - “执行 `branch-tech-design-workflow`，基于 master 生成 diff 并产出技术方案。”
- 仅生成 diff：
  - “执行 `branch-tech-design-workflow`，先只做 step1（diff 采集）。”
- 指定模板：
  - “执行 `branch-tech-design-workflow`，模板使用 `/Users/stuka/IdeaProjects/simi/simi-server/实现方案/XXXXX-技术设计方案模版.md`。”

## 默认约定

- 基准分支：`master`
- diff 目录：`doc/diff`
- 技术方案目录：`doc/技术方案`
- 默认模板：`/Users/stuka/IdeaProjects/simi/simi-server/实现方案/XXXXX-技术设计方案模版.md`
