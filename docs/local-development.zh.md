<!-- zh-source: docs/local-development.md -->
<!-- zh-base: ec45dbd -->

# 本地开发指南

本指南介绍如何在本地迭代 `specify` CLI，而不必先发布 release 或向 `main` 提交代码。

> 脚本现在同时提供 Bash（`.sh`）和 PowerShell（`.ps1`）两种变体。除非传入 `--script sh|ps`，CLI 会根据操作系统自动选择。

## 1. 克隆并切换分支

```bash
git clone https://github.com/github/spec-kit.git
cd spec-kit
# 在功能分支上工作
git checkout -b your-feature-branch
```

## 2. 直接运行 CLI（反馈最快）

无需安装任何东西，就可以通过模块入口执行 CLI：

```bash
# 在仓库根目录
python -m src.specify_cli --help
python -m src.specify_cli init demo-project --integration claude --ignore-agent-tools --script sh
```

如果你更喜欢以脚本文件方式调用（利用 shebang）：

```bash
python src/specify_cli/__init__.py init demo-project --script ps
```

## 3. 使用可编辑安装（隔离环境）

用 `uv` 创建隔离环境，让依赖解析结果与最终用户拿到的完全一致：

```bash
# 创建并激活虚拟环境（uv 自动管理 .venv）
uv venv
source .venv/bin/activate  # Windows PowerShell 上使用：.venv\Scripts\Activate.ps1

# 以可编辑模式安装项目
uv pip install -e .

# 现在 'specify' 入口命令已可用
specify --help
```

得益于可编辑模式，修改代码后重新运行无需重新安装。

## 4. 用 uvx 直接从 Git 调用（当前分支）

`uvx` 可以从本地路径（或 Git 引用）运行，以模拟用户的使用流程：

```bash
uvx --from . specify init demo-uvx --integration copilot --ignore-agent-tools --script sh
```

你也可以让 uvx 指向某个特定分支，而无需先 merge：

```bash
# 先推送你的工作分支
git push origin your-feature-branch
uvx --from git+https://github.com/github/spec-kit.git@your-feature-branch specify init demo-branch-test --script ps
```

### 4a. 绝对路径 uvx（任意位置运行）

如果你在其他目录，用绝对路径代替 `.`：

```bash
uvx --from /mnt/c/GitHub/spec-kit specify --help
uvx --from /mnt/c/GitHub/spec-kit specify init demo-anywhere --integration copilot --ignore-agent-tools --script sh
```

设置环境变量更方便：

```bash
export SPEC_KIT_SRC=/mnt/c/GitHub/spec-kit
uvx --from "$SPEC_KIT_SRC" specify init demo-env --integration copilot --ignore-agent-tools --script ps
```

（可选）定义一个 shell 函数：

```bash
specify-dev() { uvx --from /mnt/c/GitHub/spec-kit specify "$@"; }
# 然后
specify-dev --help
```

## 5. 测试脚本权限逻辑

运行 `init` 之后，检查 shell 脚本在 POSIX 系统上是否可执行：

```bash
ls -l scripts | grep .sh
# 应看到属主的可执行位（例如 -rwxr-xr-x）
```

在 Windows 上你会改用 `.ps1` 脚本（无需 chmod）。

## 6. 为内置集成生成脚手架

使用集成脚手架命令，为新的内置集成创建初始的 Python 包和测试骨架：

```bash
specify integration scaffold my-agent --type markdown
specify integration scaffold my-agent --type toml
specify integration scaffold my-agent --type yaml
specify integration scaffold my-agent --type skills
```

带连字符的键会被转换为 Python 安全的包名，例如 `my-agent` 会创建 `src/specify_cli/integrations/my_agent/` 和 `tests/integrations/test_integration_my_agent.py`。

脚手架不会自动注册集成。请检查生成的元数据，然后在 `src/specify_cli/integrations/__init__.py` 中添加 import 和 `_register()` 调用。

## 7. 运行 Lint / 基础检查

CI 会强制执行 `ruff check src tests`（见 `.github/workflows/test.yml`），所以推送前先在本地运行：

```bash
uvx ruff check src tests
```

也可以快速检查一下可导入性：

```bash
python -c "import specify_cli; print('Import OK')"
```

## 8. 本地构建 Wheel（可选）

发布前验证打包：

```bash
uv build
ls dist/
```

如有需要，把构建出的产物安装到一个全新的一次性环境中验证。

## 9. 使用临时工作区

在脏目录中测试 `init --here` 时，先创建一个临时工作区：

```bash
mkdir /tmp/spec-test && cd /tmp/spec-test
python -m src.specify_cli init --here --integration claude --ignore-agent-tools --script sh  # 前提是仓库已复制到这里
```

如果想要更轻量的沙箱，也可以只复制修改过的 CLI 部分。

## 10. 调试网络 / TLS 问题

> **已弃用：** `--skip-tls` 标志现在是空操作，不产生任何效果。
> 它以前用于在本地测试时绕过 TLS 校验。
> 如果你遇到 TLS 错误（例如在公司网络中），请改为配置环境的证书存储或代理。
>
> 例如，设置 `SSL_CERT_FILE`，或配置 `HTTPS_PROXY` / `HTTP_PROXY`。

## 11. 快速编辑循环速览

| 操作 | 命令 |
|--------|---------|
| 直接运行 CLI | `python -m src.specify_cli --help` |
| 可编辑安装 | `uv pip install -e .`，之后运行 `specify ...` |
| 本地 uvx 运行（仓库根目录） | `uvx --from . specify ...` |
| 本地 uvx 运行（绝对路径） | `uvx --from /mnt/c/GitHub/spec-kit specify ...` |
| Git 分支 uvx 运行 | `uvx --from git+URL@branch specify ...` |
| 构建 wheel | `uv build` |

## 12. 清理

快速删除构建产物 / 虚拟环境：

```bash
rm -rf .venv dist build *.egg-info
```

## 13. 常见问题

| 症状 | 解决办法 |
|---------|-----|
| `ModuleNotFoundError: typer` | 运行 `uv pip install -e .` |
| 脚本不可执行（Linux） | 重新运行 init，或执行 `chmod +x scripts/*.sh` |
| Git 命令不可用 | 用 `specify extension add git` 安装 git 扩展 |
| 下载了错误的脚本类型 | 显式传入 `--script sh` 或 `--script ps` |
| 公司网络下出现 TLS 错误 | 配置环境的证书存储或代理。`--skip-tls` 标志已弃用且不产生任何效果。 |

## 14. 下一步

- 更新文档，并用你修改后的 CLI 走一遍快速上手流程
- 满意后创建 PR
- （可选）变更进入 `main` 后打一个 release tag
