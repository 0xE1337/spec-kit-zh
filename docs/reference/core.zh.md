<!-- zh-source: docs/reference/core.md -->
<!-- zh-base: 4f4d19b -->

# 核心命令

核心的 `specify` 命令负责项目初始化、系统检查和版本信息。

## 初始化项目

```bash
specify init [<project_name>]
```

| 选项                     | 说明                                                                      |
| ------------------------ | ------------------------------------------------------------------------ |
| `--integration <key>`    | 要使用的 AI 编码智能体集成（如 `copilot`、`claude`、`gemini`）。所有可用的 key 见[集成参考](integrations.md) |
| `--integration-options`  | 传给集成的选项（例如 `--integration-options="--commands-dir .myagent/cmds"`） |
| `--script sh\|ps\|py`    | 脚本类型：`sh`（bash/zsh）、`ps`（PowerShell）或 `py`（Python）          |
| `--here`                 | 在当前目录初始化，而不是新建目录                                          |
| `--force`                | 在已有目录中初始化时强制合并/覆盖                                         |
| `--ignore-agent-tools`   | 跳过对 AI 编码智能体 CLI 工具的检查                                       |
| `--preset <id>`          | 初始化时安装一个预设                                                      |

创建一个新的 Spec Kit 项目，包含所需的目录结构、模板、脚本和 AI 编码智能体集成文件。

> [!NOTE]
> Git 仓库初始化和分支管理由 **git 扩展**负责，该扩展默认不安装。init 之后运行 `specify extension add git` 即可启用 git 工作流。

用 `<project_name>` 创建新目录，或用 `--here`（或 `.`）在当前目录初始化。如果目录中已有文件，用 `--force` 免确认合并。

省略 `--integration` 时，交互式终端会提示你选择集成。非交互式会话（如 CI 或管道运行）默认使用 GitHub Copilot；传入 `--integration <key>` 可显式选择其他集成。

### 示例

```bash
# 创建新项目并指定集成
specify init my-project --integration copilot

# 在当前目录初始化
specify init --here --integration copilot

# 强制合并进非空目录
specify init --here --force --integration copilot

# 使用 PowerShell 脚本（Windows/跨平台）
specify init my-project --integration copilot --script ps

# 初始化时安装预设
specify init my-project --integration copilot --preset compliance
```

### 环境变量

| 变量              | 说明                                                                      |
| ----------------- | ------------------------------------------------------------------------ |
| `SPECIFY_INIT_DIR` | 从项目目录之外（例如 monorepo 根目录）指向某个成员项目而无需 `cd`，适用于非交互式 / CI 场景。把它设置为**项目根目录**——即*包含* `.specify/` 的目录（相对路径基于当前目录解析）。该路径必须存在且包含 `.specify/`，否则命令会报错，并且**不会**回退到当前目录。它在核心根目录辅助函数中只解析一次（Bash 中是 `get_repo_root`，PowerShell 中是 `Get-RepoRoot`），因此核心功能脚本（`/speckit.plan`、`/speckit.tasks` 等）以及继承它的 Git 扩展功能分支创建都会遵守它。`specify` CLI 对每个项目作用域子命令（`specify integration …`、`specify extension …`、`specify workflow …`、`specify preset …`，以及其余操作 `.specify/` 项目的命令）应用**相同的**校验规则，所以这些命令也能指向成员项目。未设置时，Bash/PowerShell 辅助函数保持原有的向上搜索行为；`specify` CLI 的项目作用域解析器仍然只看当前目录，除非某个命令显式定义了更宽的检测逻辑（例如 bundle 相关命令）。 |
| `SPECIFY_FEATURE_DIRECTORY` | 覆盖已解析项目*内部*的当前功能目录（优先级高于 `.specify/feature.json`）。相对路径基于项目根目录解析。与 `SPECIFY_INIT_DIR` 组合使用，可非交互式地同时选定项目和功能。 |
| `SPECIFY_FEATURE` | 为非 Git 仓库覆盖功能检测。设置为功能目录名（例如 `001-photo-albums`），即可在不使用 Git 分支时针对特定功能工作。必须在使用 `/speckit.plan` 或后续命令之前，在智能体的上下文中设置好。 |

> **两条解析轴。** `SPECIFY_INIT_DIR` 选择**项目**（哪个目录包含 `.specify/`）；`SPECIFY_FEATURE_DIRECTORY` / `.specify/feature.json` 选择该项目内的**功能**。两者相互独立——先定项目，再定功能。

> **符号链接的项目根目录。** `SPECIFY_INIT_DIR` 改变的是项目*在哪里*，而不是命令*如何*对待符号链接：每个命令保持它原有的当前目录路径处理立场。通过宽泛输入路径遍历并写入项目文件的命令（`bundle`、`workflow run <file>`）会拒绝符号链接的 `.specify/`，以保证写入范围受限。其他项目作用域命令在 `SPECIFY_INIT_DIR` 指向项目根目录时保持原有行为，其中可能包括跟随符号链接的 `.specify/`。

## 检查已安装的工具

```bash
specify check
```

检查基于 CLI 的 AI 编码智能体在你的系统上是否可用。基于 IDE 的智能体会被跳过，因为它们不需要 CLI 工具。

该命令完全离线运行。如果某个命令表现得像旧版 Spec Kit，或者预期的 CLI 功能缺失，运行 `specify self check` 检查本地 CLI 是否落后于最新 release。

## 版本信息

```bash
specify version
```

显示 Spec Kit CLI 版本、Python 版本、平台和架构。

不联网检查本地 CLI 的能力：

```bash
specify version --features
specify version --features --json
```

JSON 形式面向需要根据已安装 CLI 支持的功能来选择工作流的脚本和编码智能体。

也可以用以下方式快速查看版本：

```bash
specify --version
specify -V
```
