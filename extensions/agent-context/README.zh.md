<!-- zh-source: extensions/agent-context/README.md -->
<!-- zh-base: 53d9543 -->

# 编码智能体上下文扩展

这个内置扩展负责管理当前生效集成的**编码智能体上下文/指令文件**（例如 `CLAUDE.md`、`.github/copilot-instructions.md`、`AGENTS.md`、`GEMINI.md` 等）。

它拥有受管区块（managed section）的完整生命周期——该区块由可配置的起止标记界定（默认：`<!-- SPECKIT START -->` / `<!-- SPECKIT END -->`）。

## 为什么做成扩展？

不是每个 Spec Kit 用户都希望 Spec Kit 写入编码智能体的上下文文件。把这个行为放进一个独立的、**按需启用（opt-in）**的扩展，让用户可以：

- **自主决定是否安装**——`specify init` 不会安装它。想让 Spec Kit 管理智能体上下文文件时再显式添加；如果它不存在或被停用，Spec Kit 绝不会创建或修改该文件。
- **自定义标记**：编辑 `.specify/extensions/agent-context/agent-context-config.yml`——内置脚本会遵循 `context_markers` 的值。
- **同步多个智能体锚点文件**：当项目有意使用多个编码智能体上下文文件（例如 `AGENTS.md` 和 `CLAUDE.md`）时，设置 `context_files`。
- **按需刷新**：在你的智能体中运行 `speckit.agent-context.update` 命令，或通过 `extension.yml` 中声明的钩子（`after_specify`、`after_plan`）自动刷新。调用时使用你的智能体的斜杠命令分隔符——点分隔的智能体用 `/speckit.agent-context.update`，连字符分隔的智能体（例如 Forge、Cline）用 `/speckit-agent-context-update`。

## 命令

下面的命令 ID 是规范形式。作为斜杠命令调用时，使用你的智能体的分隔符：点分隔的智能体用 `/speckit.agent-context.update`，连字符分隔的智能体（例如 Forge、Cline）用 `/speckit-agent-context-update`。

| 命令 | 说明 |
|---------|-------------|
| `speckit.agent-context.update` | 用当前计划路径刷新智能体上下文文件中的受管区块。 |

## 配置

所有配置都通过本扩展自己的配置文件流转，位于
`.specify/extensions/agent-context/agent-context-config.yml`：

```yaml
# 本扩展管理的编码智能体上下文文件路径
context_file: CLAUDE.md

# 可选：需要一并管理的多个编码智能体上下文文件列表。
# 非空时，它优先于 context_file。
context_files:
  - AGENTS.md
  - CLAUDE.md

# 受管 Spec Kit 区块的分界标记
context_markers:
  start: "<!-- SPECKIT START -->"
  end: "<!-- SPECKIT END -->"
```

- `context_file`——编码智能体上下文文件相对项目的路径。为空时，内置更新脚本会在本扩展自己的 `agent-context-defaults.json` 映射中查找当前生效集成的键，自行填充默认值。绝不会咨询 Specify CLI。
- `context_files`——可选，多个编码智能体上下文文件相对项目的路径。非空时，该列表优先于 `context_file`。绝对路径、反斜杠分隔符和 `..` 路径段会被拒绝。
- `context_markers.start` / `.end`——受管区块两端的分界标记。可编辑为自定义标记。

## 依赖要求

内置更新脚本需要 **Python 3** 和 **PyYAML** 来做 YAML/upsert 处理（PowerShell 在可用时也可以使用 `ConvertFrom-Yaml`）。

PyYAML 随 `specify` CLI 一起分发，通常可以通过同一个 `python3` 解释器获得。如果钩子报告 *"PyYAML is required … not available in the current Python environment"*，说明系统的 `python3` 与安装 Spec Kit 所用的不是同一个。解决方法：

```bash
pip install pyyaml
# 或指定 Spec Kit 使用的那个解释器：
/path/to/speckit-python -m pip install pyyaml
```

## 停用

```bash
specify extension disable agent-context
```

当停用（或从未安装）时，Spec Kit 不会对智能体上下文文件做任何创建、更新或删除——本扩展的内置脚本是唯一会触碰受管区块的代码。Specify CLI 完全不携带 agent-context 状态：它从不读取此配置，从不解析上下文文件，任何模板中的 `__CONTEXT_FILE__` 占位符（如果存在）也会原样保留。所有关于上下文文件的知识——包括 `agent-context-defaults.json` 中按智能体的默认映射——都完整地存在于本扩展内部，因此停用它就是彻底的退出。
