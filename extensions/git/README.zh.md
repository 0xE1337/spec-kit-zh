<!-- zh-source: extensions/git/README.md -->
<!-- zh-base: f494a8e -->

# Git 分支工作流扩展

为 Spec Kit 提供 Git 仓库初始化、功能分支创建、编号（顺序/时间戳）、分支校验、远程检测和自动提交。

## 概览

本扩展把 Git 操作作为一个可选的、自包含的模块提供。它负责管理：

- **仓库初始化**，提交消息可配置
- **功能分支创建**，支持顺序编号（`001-feature-name`）或时间戳编号（`20260319-143022-feature-name`），并可为分支命名空间选配模板
- **分支校验**，确保分支遵循命名约定
- **Git 远程检测**，用于 GitHub 集成（例如创建 issue）
- **自动提交**，在核心命令之后执行（可按命令配置开关和自定义消息）

## 命令

| 命令 | 说明 |
|---------|-------------|
| `speckit.git.initialize` | 用可配置的提交消息初始化 Git 仓库 |
| `speckit.git.feature` | 创建带顺序或时间戳编号的功能分支 |
| `speckit.git.validate` | 校验当前分支是否遵循功能分支命名约定 |
| `speckit.git.remote` | 检测 Git 远程 URL，用于 GitHub 集成 |
| `speckit.git.commit` | 自动提交变更（可按命令配置启用/停用和消息） |

## 钩子

| 事件 | 命令 | 可选 | 说明 |
|-------|---------|----------|-------------|
| `before_constitution` | `speckit.git.initialize` | 否 | 在宪章之前初始化 git 仓库 |
| `before_specify` | `speckit.git.feature` | 否 | 在编写规范之前创建功能分支 |
| `before_clarify` | `speckit.git.commit` | 是 | 在澄清之前提交未提交的变更 |
| `before_plan` | `speckit.git.commit` | 是 | 在规划之前提交未提交的变更 |
| `before_tasks` | `speckit.git.commit` | 是 | 在生成任务之前提交未提交的变更 |
| `before_implement` | `speckit.git.commit` | 是 | 在实现之前提交未提交的变更 |
| `before_checklist` | `speckit.git.commit` | 是 | 在检查清单之前提交未提交的变更 |
| `before_analyze` | `speckit.git.commit` | 是 | 在分析之前提交未提交的变更 |
| `before_taskstoissues` | `speckit.git.commit` | 是 | 在同步 issue 之前提交未提交的变更 |
| `after_constitution` | `speckit.git.commit` | 是 | 宪章更新后自动提交 |
| `after_specify` | `speckit.git.commit` | 是 | 编写规范之后自动提交 |
| `after_clarify` | `speckit.git.commit` | 是 | 澄清之后自动提交 |
| `after_plan` | `speckit.git.commit` | 是 | 规划之后自动提交 |
| `after_tasks` | `speckit.git.commit` | 是 | 生成任务之后自动提交 |
| `after_implement` | `speckit.git.commit` | 是 | 实现之后自动提交 |
| `after_checklist` | `speckit.git.commit` | 是 | 检查清单之后自动提交 |
| `after_analyze` | `speckit.git.commit` | 是 | 分析之后自动提交 |
| `after_taskstoissues` | `speckit.git.commit` | 是 | 同步 issue 之后自动提交 |

## 配置

配置存储在 `.specify/extensions/git/git-config.yml`：

```yaml
# 分支编号策略："sequential"（顺序）或 "timestamp"（时间戳）
branch_numbering: sequential

# 可选的分支名模板。留空则使用默认的 "{number}-{slug}"。
# 支持的令牌：{author}、{app}、{number}、{slug}；{slug} 不得出现在
# {number} 之前，且最后一个路径段必须以 {number}- 开头。
# monorepo 示例："{author}/{app}/{number}-{slug}"
branch_template: ""

# 可选的简写命名空间。留空则使用 branch_template/默认行为。
# 示例："features/{app}" 会展开为 "features/{app}/{number}-{slug}"
branch_prefix: ""

# git init 的自定义提交消息
init_commit_message: "[Spec Kit] Initial commit"

# 按命令配置自动提交（默认全部停用）
# 示例：在 specify 之后启用自动提交
auto_commit:
  default: false
  after_specify:
    enabled: true
    message: "[Spec Kit] Add specification"
```

`{author}` 从 Git 配置推导，并针对分支名做了净化处理。`{app}` 从 Spec Kit 初始化目录名推导。自定义模板不得把 `{slug}` 放在 `{number}` 之前，且必须把 `{number}-` 放在最后一个路径段的开头，这样生成的名称才始终是有效的功能分支。对于位于 `apps/web/.specify/` 的 monorepo（单仓多项目）项目，`{author}/{app}/{number}-{slug}` 这样的模板会产生形如 `jdoe/web/008-guided-tour` 的分支。

对于只需要命名空间的简单定制，也接受 `branch_prefix` 作为简写，它会展开为 `<branch_prefix>/{number}-{slug}`。

## 安装

```bash
# 安装内置的 git 扩展（无需联网）
specify extension add git
```

## 停用

```bash
# 停用 git 扩展（规范创建照常进行，只是不再建分支）
specify extension disable git

# 重新启用
specify extension enable git
```

## 优雅降级

当 Git 未安装或目录不是 Git 仓库时：
- 规范目录仍会创建在 `specs/` 下
- 跳过分支创建并给出警告
- 跳过分支校验并给出警告
- 远程检测返回空结果

## 脚本

本扩展捆绑了跨平台脚本：

- `scripts/bash/create-new-feature-branch.sh`——Bash 实现（仅分支创建）
- `scripts/bash/git-common.sh`——共享的 Git 工具函数（Bash）
- `scripts/powershell/create-new-feature-branch.ps1`——PowerShell 实现（仅分支创建）
- `scripts/powershell/git-common.ps1`——共享的 Git 工具函数（PowerShell）
