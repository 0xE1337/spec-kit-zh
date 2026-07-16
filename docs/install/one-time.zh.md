<!-- zh-source: docs/install/one-time.md -->
<!-- zh-base: 82c078b -->

# 一次性使用（uvx）

如果你想在不永久安装的情况下试用 Spec Kit，可以用 `uvx` 直接运行。它会把工具下载到一个临时环境中，命令结束后即被丢弃。

> [!NOTE]
> 下面的命令需要 **[uv](https://docs.astral.sh/uv/)**。如果看到 `command not found: uvx`，请先[安装 uv](uv.md)。

## 运行 Specify CLI

```bash
# 创建新项目（main 分支最新代码）
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# 或指定某个发布版（把 vX.Y.Z 替换为 Releases 页面上的 tag；
# 保留开头的 v，例如 v0.12.11 而不是 0.12.11）
uvx --from git+https://github.com/github/spec-kit.git@vX.Y.Z specify init <PROJECT_NAME>

# 在当前目录初始化
uvx --from git+https://github.com/github/spec-kit.git specify init . --integration copilot

# 或使用 --here 标志
uvx --from git+https://github.com/github/spec-kit.git specify init --here --integration copilot
```

## 什么时候应该改用持久安装

如果你打算经常使用 Spec Kit，推荐持久安装：

- 工具保持安装状态，随时可在 PATH 中使用
- 每次调用不必重新下载
- 可以用 `uv tool list`、`uv tool upgrade`、`uv tool uninstall` 更好地管理工具

持久安装说明见主[安装指南](../installation.md)。
