---
description: "在 Spec Kit 命令完成后自动提交变更"
---

<!-- zh-source: extensions/git/commands/speckit.git.commit.md -->
<!-- zh-base: d0a8389 -->

# 自动提交变更

在 Spec Kit 命令完成后，自动暂存并提交所有变更。

## 行为

本命令作为核心命令之后（或之前）的钩子被调用。它会：

1. 从钩子上下文确定事件名（例如作为 `after_specify` 钩子被调用时，事件就是 `after_specify`；作为 `before_plan` 时，事件就是 `before_plan`）
2. 检查 `.specify/extensions/git/git-config.yml` 中的 `auto_commit` 配置节
3. 查找具体的事件键，确认该事件是否启用了自动提交
4. 如果没有事件专属的键，回退到 `auto_commit.default`
5. 根据 `commit_style` 确定提交消息（见下文）
6. 如果已启用且存在未提交的变更，运行 `git add .` + `git commit`

## 提交消息风格

由 `.specify/extensions/git/git-config.yml` 中的 `commit_style` 键控制：

- **`fixed`**（默认）：如果配置了按命令的 `message` 就使用它，否则使用通用的 `[Spec Kit] Auto-commit <phase> <command>` 消息。
- **`conventional`**：检查自上次提交以来的实际变更（`git diff` / `git status`），并生成单行的 [Conventional Commit](https://www.conventionalcommits.org/) 消息（`type(scope): subject`，例如 `feat: add OAuth specification` 或 `docs: update implementation plan`），准确概括本次变更。将该消息写入临时文件，并把文件路径传给脚本（见下方"执行"）。此模式下会忽略配置中的 `message` 值。

## 执行

从触发本命令的钩子确定事件名，然后运行脚本：

- **Bash**：`.specify/extensions/git/scripts/bash/auto-commit.sh <event_name> [--message-file <path>]`
- **PowerShell**：`.specify/extensions/git/scripts/powershell/auto-commit.ps1 <event_name> [-MessageFile <path>]`

把 `<event_name>` 替换为实际的钩子事件（例如 `after_specify`、`before_plan`、`after_implement`）。仅当配置了 `commit_style: conventional` 时才传入生成的消息——先检查 `.specify/extensions/git/git-config.yml` 中 `commit_style` 的值：

- 如果是 `conventional`：检查 diff 并生成 Conventional Commit 消息。**不要把生成的消息直接插值进 shell 命令字符串**——它的内容源自仓库变更，可能包含 shell 会执行或会破坏命令引号的字符（引号、`$(...)`、反引号）。而应使用你的文件编辑工具（而非 shell 的 `echo`/`printf`）把消息写入临时文件，然后通过 `--message-file <path>`（Bash）或 `-MessageFile <path>`（PowerShell）传入该文件路径。
- 如果是 `fixed` 或缺省：只用 `<event_name>` 运行脚本；它会使用配置的/静态的消息。

## 配置

在 `.specify/extensions/git/git-config.yml` 中：

```yaml
# "fixed"（默认）使用下方的消息；"conventional" 则让智能体
# 根据 diff 生成 Conventional Commit 消息。
commit_style: fixed

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
- 如果设置了 `commit_style: conventional` 但未提供生成的消息：给出清晰的错误而非静默回退到固定消息格式
