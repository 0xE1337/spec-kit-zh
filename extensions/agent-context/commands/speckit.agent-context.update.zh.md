---
description: "刷新编码智能体上下文文件中的受管 Spec Kit 区块"
---

<!-- zh-source: extensions/agent-context/commands/speckit.agent-context.update.md -->
<!-- zh-base: 126e568 -->

# 更新编码智能体上下文

刷新当前生效编码智能体的上下文/指令文件（例如 `CLAUDE.md`、`.github/copilot-instructions.md`、`AGENTS.md`）中的受管 Spec Kit 区块。

## 行为

脚本读取 agent-context 扩展的配置文件
`.specify/extensions/agent-context/agent-context-config.yml`，从中获得：

- `context_file`——要管理的编码智能体上下文文件路径。
- `context_files`——可选，多个编码智能体上下文文件相对项目的路径。非空时，脚本会更新列表中的每个文件，且该列表优先于 `context_file`。
- `context_markers.start` / `.end`——受管区块两端的分界标记。字段缺失时默认为 `<!-- SPECKIT START -->` 和 `<!-- SPECKIT END -->`。

然后它会创建、替换或追加受管区块，使该区块指向能发现的最新计划路径（`specs/` 下的任何 `plan.md`，包括 `specs/<scope>/<feature>/plan.md` 这类嵌套的作用域布局）。

如果 `context_files` 和 `context_file` 都为空，本命令报告无事可做并成功退出。上下文文件路径必须保持相对项目：绝对路径、Windows 盘符路径、反斜杠分隔符和 `..` 路径段都会被拒绝。

## 执行

- **Bash**：`.specify/extensions/agent-context/scripts/bash/update-agent-context.sh [plan_path]`
- **PowerShell**：`.specify/extensions/agent-context/scripts/powershell/update-agent-context.ps1 [plan_path]`

省略 `plan_path` 时，脚本会自动检测最近修改的 `specs/**/plan.md`（递归搜索，因此嵌套的作用域布局也能被发现）。
