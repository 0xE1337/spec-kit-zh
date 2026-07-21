<!-- zh-source: docs/reference/integrations.md -->
<!-- zh-base: 74662cf -->

# 支持的 AI 编码智能体集成

Specify CLI 支持范围广泛的 AI 编码智能体。运行 `specify init` 时，CLI 会为你选择的 AI 编码智能体配置相应的命令文件和目录结构——无论你偏好哪个工具，都能立即开始规范驱动开发。

## 支持的 AI 编码智能体

| 智能体 | Key | 备注 |
| ------ | --- | ---- |
| [Amp](https://ampcode.com/) | `amp` | |
| [Antigravity (agy)](https://antigravity.google/) | `agy` | 基于技能的集成；技能会自动安装 |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview) | `auggie` | |
| [Claude Code](https://www.anthropic.com/claude-code) | `claude` | 基于技能的集成；技能安装到 `.claude/skills` |
| [Cline](https://github.com/cline/cline) | `cline` | 基于 IDE 的智能体 |
| [CodeBuddy CLI](https://www.codebuddy.cn/docs/cli/installation) | `codebuddy` | |
| [Codex CLI](https://github.com/openai/codex) | `codex` | 基于技能的集成；技能安装到 `.agents/skills`，以 `$speckit-<command>` 方式调用 |
| [Cursor](https://cursor.sh/) | `cursor-agent` | |
| [Devin for Terminal](https://cli.devin.ai/docs) | `devin` | 基于技能的集成；技能安装到 `.devin/skills/`，以 `/speckit-<command>` 方式调用 |
| [Firebender](https://firebender.com/) | `firebender` | 面向 Android Studio / IntelliJ 的基于 IDE 的智能体 |
| [Forge](https://forgecode.dev/) | `forge` | |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | `gemini` | |
| [GitHub Copilot](https://code.visualstudio.com/) | `copilot` | 默认使用旧版 markdown 模式：`.github/agents/` 下的 `.agent.md` 命令文件、`.github/prompts/` 下配套的 `.prompt.md` 文件，以及一次 `.vscode/settings.json` 合并。传入 `--integration-options="--skills"` 可改为在 `.github/skills/` 下以 `speckit-<command>/SKILL.md` 形式生成技能脚手架。旧版 markdown 模式已弃用，未来的版本将不再把它作为默认方式 |
| [Goose](https://goose-docs.ai/) | `goose` | 使用 `.goose/recipes/` 下的 YAML recipe 格式 |
| [Grok Build](https://docs.x.ai/build/overview) | `grok` | 基于技能的集成；技能安装到 `.grok/skills`，以 `/speckit-<command>` 方式调用 |
| [Hermes](https://github.com/NousResearch/hermes-agent) | `hermes` | 基于技能的集成；技能全局安装到 `~/.hermes/skills/` |
| [IBM Bob](https://www.ibm.com/products/bob) | `bob` | 默认基于技能的集成；在 `.bob/skills/` 下以 `speckit-<command>/SKILL.md` 形式安装技能，并以 `/speckit-<command>` 调用。传入 `--integration-options="--legacy-commands"` 可改为生成已弃用的 Bob 1.x 布局（`.bob/commands/*.md`）；该标志将在未来版本中移除。已有的旧版安装可用 `specify integration upgrade bob --integration-options="--skills"` 迁移，它会转换为技能布局并删除旧的命令文件。如果安装了预设覆盖，迁移会被拒绝并给出可操作的报错（预设产物目前尚无法在布局变更间对账）——请先移除预设、迁移，再重新安装它们。 |
| [Junie](https://junie.jetbrains.com/) | `junie` | |
| [Kilo Code](https://github.com/Kilo-Org/kilocode) | `kilocode` | |
| [Kimi Code](https://code.kimi.com/) | `kimi` | 基于技能的集成；安装到 `.kimi-code/skills/`。`--migrate-legacy` 会把旧的 `.kimi/skills/` 安装迁移到新路径 |
| [Kiro CLI](https://kiro.dev/docs/cli/) | `kiro-cli` | Kiro CLI 不会在基于文件的提示词中替换 `$ARGUMENTS`，因此 Spec Kit 会在渲染时提供一段文字说明作为回退（见[管理提示词](https://kiro.dev/docs/cli/chat/manage-prompts/)和 issue [#1926](https://github.com/github/spec-kit/issues/1926)）。别名：`--integration kiro` |
| [Lingma](https://lingma.aliyun.com/) | `lingma` | 基于技能的集成；技能会自动安装 |
| [Mistral Vibe](https://github.com/mistralai/mistral-vibe) | `vibe` | |
| [Oh My Pi](https://www.npmjs.com/package/@oh-my-pi/pi-coding-agent) | `omp` | 斜杠命令安装到 `.omp/commands` |
| [opencode](https://opencode.ai/) | `opencode` | |
| [Pi Coding Agent](https://pi.dev) | `pi` | Pi 默认不带 MCP 支持，因此 `taskstoissues` 无法按预期工作。可以通过[扩展](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent#extensions)添加 MCP 支持 |
| [Qoder CLI](https://qoder.com/cli) | `qodercli` | |
| [Qwen Code](https://github.com/QwenLM/qwen-code) | `qwen` | |
| [RovoDev](https://www.atlassian.com/software/rovo-dev) | `rovodev` | 生成 `.rovodev/skills/`、提示词包装文件和 `prompts.yml`；运行时通过 `acli rovodev` 调度 |
| [SHAI (OVHcloud)](https://github.com/ovh/shai) | `shai` | |
| [Tabnine CLI](https://docs.tabnine.com/main/getting-started/tabnine-cli) | `tabnine` | |
| [Trae](https://www.trae.ai/) | `trae` | 基于技能的集成；技能会自动安装 |
| [ZCode](https://zcode.z.ai/) | `zcode` | 基于技能的集成；技能安装到 `.zcode/skills/`，以 `$speckit-<command>` 方式调用 |
| [Zed](https://zed.dev/) | `zed` | 基于技能的集成；技能安装到 `.agents/skills`，以 `/speckit-<command>` 方式调用 |
| Generic | `generic` | 自带智能体——对于上面没有列出的 AI 编码智能体，使用 `--integration generic --integration-options="--commands-dir <path>"` |

## 列出可用集成

```bash
specify integration list
```

| 选项 | 说明 |
| ----------- | ---- |
| `--catalog` | 同时浏览目录源（内置**和**社区）。未内置的社区集成只在此处显示。 |

显示内置集成、当前安装的是哪个，以及每个集成需要 CLI 工具还是基于 IDE。
当安装了多个集成时，列表会把默认集成与其他已安装集成分开标注。
列表还会显示每个内置集成是否声明为多安装安全（multi-install safe）。

## 搜索可用集成

```bash
specify integration search [query]
```

| 选项 | 说明 |
| ---------- | ------------------ |
| `--tag`    | 按标签过滤 |
| `--author` | 按作者过滤 |

在当前生效的目录源栈中搜索匹配查询的集成。不带查询时，列出所有可用集成。必须在 Spec Kit 项目内运行。

## 集成详情

```bash
specify integration info <integration_id>
```

显示单个集成的目录源详情，包括描述、作者、许可证、标签、来源目录源、仓库（如果有）以及它当前是否处于激活状态。必须在 Spec Kit 项目内运行。

## 安装集成

```bash
specify integration install <key>
```

| 选项 | 说明 |
| ------------------------ | ------------------------------------------------------------------------ |
| `--script sh\|ps`        | 脚本类型：`sh`（bash/zsh）或 `ps`（PowerShell） |
| `--force`                | 主动选择与未声明多安装安全的集成一起安装 |
| `--integration-options`  | 集成特定的选项（例如 `--integration-options="--commands-dir .myagent/cmds"`） |

把指定的集成安装到当前项目。如果已经安装了另一个集成，只有当涉及的所有集成都声明为多安装安全时，命令才会自动继续。否则，使用 `switch` 替换默认集成，或传入 `--force` 明确选择多安装。如果安装中途失败，会自动回滚到干净状态。

安装额外的集成不会改变默认集成。使用 `specify integration use <key>` 更改默认集成。

> **注意：** 所有集成管理命令都要求项目已经用 `specify init` 初始化过。要用特定智能体启动新项目，请改用 `specify init <project> --integration <key>`。

**版本说明：** 受控的多安装支持是在 Spec Kit 0.8.5 中引入的。如果 `specify integration install <key>` 提示已安装了另一个集成，并且只建议 `switch` 或 `uninstall`，请用 `specify version` 检查本地 CLI 并升级。运行 `uvx --from git+https://github.com/github/spec-kit.git specify ...` 这类一次性命令时，只会为该命令使用一份临时副本；它不会更新你 `PATH` 上持久安装的 `specify` 可执行文件。

## 卸载集成

```bash
specify integration uninstall [<key>]
```

| 选项 | 说明 |
| --------- | --------------------------------------------------- |
| `--force` | 即使文件被修改过也一并移除 |

卸载当前集成（或指定的集成）。Spec Kit 会跟踪安装期间创建的每个文件，并记录原始内容的 SHA-256 哈希：

- **未修改的文件**会被自动移除。
- **已修改的文件**（你做过手动编辑的）会被保留，以免丢失你的定制内容。
- 使用 `--force` 可以不论是否修改过，移除全部集成文件。

## 切换到另一个集成

```bash
specify integration switch <key>
```

| 选项 | 说明 |
| ------------------------ | ------------------------------------------------------------------------ |
| `--script sh\|ps`        | 脚本类型：`sh`（bash/zsh）或 `ps`（PowerShell） |
| `--force`                | 卸载时强制移除已修改的文件；当目标集成已安装时，在更改默认集成的同时覆盖受管的共享模板 |
| `--refresh-shared-infra` | 即使你定制过共享基础设施文件也一并覆盖（否则会保留你的定制） |
| `--integration-options`  | 目标集成尚未安装时使用的选项 |

如果目标集成尚未安装，等价于一步完成 `uninstall` 再 `install`。此模式下，`--force` 控制是否删除被移除集成中已修改的文件。如果目标集成已经安装，`switch` 只更改默认集成，效果同 `use`；此模式下，`--force` 控制在更改默认集成时是否覆盖受管的共享模板。对于已安装的目标集成，`--integration-options` 会被拒绝，因为更改集成选项需要重新安装受管文件；请先运行 `upgrade <key> --integration-options ...`，再运行 `use <key>`。

## 使用已安装的集成

```bash
specify integration use <key>
```

| 选项 | 说明 |
| --------- | --------------------------------------------------- |
| `--force` | 在更改默认集成的同时覆盖受管的共享模板 |

设置默认集成，而不卸载任何其他已安装的集成。这同时会刷新受管的共享模板，使其中的命令引用与新默认集成的调用风格一致。已修改或未被跟踪的共享模板会被保留，除非使用 `--force`。

## 升级集成

```bash
specify integration upgrade [<key>]
```

| 选项 | 说明 |
| ------------------------ | ------------------------------------------------------------------------ |
| `--force`                | 即使文件被修改过也一并覆盖 |
| `--script sh\|ps`        | 脚本类型：`sh`（bash/zsh）或 `ps`（PowerShell） |
| `--integration-options`  | 集成的选项 |

用更新后的模板和命令重新安装一个已安装的集成（例如在升级 Spec Kit 之后）。默认作用于默认集成；如果提供了 key，它必须是已安装的集成之一。会检测本地修改过的文件并阻止升级，除非使用 `--force`。上一次安装遗留下来、不再需要的过期文件会被自动移除。即使升级的是非默认集成，共享模板也会保持与默认集成对齐。

## 报告集成状态

```bash
specify integration status
specify integration status --json
```

在不改动文件的前提下报告当前项目的集成状态。状态报告包括：默认集成、已安装的集成、多安装安全性、缺失的受管文件、被修改的受管文件、无效的清单路径、共享 Spec Kit 基础设施的健康状况、未检查的清单，以及依赖默认集成的共享模板所指向的目标集成。JSON 形式面向 CI 和需要稳定、机器可读状态数据的编码智能体；当状态修复启发式与记录文件不一致时，它还会报告原始记录的集成列表和实际检查过的集成清单。
报告状态为 `ok` 或 `warning` 时命令以 0 退出；只有报告状态为 `error` 时才以 1 退出。在 JSON 输出中，当无法评估任何已安装集成集合时——例如集成状态缺失、不可读、缺少有效的集成记录列表，或没有记录任何已安装集成——`multi_install_safe` 为 `null`。

## 目录源管理

集成目录源决定发现类命令（`search` 和 `info`）从哪里查找集成。目录源按优先级顺序检查。

### 列出目录源

```bash
specify integration catalog list
```

显示当前生效的目录源。项目级来源（如果配置了）可以按索引移除；其余生效来源显示为不可移除。

### 添加目录源

```bash
specify integration catalog add <url>
```

| 选项 | 说明 |
| --------------- | ----------------------------- |
| `--name <name>` | 目录源的可选名称 |

把自定义目录源 URL 添加到项目的 `.specify/integration-catalogs.yml`。URL 必须使用 HTTPS（本地测试用的 `http://localhost`、`http://127.0.0.1` 或 `http://[::1]` 除外）。

### 移除目录源

```bash
specify integration catalog remove <index>
```

按 `catalog list` 中的 0 起始索引移除一个项目目录源。

### 目录源解析顺序

目录源按以下顺序解析（第一个匹配者胜出）：

1. **环境变量** —— `SPECKIT_INTEGRATION_CATALOG_URL` 覆盖所有目录源
2. **项目配置** —— `.specify/integration-catalogs.yml`
3. **用户配置** —— `~/.specify/integration-catalogs.yml`
4. **内置默认值** —— 官方目录源 + 社区目录源

## 集成特定选项

部分集成可以通过 `--integration-options` 接受额外选项：

| 集成 | 选项 | 说明 |
| ----------- | ------------------- | -------------------------------------------------------------- |
| `generic`   | `--commands-dir`    | 必填。命令文件的目录 |
| `kimi`      | `--migrate-legacy`  | 把旧的 `.kimi/skills/` 安装迁移到 `.kimi-code/skills/`（包括把点分技能名改为连字符命名，例如 `speckit.xxx` → `speckit-xxx`） |
| `copilot`   | `--skills`          | 以智能体技能形式生成命令脚手架（`.github/skills/` 下的 `speckit-<command>/SKILL.md`，以 `/speckit-<command>` 方式调用），替代默认的旧版 markdown 模式（`.github/agents/*.agent.md` 加 `.github/prompts/*.prompt.md`，以及一次 `.vscode/settings.json` 合并）。不带此标志时，安装会警告旧版 markdown 模式已弃用。 |

示例：

```bash
specify integration install generic --integration-options="--commands-dir .myagent/cmds"
```

## 为新集成生成脚手架

```bash
specify integration scaffold <key>
```

在 Spec Kit 仓库中创建一个最小化的内置集成包和配套的测试骨架，然后打印后续接入步骤。请在 Spec Kit 仓库根目录运行此命令。`<key>` 必须是小写 kebab-case（例如 `my-agent`）。

| 选项 | 说明 |
| -------- | ---------------------------------------------------------------- |
| `--type` | 使用的脚手架模板：`markdown`（默认）、`skills`、`toml` 或 `yaml` |

## 常见问题

### 可以在同一个项目里安装多个集成吗？

可以，但这个能力面向的是团队可移植性，不是默认工作流。只有当已安装的集成和新集成都被 Spec Kit 声明为多安装安全时，多集成才会被自动允许。其他组合需要传入 `--force`，以确认你知晓多个智能体可能看到彼此无关的智能体特定指令或命令。

Spec Kit 在 `.specify/integration.json` 中用 `default_integration` 跟踪一个默认集成，用 `installed_integrations` 记录所有已安装集成，用 `integration_settings` 存储各集成的运行时设置，并用专门的 `integration_state_schema` 支持未来的状态迁移。旧的 `integration` 字段仍作为默认集成的别名保留。

### 哪些集成是多安装安全的？

一个集成满足以下条件即为多安装安全：使用静态且唯一的智能体根目录和命令目录、稳定的命令调用设置，以及一份独立的安装清单，其受管文件不与其他安全集成重叠。注册表测试会强制这些路径与清单不变量。共享的 Spec Kit 模板始终与唯一的默认集成保持对齐。

下表的"隔离路径"列列出的是 Spec Kit 为该集成管理的路径（技能/命令根目录，以及集成自有的规则文件）。它不是该智能体可能读取的所有文件的完整清单。

**智能体上下文默认值是另一回事。** 可选的 agent-context 扩展在 `extensions/agent-context/agent-context-defaults.json` 中把每个集成映射到一个默认上下文文件。这些默认值与多安装安全性无关：启用该扩展时，多个智能体可以共享同一个根文件（如 `AGENTS.md`）。多安装安全并不要求每个安全集成拥有唯一的上下文文件。

当前声明为多安装安全的集成有：

| Key | 隔离路径 |
| --- | --------- |
| `auggie` | `.augment/commands`, `.augment/rules/specify-rules.md` |
| `claude` | `.claude/skills`, `CLAUDE.md` |
| `cline` | `.clinerules/workflows`, `.clinerules/specify-rules.md` |
| `codebuddy` | `.codebuddy/commands`, `CODEBUDDY.md` |
| `codex` | `.agents/skills`, `AGENTS.md` |
| `cursor-agent` | `.cursor/skills`, `.cursor/rules/specify-rules.mdc` |
| `firebender` | `.firebender/commands`, `.firebender/rules/specify-rules.mdc` |
| `gemini` | `.gemini/commands`, `GEMINI.md` |
| `grok` | `.grok/skills` |
| `junie` | `.junie/commands`, `.junie/AGENTS.md` |
| `kilocode` | `.kilocode/workflows`, `.kilocode/rules/specify-rules.md` |
| `qodercli` | `.qoder/commands`, `QODER.md` |
| `qwen` | `.qwen/commands`, `QWEN.md` |
| `shai` | `.shai/commands`, `SHAI.md` |
| `tabnine` | `.tabnine/agent/commands`, `TABNINE.md` |
| `trae` | `.trae/skills`, `.trae/rules/project_rules.md` |
| `zcode` | `.zcode/skills`, `ZCODE.md` |

与其他集成共用命令目录、需要 `--commands-dir` 这类动态安装路径，或会合并共享工具设置的集成，默认不声明为安全。它们仍然可以通过 `--force` 与其他集成一起安装。

### 卸载或切换时，我的改动会怎样？

你修改过的文件会自动保留。只有未修改的文件（与原始 SHA-256 哈希一致）才会被移除。使用 `--force` 可以覆盖此行为。

### 我怎么知道该用哪个 key？

运行 `specify integration list` 查看所有可用集成及其 key，或查阅上面的[支持的 AI 编码智能体](#支持的-ai-编码智能体)表格。

### 使用集成需要先装好对应的 AI 编码智能体吗？

基于 CLI 的集成（如 Claude Code、Gemini CLI）需要安装对应工具。基于 IDE 的集成（如 Cursor）通过 IDE 本身工作。GitHub Copilot 这类智能体同时支持 IDE 和 CLI 用法。`specify integration list` 会显示每个集成属于哪种类型。

### 什么时候用 `upgrade`，什么时候用 `switch`？

升级了 Spec Kit、想刷新某个已安装集成的受管文件时，用 `upgrade`。想把当前默认集成换成另一个时，用 `switch`；如果目标已经安装，`switch` 的行为等同于 `use`。
