<!-- zh-source: docs/upgrade.md -->
<!-- zh-base: 914d7b8 -->

# 升级指南

> 你已经安装了 Spec Kit，想升级到最新版本以获得新功能、bug 修复或更新的斜杠命令。本指南同时覆盖升级 CLI 工具和更新项目文件。

---

## 快速参考

| 升级什么 | 命令 | 何时使用 |
|----------------|---------|-------------|
| **CLI 工具（推荐）** | `specify self upgrade` | 原地升级到最新稳定版。自动识别你是通过 `uv tool` 还是 `pipx` 安装的。 |
| **CLI 工具——固定版本** | `specify self upgrade --tag vX.Y.Z[suffix]` | 升级到特定发布 tag，而不是最新稳定版。后缀仅限 dev、alpha/beta/rc 和/或构建元数据形式。 |
| **CLI 工具——手动回退** | `uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git@vX.Y.Z` | `specify self upgrade` 不可用（较旧的安装），或你想完全掌控安装命令时。 |
| **CLI 工具——手动回退（pipx）** | `pipx install --force git+https://github.com/github/spec-kit.git@vX.Y.Z` | 同上，用于 pipx 安装。 |
| **项目文件** | 运行 `specify integration upgrade <key>`，然后运行 `specify extension update` | 刷新项目中已安装的集成文件和扩展 |
| **两者都升级** | 先升级 CLI，再更新项目 | 大版本更新时推荐 |

---

## 第一部分：升级 CLI 工具

CLI 工具（`specify`）与项目文件是分开的。升级它可以获得最新功能和 bug 修复。

### 推荐：`specify self upgrade`

CLI 自带两个自管理命令，自动处理常见场景：

```bash
# 检查是否有新版本可用（只读——不会修改任何东西）
specify self check

# 预览升级会执行什么，但不实际升级
specify self upgrade --dry-run

# 原地升级到最新稳定版（自动识别 uv tool 或 pipx 安装方式）
specify self upgrade

# 或固定到某个发布 tag（把 vX.Y.Z[suffix] 替换为你想要的 tag）
specify self upgrade --tag vX.Y.Z[suffix]
```

不带参数的 `specify self upgrade` 会立即执行，与 `pip install -U`、`npm update` 这类命令的免确认行为一致。CLI 会把你的运行环境归类为以下几种之一：`uv tool`、`pipx`、`uvx`（临时运行）、源码检出或不支持。只有 `uv tool` 和 `pipx` 会被自动升级；对于 `uv tool` 安装方式，它底层运行 `uv tool install specify-cli --force --from <git ref>`，因此固定发布 tag 也能正常工作。其余几种路径会打印针对该场景的指引，然后以退出码 0 退出，不做任何改动。

固定的 tag 必须以 `vMAJOR.MINOR.PATCH` 开头。可选后缀仅限 dev、alpha/beta/rc 和/或构建元数据形式，例如 `v1.0.0-rc1`、`v0.8.0.dev0`、`v0.8.0+build.42`，或组合形式 `v1.0.0-rc1+build.42`；分支名、hash 引用、`latest` 以及不带 `v` 的裸版本号都会被拒绝。

可以设置 `SPECIFY_UPGRADE_TIMEOUT_SECS` 来限制安装子进程的最长运行时间（默认无超时——必要时用 `Ctrl+C` 中断）。如果这个内部超时触发，`specify self upgrade` 会以退出码 124 退出，并报告等待安装子进程超时，附带所配置的超时时间和手动重试命令。而安装器自身真实返回的退出码 124 会以 `Upgrade failed. Installer exit code: 124.` 的形式透传，因此脚本应把退出码 124 视为有歧义——需要区分这两种情况时应检查消息内容。

如果你安装的 CLI 版本早于引入 `specify self upgrade` 的发布版，请使用下面的手动等价命令。当你想完全掌控安装器命令时，这些命令同样有用。

### 如果你是用 `uv tool install` 安装的

