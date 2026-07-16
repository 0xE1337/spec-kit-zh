<!-- zh-source: docs/install/pypi.md -->
<!-- zh-base: ad601e5 -->

# 从 PyPI 安装

Spec Kit 以 [`specify-cli`](https://pypi.org/project/specify-cli/) 的名字发布到 PyPI，由 Spec Kit 维护者维护。从 PyPI 安装是与[从 GitHub 源码安装](../installation.md#install-from-source--persistent-installation-recommended)并列的第二条受支持安装路线。选择适合你工作流的方式即可——两者提供的是同一个 `specify` CLI。

> [!NOTE]
> PyPI 的发布版本与 GitHub 的发布 tag 保持对应（例如 PyPI 的 `0.12.11` 对应 `v0.12.11` 这个 tag）。`specify version` 只是本地版本/运行时的快速检查——它报告已安装的版本，但看不出 `specify` 可执行文件来自哪里，因此无法区分 PyPI 安装和 Git 安装。要确认安装来源，请检查包管理器记录的来源元数据：`pipx list --json` 会报告每个工具确切的安装规格；对于 uv/pip 安装，可以查看包的 `*.dist-info` 目录中的 [PEP 610](https://peps.python.org/pep-0610/) `direct_url.json` 文件（Git 或 URL 安装会在其中记录仓库/归档的 URL，而普通的 PyPI 索引安装不会创建这个文件）。注意 `pip show specify-cli` 只打印包元数据，而且从宿主解释器看不到由 uv/pipx 管理的环境。

## 安装 Specify CLI

用你手头已有的 Python 工具即可：

```bash
# 使用 uv（推荐）
uv tool install specify-cli

# 或使用 pipx
pipx install specify-cli

# 或使用 pip
pip install specify-cli
```

### 安装特定发布版

固定精确版本以获得可复现的安装（可用版本见 [PyPI](https://pypi.org/project/specify-cli/#history) 或 [Releases](https://github.com/github/spec-kit/releases)）：

```bash
# 使用 uv
uv tool install specify-cli==0.12.11

# 或使用 pipx
pipx install specify-cli==0.12.11

# 或使用 pip
pip install specify-cli==0.12.11
```

## 验证

```bash
specify version
```

## 初始化项目

```bash
specify init <PROJECT_NAME> --integration copilot
```

## 升级

通过当初安装时用的那个工具重新安装即可升级。如果你最初固定了版本，注意 `uv tool upgrade` 会保留这个固定版本；要升到 PyPI 的最新发布版，请使用不固定版本的安装命令，避免停留在现有版本上：

```bash
# 使用 uv
uv tool install --force specify-cli

# 或使用 pipx
pipx install --force specify-cli

# 或使用 pip
pip install --upgrade specify-cli
```

> [!NOTE]
> `specify self upgrade` 目前会基于 GitHub 源码发布 URL 重建 `uv tool` 和 `pipx` 安装，而不会保留基于 PyPI 的安装。如果你想留在 PyPI 路线上，请使用上面的包管理器命令。普通的 `pip install specify-cli` 被视为非托管安装——用 `pip install --upgrade specify-cli` 升级它。详见[升级指南](../upgrade.md)。

## 卸载

```bash
# 使用 uv
uv tool uninstall specify-cli

# 或使用 pipx
pipx uninstall specify-cli

# 或使用 pip
pip uninstall specify-cli
```

## 下一步

前往[快速上手](../quickstart.md)初始化你的第一个项目。
