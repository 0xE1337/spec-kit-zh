<!-- zh-source: docs/install/uv.md -->
<!-- zh-base: 38bb88b -->

# 安装 uv

[uv](https://docs.astral.sh/uv/) 是 [Astral](https://astral.sh/) 出品的高速 Python 包管理器。Spec Kit 通过 `uv`（借助 `uvx` 或 `uv tool install`）运行 `specify` CLI，不会污染你的全局 Python 环境。

> [!NOTE]
> **已经装了 uv？** 运行 `uv --version` 确认安装无误，然后回到[安装指南](../installation.md)。

## 安装

### macOS 和 Linux——独立安装脚本

在 macOS 或 Linux 上安装 uv 最快的方式是官方 shell 脚本：

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

脚本运行结束后，按照安装器打印的提示把 uv 加入 `PATH`，然后打开一个新终端。

### Windows——独立安装脚本

在**命令提示符或 PowerShell** 中运行：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

脚本运行结束后，打开一个新终端，让 `uv` 可执行文件出现在 `PATH` 中。

### macOS——Homebrew

```bash
brew install uv
```

### Windows——WinGet

```powershell
winget install --id=astral-sh.uv -e
```

### Windows——Scoop

```powershell
scoop install uv
```

## 验证

确认 uv 已安装并在 `PATH` 中：

```bash
uv --version
```

你应该会看到类似 `uv 0.x.y (...)` 的输出。

## 延伸阅读

高级选项（自更新、代理设置、卸载等）见官方 [uv 安装文档](https://docs.astral.sh/uv/getting-started/installation/)。
