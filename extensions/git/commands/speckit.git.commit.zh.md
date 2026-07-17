---
description: "在 Spec Kit 命令完成后自动提交变更"
---

<!-- zh-source: extensions/git/commands/speckit.git.commit.md -->
<!-- zh-base: 1a9e4d1 -->

# 自动提交变更

在 Spec Kit 命令完成后，自动暂存并提交所有变更。

## 行为

本命令作为核心命令之后（或之前）的钩子被调用。它会：

1. 从钩子上下文确定事件名（例如作为 `after_specify` 钩子被调用时，事件就是 `after_specify`；作为 `before_plan` 时，事件就是 `before_plan`）
2. 检查 `.specify/extensions/git/git-config.yml` 中的 `auto_commit` 配置节
3. 查找具体的事件键，确认该事件是否启用了自动提交
4. 如果没有事件专属的键，回退到 `auto_commit.default`
5. 如果配置了按命令的 `message` 就使用它，否则使用默认消息
6. 如果已启用且存在未提交的变更，运行 `git add .` + `git commit`

## 执行

从触发本命令的钩子确定事件名，然后运行脚本：

- **Bash**：`.specify/extensions/git/scripts/bash/auto-commit.sh <event_name>`
- **PowerShell**：`.specify/extensions/git/scripts/powershell/auto-commit.ps1 <event_name>`

把 `<event_name>` 替换为实际的钩子事件（例如 `after_specify`、`before_plan`、`after_implement`）。

## 配置

在 `.specify/extensions/git/git-config.yml` 中：

```yaml
auto_commit:
  default: false          # 全局开关——设为 true 则对所有命令启用
  after_specify:
    enabled: true          # 按命令覆盖
    message: "[Spec Kit] Add specification"
  after_plan:
    enabled: false
    message: "[Spec Kit] Add implementation plan"
```

## 优雅降级

- 如果 Git 不可用或当前目录不是仓库：跳过并给出警告
- 如果配置文件不存在：跳过（默认停用）
- 如果没有可提交的变更：跳过并给出提示
