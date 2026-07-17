---
description: "创建带顺序或时间戳编号的功能分支"
---

<!-- zh-source: extensions/git/commands/speckit.git.feature.md -->
<!-- zh-base: f494a8e -->

# 创建功能分支

为给定的规范创建并切换到一个新的 git 功能分支。本命令**只负责创建分支**——规范目录和文件由核心的 `__SPECKIT_COMMAND_SPECIFY__` 工作流创建。

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑用户输入（如果不为空）。

## 环境变量覆盖

如果用户显式提供了 `GIT_BRANCH_NAME`（例如通过环境变量、参数或在请求中提出），在调用脚本前设置 `GIT_BRANCH_NAME` 环境变量，把它透传给脚本。当 `GIT_BRANCH_NAME` 已设置时：
- 脚本把该值原样用作分支名，绕过所有前缀/后缀生成逻辑
- `--short-name`、`--number` 和 `--timestamp` 标志被忽略
- 当最后一个路径段以数字或时间戳功能标记开头时（例如 `042-name`、`feat/042-name` 或 `jdoe/app/042-name`），从中提取 `FEATURE_NUM`；否则将其设为完整分支名

## 前置条件

- 运行 `git rev-parse --is-inside-work-tree 2>/dev/null` 验证 Git 可用
- 如果 Git 不可用，警告用户并跳过分支创建

## 分支编号模式

按以下顺序检查配置，确定分支编号策略：

1. 检查 `.specify/extensions/git/git-config.yml` 中的 `branch_numbering` 值
2. 检查 `.specify/init-options.json` 中的 `feature_numbering` 值（继承自核心）
3. 检查 `.specify/init-options.json` 中的 `branch_numbering` 值（已弃用，仅为向后兼容——将在未来版本中移除）
4. 如果以上都不存在，默认为 `sequential`

## 分支名模板

检查 `.specify/extensions/git/git-config.yml` 中可选的 `branch_template` 值。如果为空或缺失，使用默认分支形态 `{number}-{slug}`。如果已设置，`{slug}` 不得出现在 `{number}` 之前，其最后一个路径段必须以 `{number}-` 开头，脚本会展开以下令牌：

- `{author}`：净化后的 Git 配置作者（`user.name`，回退为邮箱的本地部分）
- `{app}`：净化后的 Spec Kit 初始化目录名
- `{number}`：顺序编号或时间戳
- `{slug}`：生成的分支短名称

对于 monorepo（单仓多项目），`{author}/{app}/{number}-{slug}` 这样的模板会创建形如 `jdoe/web/008-guided-tour` 的名称，同时保留按项目独立的功能编号。

脚本也接受 `branch_prefix` 作为简单命名空间的简写；它会展开为 `<branch_prefix>/{number}-{slug}`。

## 执行

为分支生成一个简洁的短名称（2-4 个单词）：
- 分析功能描述并提取最有意义的关键词
- 尽量使用"动作-名词"格式（例如 "add-user-auth"、"fix-payment-bug"）
- 保留技术术语和缩写（OAuth2、API、JWT 等）

根据你的平台运行对应的脚本：

- **Bash**：`.specify/extensions/git/scripts/bash/create-new-feature-branch.sh --json --short-name "<short-name>" "<feature description>"`
- **Bash（时间戳）**：`.specify/extensions/git/scripts/bash/create-new-feature-branch.sh --json --timestamp --short-name "<short-name>" "<feature description>"`
- **PowerShell**：`.specify/extensions/git/scripts/powershell/create-new-feature-branch.ps1 -Json -ShortName "<short-name>" "<feature description>"`
- **PowerShell（时间戳）**：`.specify/extensions/git/scripts/powershell/create-new-feature-branch.ps1 -Json -Timestamp -ShortName "<short-name>" "<feature description>"`

**重要**：
- 不要传 `--number`——脚本会自动确定正确的下一个编号
- 始终包含 JSON 标志（Bash 用 `--json`，PowerShell 用 `-Json`），以便可靠地解析输出
- 每个功能只能运行这个脚本一次
- JSON 输出会包含 `BRANCH_NAME` 和 `FEATURE_NUM`
- 不要手动展开 `branch_template`；脚本会读取 git 扩展配置并一致地应用它

## 优雅降级

如果 Git 未安装或当前目录不是 Git 仓库：
- 跳过分支创建并给出警告：`[specify] Warning: Git repository not detected; skipped branch creation`
- 脚本仍会输出 `BRANCH_NAME` 和 `FEATURE_NUM`，供调用方引用

## 输出

脚本输出的 JSON 包含：
- `BRANCH_NAME`：分支名（例如 `003-user-auth`、`20260319-143022-user-auth` 或 `jdoe/web/003-user-auth`）
- `FEATURE_NUM`：所使用的数字或时间戳前缀
