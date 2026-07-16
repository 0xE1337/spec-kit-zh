<!-- zh-source: docs/install/pipx.md -->
<!-- zh-base: 82c078b -->

# 用 pipx 安装

[pipx](https://pipx.pypa.io/) 是一个在隔离环境中安装 Python CLI 应用的工具。它不需要 [uv](https://docs.astral.sh/uv/)。

## 安装 Specify CLI

为保证稳定，固定到特定的发布 tag（最新 tag 见 [Releases](https://github.com/github/spec-kit/releases)）：

```bash
# 安装特定稳定版（推荐——把 vX.Y.Z 替换为最新 tag，
# 保留开头的 v，例如 v0.12.11 而不是 0.12.11）
pipx install git+https://github.com/github/spec-kit.git@vX.Y.Z

# 或从 main 安装最新代码（可能包含未发布的变更）
pipx install git+https://github.com/github/spec-kit.git
```

## 验证

```bash
specify version
```

## 升级

```bash
pipx install --force git+https://github.com/github/spec-kit.git@vX.Y.Z
```

## 卸载

```bash
pipx uninstall specify-cli
```

## 下一步

前往[快速上手](../quickstart.md)初始化你的第一个项目。
