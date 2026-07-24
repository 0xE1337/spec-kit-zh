<!-- zh-source: extensions/agent-context/README.md -->
<!-- zh-base: a62fb1f -->

# 编码智能体上下文扩展

这个内置扩展负责管理当前生效集成的**编码智能体上下文/指令文件**（例如 `CLAUDE.md`、`.github/copilot-instructions.md`、`AGENTS.md`、`GEMINI.md` 等）。

它拥有受管区块（managed section）的完整生命周期——该区块由可配置的起止标记界定（默认：`<!-- SPECKIT START -->` / `<!-- SPECKIT END -->`）。对于 `.mdc` 文件，它还会确保 YAML front matter（文件顶部的元数据块）包含 `alwaysApply: true`。除此之外，受管区块以外的一切都不会被改动。

> 注意：Spec Kit 本身绝不会触碰你的智能体上下文文件。只有这个扩展会，而且它是按需启用（opt-in）的：想让这个区块保持同步就安装它，想自己管理那个文件就跳过它。

## 为什么做成扩展？

不是每个 Spec Kit 用户都希望 Spec Kit 写入编码智能体的上下文文件。把这个行为放进一个独立的、**按需启用（opt-in）**的扩展，让用户可以：

- **自主决定是否安装**——`specify init` **不会**安装它。想让 Spec Kit 管理智能体上下文文件时再显式添加；当它不存在时，该文件绝不会被修改，当它被停用时，它的自动钩子不会运行。
- **自定义标记**：编辑 `.specify/extensions/agent-context/agent-context-config.yml`（本仓库中的 [agent-context-config.yml](./agent-context-config.yml)）——内置脚本会遵循 `context_markers` 的值。
- **同步多个智能体锚点文件**：当项目有意使用多个编码智能体上下文文件（例如 `AGENTS.md` 和 `CLAUDE.md`）时，设置 `context_files`。
- **按需刷新**：在你的智能体中运行 `speckit.agent-context.update` 命令，或通过 [extension.yml](./extension.yml) 中声明的钩子（`after_specify`、`after_plan`）自动刷新。

## 安装

要安装本扩展，在一个已初始化的 Spec Kit 项目根目录下运行：

```bash
specify extension add agent-context
```

## 停用

```bash
specify extension disable agent-context

# 重新启用
specify extension enable agent-context
```

当本扩展被停用（或未安装）时，Spec Kit 中没有任何东西会创建、更新或移除受管区块——任何模板中的 `__CONTEXT_FILE__` 占位符都会原样保留，本扩展自己的配置也绝不会被读取。

## 命令

| 命令 | 说明 |
| ------------------------------ | --------------------------------------------------------------------------------- |
| `speckit.agent-context.update` | 用当前计划路径刷新智能体上下文文件中的受管区块。 |

> 注意：上面的命令 ID 是规范形式。请使用你的集成对应的语法来调用：点命令集成用 `/speckit.agent-context.update`；连字符/技能集成（包括 Forge 和 Cline）用 `/speckit-agent-context-update`；技能模式下的 Codex 或 ZCode 用 `$speckit-agent-context-update`；Kimi 用 `/skill:speckit-agent-context-update`。

## 配置

所有配置都通过本扩展自己的配置文件流转，位于 `.specify/extensions/agent-context/agent-context-config.yml`（仓库中的 [agent-context-config.yml](./agent-context-config.yml)）。

## 依赖要求

内置更新脚本需要 **Python 3** 和 **PyYAML** 来做 YAML/upsert 处理（PowerShell 在可用时也可以使用 `ConvertFrom-Yaml`）。

PyYAML 随 `specify` CLI 一起分发，通常可以通过同一个 `python3` 解释器获得。如果钩子报告 _"PyYAML is required … not available in the current Python environment"_，说明系统的 `python3` 与安装 Spec Kit 所用的不是同一个。解决方法：

```bash
pip install pyyaml
# 或指定 Spec Kit 使用的那个解释器：
/path/to/speckit-python -m pip install pyyaml
```

## 问题反馈

如遇其他任何问题，请在 [官方 GitHub 仓库](https://github.com/github/spec-kit/issues) 创建 issue。
