<!-- zh-source: docs/install/air-gapped.md -->
<!-- zh-base: 707e929 -->

# 企业 / 离线隔离环境安装

如果你的环境无法访问 PyPI 或 GitHub，可以在一台联网机器上创建可移植的 wheel 包，再传输到离线隔离（air-gapped）的目标机器上。

## 第 1 步：在联网机器上构建 wheel

> **重要**：`pip download` 解析的是平台相关的 wheel（例如 PyYAML 包含原生扩展）。你必须在与离线目标机器**操作系统和 Python 版本相同**的机器上执行这一步。如果需要支持多个平台，请在每个目标操作系统（Linux、macOS、Windows）和 Python 版本上分别重复这一步。

```bash
# 克隆仓库
git clone https://github.com/github/spec-kit.git
cd spec-kit

# 构建 wheel
pip install build
python -m build --wheel --outdir dist/

# 下载该 wheel 及其全部运行时依赖
pip download -d dist/ dist/specify_cli-*.whl
```

## 第 2 步：传输 `dist/` 目录

把整个 `dist/` 目录（包含 `specify-cli` 的 wheel 及所有依赖的 wheel）通过 U 盘、网络共享或其他获准的传输方式复制到目标机器。

## 第 3 步：在离线机器上安装

```bash
pip install --no-index --find-links=./dist specify-cli
```

## 第 4 步：初始化项目

不需要任何网络访问——默认使用随包内置的资源：

```bash
specify init my-project --integration copilot
```

> **注意**：需要 Python 3.11+。

> **Windows 注意**：离线脚手架需要 PowerShell 7+（`pwsh`），而不是 Windows PowerShell 5.x（`powershell.exe`）。请从 https://aka.ms/powershell 安装。

## Linux 上的 Git Credential Manager

如果你在 Linux 上遇到 Git 认证问题，可以安装 Git Credential Manager：

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```
