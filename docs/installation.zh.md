<!-- zh-source: docs/installation.md -->
<!-- zh-base: ad601e5 -->

# 安装指南

## 前置条件

- **Linux/macOS**（或 Windows；PowerShell 脚本已获支持，无需 WSL）
- AI 编码智能体：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[CodeBuddy CLI](https://www.codebuddy.cn/docs/cli/installation)、[Gemini CLI](https://github.com/google-gemini/gemini-cli)、[Pi Coding Agent](https://pi.dev) 或 [Oh My Pi](https://www.npmjs.com/package/@oh-my-pi/pi-coding-agent)
- [uv](https://docs.astral.sh/uv/) 用于包管理（推荐），或 [pipx](https://pipx.pypa.io/) 用于持久安装
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads) _（可选——仅在启用 git 扩展时需要）_

## 安装

> [!IMPORTANT]
> Spec Kit 通过两个官方渠道分发，均由 Spec Kit 维护者发布和维护：[github/spec-kit](https://github.com/github/spec-kit) GitHub 仓库（源码安装）和 [PyPI](https://pypi.org/project/specify-cli/) 上的 [`specify-cli`](https://pypi.org/project/specify-cli/) 包。两条路线都是受支持的常规安装方式——使用下面给出的命令即可。安装后运行 `specify version` 做本地版本/运行时的快速检查。它能确认 `specify` 命令可用并报告其版本，但无法证明可执行文件来自 PyPI 还是 GitHub。对于离线或离线隔离（air-gapped）环境，用本仓库在本地构建的 wheel 也是有效的安装来源。

Spec Kit 支持两条安装路线：

1. **从源码安装（GitHub）**——推荐路线，固定到某个发布 tag。
2. **从 PyPI 安装**——用你常用的 Python 工具安装已发布的 `specify-cli` 包。

### 从源码安装——持久安装（推荐）

一次安装，处处可用。将 `vX.Y.Z` 替换为 [Releases](https://github.com/github/spec-kit/releases) 页面上的发布 tag——注意保留开头的 `v`（例如 `v0.12.11`，而不是 `0.12.11`）：

> [!NOTE]
> 下面的命令需要 **[uv](https://docs.astral.sh/uv/)**。如果看到 `command not found: uv`，请先[安装 uv](./install/uv.md)。

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@vX.Y.Z
```

然后初始化项目：

```bash
specify init <PROJECT_NAME> --integration copilot
```

### 从 PyPI 安装

Spec Kit 也以 [`specify-cli`](https://pypi.org/project/specify-cli/) 的名字发布到 PyPI，因此你可以用自己偏好的 Python 包管理器安装，无需引用 Git URL：

```bash
# 使用 uv（推荐）
uv tool install specify-cli

# 或使用 pipx
pipx install specify-cli

# 或使用 pip
pip install specify-cli
```

要安装特定发布版本，请固定版本号——例如 `uv tool install specify-cli==0.12.11`。详情（包括如何升级）见 [PyPI 安装指南](install/pypi.md)。

### 一次性使用

不安装直接运行——见[一次性使用（uvx）](install/one-time.md)指南。

### 其他包管理器

- **PyPI**——见 [PyPI 安装指南](install/pypi.md)
- **pipx**——见 [pipx 安装指南](install/pipx.md)
- **企业 / 离线隔离环境**——见[离线隔离环境安装指南](install/air-gapped.md)

### 指定集成

交互式终端会在初始化时提示你选择编码智能体集成。非交互式会话（如 CI 或管道运行）默认使用 GitHub Copilot，除非传入 `--integration`。

你也可以在初始化时主动指定编码智能体集成：

```bash
specify init <project_name> --integration claude
specify init <project_name> --integration gemini
specify init <project_name> --integration copilot
specify init <project_name> --integration codebuddy
specify init <project_name> --integration pi
specify init <project_name> --integration omp
```

### 指定脚本类型（Shell 与 PowerShell）

所有自动化脚本现在都有 Bash（`.sh`）和 PowerShell（`.ps1`）两种变体。

自动选择行为：

- Windows 默认：`ps`
- 其他操作系统默认：`sh`
- 交互模式：除非传入 `--script`，否则会提示你选择

强制指定脚本类型：

```bash
specify init <project_name> --script sh
specify init <project_name> --script ps
```

### 跳过智能体工具检查

如果你只想获取模板，不检查相应工具是否安装：

```bash
specify init <project_name> --integration claude --ignore-agent-tools
```

## 验证

安装后，运行以下命令做本地版本/运行时检查：

```bash
specify version
```

这会确认 `specify` 命令可用并报告预期版本。它无法证明该可执行文件来自 PyPI 还是 GitHub。

**保持最新**：定期运行 `specify self check` 了解是否有新版本可用——它是只读的，绝不会修改你的安装。准备升级时，参照[升级指南](./upgrade.md)操作。

初始化后，你应该能在编码智能体中看到以下命令：

- `/speckit.specify` —— 创建规范
- `/speckit.plan` —— 生成实现计划
- `/speckit.tasks` —— 拆解为可执行任务
- `/speckit.implement` —— 执行实现任务
- `/speckit.analyze` —— 验证跨产物一致性
- `/speckit.clarify` —— 识别并解决模糊之处
- `/speckit.checklist` —— 生成质量检查清单
- `/speckit.constitution` —— 创建或更新项目原则
- `/speckit.converge` —— 对照产物评估代码库现状并追加剩余任务
- `/speckit.taskstoissues` —— 把任务转换为 issue

脚本会安装到与所选脚本类型对应的变体子目录：

- `.specify/scripts/bash/` —— 包含 `.sh` 脚本（Linux/macOS 默认）
- `.specify/scripts/powershell/` —— 包含 `.ps1` 脚本（Windows 默认）

## 故障排查

### 企业 / 离线隔离环境安装

如果你的环境无法访问 PyPI 或 GitHub，请参阅[企业 / 离线隔离环境安装](install/air-gapped.md)指南，了解创建可移植 wheel 包的分步说明。

### Linux 上的 Git Credential Manager

如果你在 Linux 上遇到 Git 认证问题，请参阅[离线隔离环境安装指南](install/air-gapped.md#git-credential-manager-on-linux)中的 Git Credential Manager 配置说明。