升级到特定发布版（最新 tag 见 [Releases](https://github.com/github/spec-kit/releases)）：

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git@vX.Y.Z
```

### 如果你使用一次性的 `uvx` 命令

指定想要的发布 tag：

```bash
uvx --from git+https://github.com/github/spec-kit.git@vX.Y.Z specify init --here --integration copilot
```

`uvx` 会为这一条命令运行一个临时的 Spec Kit 副本。它不会更新通过 `uv tool install`、`pipx` 或其他工具管理器安装的持久 `specify`。如果某个新功能通过 `uvx` 能用，但本地的 `specify` 仍报告旧版本，请用与你安装方式匹配的命令升级持久 CLI。

### 如果你是用 `pipx` 安装的

升级到特定发布版：

```bash
pipx install --force git+https://github.com/github/spec-kit.git@vX.Y.Z
```

### 验证升级结果

```bash
# 确认 CLI 正常工作并显示已安装的工具
specify check

# 对照 GitHub 最新 release 确认已安装版本
specify self check
```

`specify check` 展示周边的工具环境；`specify self check` 是只读的，它会告诉你当前是否已是最新版（`Up to date: X.Y.Z`），或者两次检查之间是否又出了新版本。

---

## 第二部分：更新项目文件

当 Spec Kit 发布新功能（比如新的斜杠命令、更新的模板或扩展变更）时，你需要刷新已安装到项目中的 Spec Kit 文件。

### 哪些内容会被更新？

对于已有的 Spec Kit 项目，请优先使用清单感知（manifest-aware）的升级路径：

- ✅ **集成的命令/技能文件**（`.claude/skills/`、`.github/prompts/`、`.agents/skills/` 等）
- ✅ **受管的共享脚本和模板**（`.specify/scripts/`、`.specify/templates/`）——当它们与上一份受管副本相比未被修改时
- ✅ **已安装的扩展**——当你运行 `specify extension update` 时

集成升级命令会使用安装清单（install manifest）来检测本地改动。如果某个受管集成文件在安装后被修改过，该命令会停止并要求你检查改动，或带 `--force` 重新运行。

### 哪些内容是安全的？

以下文件在清单感知的集成/扩展升级路径下**绝不会被触碰**：

- ✅ **你的规范**（`specs/001-my-feature/spec.md` 等）——**确认安全**
- ✅ **你的实现计划**（`specs/001-my-feature/plan.md`、`tasks.md` 等）——**确认安全**
- ✅ **你的宪章**（`.specify/memory/constitution.md`）——使用 `specify integration upgrade` 时
- ✅ **你的源代码**——**确认安全**
- ✅ **你的 git 历史**——**确认安全**

`specs/` 目录被完全排除在模板包之外，升级期间永远不会被修改。

### 1. 检查已安装的集成

在项目目录内运行：

```bash
specify integration status
```

这会报告默认集成、所有已安装的集成，以及任何被修改过或缺失的受管文件。你也可以查看 `.specify/integration.json`；已安装的集成列在 `installed_integrations` 之下。

### 2. 升级每个已安装的集成

在项目目录内运行：

```bash
specify integration upgrade <key>
```

把 `<key>` 替换为某个已安装的集成键，例如 `copilot`、`claude` 或 `codex`。在装有多个已安装集成的项目中，对每个已安装的键各运行一次该命令。

**示例：**

```bash
specify integration upgrade claude
specify integration upgrade codex
```

`--script`、`--integration-options`、`--force` 等选项参见[集成参考](reference/integrations.md#upgrade-an-integration)。

### 3. 更新已安装的扩展

运行：

```bash
specify extension update
```

不带扩展参数时，这会更新所有已安装的扩展。用 `specify extension update <extension-id-or-name>` 只更新某一个扩展。详情参见[扩展参考](reference/extensions.md#update-extensions)。

### 兜底方案：重新运行 init

如果项目早于清单机制、缺少集成元数据，或需要更大范围的恢复，你仍然可以重新运行 init：

```bash
specify init --here --force --integration <your-agent>
```

请把它当作兜底方案，而不是默认的项目文件升级路径。它会刷新所选集成和共享的项目脚手架，但在覆盖文件前不会执行同样的按集成清单检查。

## ⚠️ 重要警告

### 1. 宪章文件与记忆定制

`specify integration upgrade <key>` 不会更新 `.specify/memory/constitution.md`。

兜底的 `specify init --here --force --integration <your-agent>` 路径也会保留已存在的 `.specify/memory/constitution.md`；如果该文件缺失，init 会用当前的宪章模板创建它。对于清单感知的升级路径，你无需备份/恢复宪章这一步。

与任何大范围的兜底刷新一样，使用 `init --here --force` 前请提交或备份本地定制，以便你审查最终产生的 diff。

### 2. 自定义的集成、脚本或模板

`specify integration upgrade <key>` 在清单跟踪的集成文件被本地修改时会阻断，除非你传入 `--force`。

共享脚本和模板只有在仍与上一次记录的受管副本一致时才会被刷新。除非你显式使用会覆盖它们的 force/刷新选项，否则本地定制会被保留。如果你定制过 `.specify/scripts/` 或 `.specify/templates/` 中的文件，请先提交或备份：

```bash
# 备份自定义模板和脚本
cp -r .specify/templates .specify/templates-backup
cp -r .specify/scripts .specify/scripts-backup

# 升级后手动合并你的修改
```

### 3. 斜杠命令重复（IDE 型智能体）

一些 IDE 型智能体（如 Kilo Code、Cline）升级后可能出现**重复的斜杠命令**——新旧版本同时显示。

**解决办法**：手动删除智能体目录下的旧命令文件。

**以 Kilo Code 为例：**

```bash
# 进入该智能体的命令目录
cd .kilocode/workflows/

# 列出文件并找出重复项
ls -la

# 删除旧版本（示例文件名——你的可能不同）
rm speckit.specify-old.md
rm speckit.plan-v1.md
```

重启 IDE 以刷新命令列表。

---

## 常见场景

### 场景 1："我只想要新的斜杠命令"

```bash
# 升级 CLI（自动识别 uv tool 或 pipx 安装方式）
specify self upgrade

# 检查已安装的集成
specify integration status

# 更新项目文件以获得新命令
specify integration upgrade <key>
specify extension update
```

### 场景 2："我定制过模板和宪章"

```bash
# 1. 提交或备份定制内容
git status
cp -r .specify/templates /tmp/templates-backup

# 2. 升级 CLI
specify self upgrade

# 3. 优先使用清单感知的项目更新
specify integration upgrade <key>
specify extension update

# 4. 如果升级报告有被修改的受管文件，先审查 diff 再使用 --force
```

### 场景 3："IDE 里出现了重复的斜杠命令"

这发生在 IDE 型智能体（Kilo Code、Cline 等）上。

```bash
# 找到智能体目录（示例：.kilocode/workflows/）
cd .kilocode/workflows/

# 列出所有文件
ls -la

# 删除旧命令文件
rm speckit.old-command-name.md

# 重启 IDE
```

### 场景 4："我不想要 git 扩展"

git 扩展现在是按需启用（opt-in）的，升级不会安装它，除非你显式添加。

```bash
# 升级 CLI
specify self upgrade

# 刷新集成文件和已安装的扩展
specify integration upgrade <key>
specify extension update

# 除非你运行 `specify extension add git`，否则不会添加 git 扩展
```

如果之后你想要 git 扩展的命令和钩子，可以显式安装：

```bash
specify extension add git
```

不使用 Git 的项目也能使用 Spec Kit：在运行规划类命令之前，把 `SPECIFY_FEATURE_DIRECTORY` 设置为功能目录路径即可：

```bash
# Bash/Zsh
export SPECIFY_FEATURE_DIRECTORY="specs/001-my-feature"

# PowerShell
$env:SPECIFY_FEATURE_DIRECTORY = "specs/001-my-feature"
```

或者直接运行 `/speckit.specify` 命令，它会自动创建 `.specify/feature.json`。

---

## 故障排查

### "升级后斜杠命令没有出现"

**原因**：智能体没有重新加载命令文件。

**解决：**

1. **完全重启你的 IDE/编辑器**（不只是重新加载窗口）
2. **对于 CLI 型智能体**，确认文件存在：

   ```bash
   ls -la .claude/commands/      # Claude Code
   ls -la .gemini/commands/      # Gemini
   ls -la .cursor/skills/      # Cursor
   ls -la .pi/prompts/           # Pi Coding Agent
   ls -la .omp/commands/         # Oh My Pi
   ```

3. **检查智能体特定的设置：**
   - Codex 需要 `CODEX_HOME` 环境变量
   - 某些智能体需要重启工作区或清除缓存

### "init 会覆盖我对宪章的定制吗？"

当前的 `specify init --here --force` 会保留已存在的 `.specify/memory/constitution.md`；只有当该文件缺失时，它才会用模板创建。

如果你此前曾因较旧的工作流或手动替换而丢失过宪章改动，可从 git 或备份恢复：

```bash
# 如果提交过定制后的宪章
git restore .specify/memory/constitution.md

# 如果手动备份过
cp /tmp/constitution-backup.md .specify/memory/constitution.md
```

**预防**：日常的项目文件更新请使用 `specify integration upgrade <key>`。如果你需要用兜底的 `specify init --here --force` 路径，请先提交，以便事后审查完整的 diff。

### 出现 "Warning: Current directory is not empty"

**完整警告信息：**

```text
Warning: Current directory is not empty (25 items)
Template files will be merged with existing content and may overwrite existing files
Do you want to continue? [y/N]
```

**它的含义：**

当你在已有文件的目录中运行 `specify init --here`（或 `specify init .`）时会出现这个警告。它在告诉你：

1. **目录中已有内容**——示例中是 25 个文件/文件夹
2. **文件将被合并**——新的模板文件会与你已有的文件放在一起
3. **部分文件可能被覆盖**——如果你已经有 Spec Kit 文件（`.claude/`、`.specify/` 等），它们会被替换为新版本

**哪些会被覆盖：**

只有 Spec Kit 基础设施文件：

- 智能体命令文件（`.claude/commands/`、`.github/prompts/` 等）
- `.specify/scripts/` 中的脚本
- `.specify/templates/` 中的模板
- `.specify/memory/` 中缺失的记忆文件（如 `.specify/memory/constitution.md`）可能会用模板创建；已存在的宪章会被保留

**哪些不受影响：**

- 你的 `specs/` 目录（规范、计划、任务）
- 你的源代码文件
- 你的 `.git/` 目录和 git 历史
- 其他任何不属于 Spec Kit 模板的文件

**如何应对：**

- **输入 `y` 并回车**——在使用兜底的 init 路径时继续合并
- **输入 `n` 并回车**——取消操作
- **使用 `--force` 标志**——完全跳过这个确认：

  ```bash
  specify init --here --force --integration copilot
  ```

**什么时候会看到这个警告：**

- ✅ 在现有 Spec Kit 项目中使用兜底的 init 路径时——**符合预期**
- ✅ 向现有代码库添加 Spec Kit 时——**符合预期**
- ⚠️ 如果你以为自己是在空目录里新建项目——**不符合预期**

**预防提示**：使用兜底的 init 路径前，请先提交当前工作，这样任何被刷新的文件都容易审查或恢复。

### "CLI 升级好像没生效"

如果某个命令表现得像旧版 Spec Kit，先问 CLI 本身：

```bash
# 只读——输出 "Up to date: X.Y.Z" 或 "Update available: X.Y.Z → vY.Z.W"
specify self check

# 预览升级将使用的安装方式、当前版本和目标 tag
specify self upgrade --dry-run
```

`specify check` 是离线的环境扫描；`specify self check` 才是 CLI 版本查询。

如果 `self check` 显示的版本不对，检查安装情况：

```bash
# 查看已安装的工具
uv tool list

# 应该能看到 specify-cli

# 确认路径
which specify

# 应该指向 uv tool 的安装目录
```

如果找不到，重新安装：

```bash
uv tool uninstall specify-cli
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

### "每次打开项目都要运行 specify 吗？"

**简短回答**：不需要。每个项目只需运行一次 `specify init`，或之后作为兜底恢复路径再运行。

**解释：**

`specify` CLI 工具用于：

- **初始配置**：`specify init` 在项目中引导安装 Spec Kit
- **日常项目文件升级**：`specify integration upgrade <key>` 和 `specify extension update`
- **兜底恢复**：当集成元数据缺失或无法使用清单感知路径时，用 `specify init --here --force`
- **诊断**：`specify check` 验证工具安装情况

运行过 `specify init` 之后，斜杠命令（如 `/speckit.specify`、`/speckit.plan` 等）就**永久安装**在项目的智能体目录（`.claude/`、`.github/prompts/`、`.pi/prompts/`、`.omp/commands/` 等）中了。AI 编码智能体直接读取这些命令文件——不需要再运行 `specify`。

**如果智能体识别不到斜杠命令：**

1. **确认命令文件存在：**

   ```bash
   # GitHub Copilot
   ls -la .github/prompts/

   # Claude
   ls -la .claude/commands/

   # Pi
   ls -la .pi/prompts/

   # Oh My Pi
   ls -la .omp/commands/
   ```

2. **完全重启 IDE/编辑器**（不只是重新加载窗口）

3. **确认你就在运行过 `specify init` 的目录里**

4. **对于某些智能体**，可能需要重新加载工作区或清除缓存

**相关问题**：如果 Copilot 打不开本地文件，或者意外地使用 PowerShell 命令，这通常是 IDE 上下文问题，与 `specify` 无关。可以尝试：

- 重启 VS Code
- 检查文件权限
- 确保正确打开了工作区文件夹

---

## 版本兼容性

Spec Kit 的大版本发布遵循语义化版本。CLI 和项目文件在同一个大版本内保持兼容。

**最佳实践**：大版本变更时同时升级 CLI 和项目文件，保持两者同步。

---

## 下一步

升级之后：

- **测试新的斜杠命令**：运行 `/speckit.constitution` 或其他命令，确认一切正常
- **查看发布说明**：在 [GitHub Releases](https://github.com/github/spec-kit/releases) 查看新功能和破坏性变更
- **更新工作流**：如果新增了命令，更新团队的开发工作流
- **查看文档**：访问 [github.io/spec-kit](https://github.github.io/spec-kit/) 获取最新指南
