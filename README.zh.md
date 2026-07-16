<!-- zh-source: README.md -->
<!-- zh-base: ad601e5 -->

> 📖 本文是 [README.md](README.md) 的简体中文翻译，属于 **spec-kit 中文学习版** 项目的一部分。
> 翻译说明与同步策略见 [TRANSLATION.md](TRANSLATION.md)，术语对照见 [GLOSSARY.zh.md](GLOSSARY.zh.md)。

<div align="center">
    <img src="./media/logo_large.webp" alt="Spec Kit Logo" width="200" height="200"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快地构建高质量软件。</em></h3>
</div>

<p align="center">
    <strong>一个开源工具包，让你专注于产品场景和可预期的结果，而不是每一块都从零开始氛围编码（vibe coding）。</strong>
</p>

<p align="center">
    <a href="https://github.com/github/spec-kit/releases/latest"><img src="https://img.shields.io/github/v/release/github/spec-kit" alt="Latest Release"/></a>
    <a href="https://github.com/github/spec-kit/stargazers"><img src="https://img.shields.io/github/stars/github/spec-kit?style=social" alt="GitHub stars"/></a>
    <a href="https://github.com/github/spec-kit/blob/main/LICENSE"><img src="https://img.shields.io/github/license/github/spec-kit" alt="License"/></a>
    <a href="https://github.github.io/spec-kit/"><img src="https://img.shields.io/badge/docs-GitHub_Pages-blue" alt="Documentation"/></a>
</p>

---

## 目录

- [🤔 什么是规范驱动开发？](#-什么是规范驱动开发)
- [⚡ 快速上手](#-快速上手)
- [📽️ 视频概览](#️-视频概览)
- [🌍 社区](#-社区)
- [🤖 支持的 AI 编码智能体集成](#-支持的-ai-编码智能体集成)
- [🔧 Specify CLI 参考](#-specify-cli-参考)
- [🧩 把 Spec Kit 变成你自己的：扩展与预设](#-把-spec-kit-变成你自己的扩展与预设)
- [📦 套装：按角色一键配置](#-套装按角色一键配置)
- [📚 核心理念](#-核心理念)
- [🌟 开发阶段](#-开发阶段)
- [🎯 实验目标](#-实验目标)
- [🔧 前置条件](#-前置条件)
- [📖 深入了解](#-深入了解)
- [📋 详细流程](#-详细流程)
- [💬 支持](#-支持)
- [🙏 致谢](#-致谢)
- [📄 许可证](#-许可证)

## 🤔 什么是规范驱动开发？

规范驱动开发**颠覆了**传统软件开发的剧本。几十年来，代码一直是主角——规范只是我们搭起来、等"真正的编码工作"开始后就丢弃的脚手架。规范驱动开发改变了这一点：**规范变得可执行**，直接生成可运行的实现，而不只是为实现提供参考。

## ⚡ 快速上手

### 1. 安装 Specify CLI

需要 **[uv](https://docs.astral.sh/uv/)**（[安装 uv](./docs/install/uv.md)）。将 `vX.Y.Z` 替换为 [Releases](https://github.com/github/spec-kit/releases) 页面上的最新发布 tag——注意保留开头的 `v`（例如 `v0.12.11`，而不是 `0.12.11`）：

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@vX.Y.Z
```

想从 PyPI 安装？`specify-cli` 包也发布在那里：

```bash
uv tool install specify-cli
```

其他安装方式、验证、升级与故障排查见[安装指南](./docs/installation.md)。

### 2. 初始化项目

```bash
specify init my-project --integration copilot
cd my-project
```

要检查更新或升级已安装的 CLI，使用自管理命令。详细场景与自定义选项见[升级指南](./docs/upgrade.md)。

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

不带参数的 `specify self upgrade` 会立即执行，与 `pip install -U`、`npm update` 这类命令的免确认行为一致。对于 `uv tool` 安装方式，它底层运行 `uv tool install specify-cli --force --from <git ref>`，因此固定发布 tag 也能正常工作，包括 dev、alpha/beta/rc 或带构建元数据后缀的版本。`uvx`（临时运行）方式和源码检出会被自动识别，并给出对应场景的指引而不是直接运行安装器。可以设置 `SPECIFY_UPGRADE_TIMEOUT_SECS` 来限制安装子进程的最长运行时间（默认无超时——必要时用 `Ctrl+C` 中断）。

### 3. 确立项目原则

在项目目录中启动你的编码智能体。大多数智能体以 `/speckit.*` 斜杠命令的形式暴露 spec-kit；技能模式下的 Codex CLI 使用 `$speckit-*`；GitHub Copilot CLI 用 `/agents` 选择智能体，或在提示词中直接点名。

使用 **`/speckit.constitution`** 命令创建项目的治理原则和开发准则，它们将指导后续所有开发工作。

```bash
/speckit.constitution 创建聚焦于代码质量、测试标准、用户体验一致性和性能要求的项目原则
```

### 4. 创建规范

使用 **`/speckit.specify`** 命令描述你想构建什么。聚焦于**做什么**和**为什么做**，而不是技术栈。

```bash
/speckit.specify 构建一个帮我把照片整理到不同相册的应用。相册按日期分组，可以在主页面通过拖拽重新排列。相册不会嵌套在其他相册里。每个相册内，照片以瓦片式界面预览。
```

### 5. 创建技术实现计划

使用 **`/speckit.plan`** 命令提供你的技术栈和架构选型。

```bash
/speckit.plan 应用使用 Vite，尽量少引入库。尽可能使用原生 HTML、CSS 和 JavaScript。图片不上传到任何地方，元数据存储在本地 SQLite 数据库中。
```

### 6. 拆解为任务

使用 **`/speckit.tasks`** 从实现计划生成可执行的任务清单。

```bash
/speckit.tasks
```

### 7. 执行实现

使用 **`/speckit.implement`** 执行所有任务，按照计划构建功能。

```bash
/speckit.implement
```

详细的分步操作说明见我们的[完整指南](./spec-driven.md)。

## 📽️ 视频概览

想看看 Spec Kit 的实际效果？观看我们的[视频概览](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)！

[![Spec Kit video header](/media/spec-kit-video-header.jpg)](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)

## 🌍 社区

在 [Spec Kit 文档站](https://github.github.io/spec-kit/)探索社区贡献的资源：

- [扩展](https://github.github.io/spec-kit/community/extensions.html) —— 命令、钩子与新能力
- [预设](https://github.github.io/spec-kit/community/presets.html) —— 模板与术语覆盖
- [套装](https://github.github.io/spec-kit/community/bundles.html) —— 由现有组件组合而成的角色与团队配置
- [实战演练](https://github.github.io/spec-kit/community/walkthroughs.html) —— 端到端的规范驱动开发场景
- [友邻项目](https://github.github.io/spec-kit/community/friends.html) —— 扩展或构建于 Spec Kit 之上的项目

> [!NOTE]
> 社区贡献由各自的作者独立创建和维护。安装前请审查源码，使用风险自行判断。

想参与贡献？参见[扩展发布指南](extensions/EXTENSION-PUBLISHING-GUIDE.md)、[预设发布指南](presets/PUBLISHING.md)或[社区套装指南](docs/community/bundles.md)。

## 🤖 支持的 AI 编码智能体集成

Spec Kit 支持 30 多个 AI 编码智能体——既有 CLI 工具，也有 IDE 内置助手。完整列表及各集成的说明与用法见[支持的 AI 编码智能体集成](https://github.github.io/spec-kit/reference/integrations.html)指南。

运行 `specify integration list` 可查看你安装的版本中所有可用的集成。

## 可用的斜杠命令

运行 `specify init` 之后，你的 AI 编码智能体就能使用以下斜杠命令进行结构化开发。对于支持技能模式的集成，传入 `--integration <agent> --integration-options="--skills"` 会安装智能体技能，而不是斜杠命令提示词文件。

### 核心命令

规范驱动开发工作流的必备命令：

| 命令 | 智能体技能 | 说明 |
| ------------------------ | ---------------------- | -------------------------------------------------------------------------- |
| `/speckit.constitution`  | `speckit-constitution` | 创建或更新项目治理原则与开发准则 |
| `/speckit.specify`       | `speckit-specify`      | 定义你想构建什么（需求和用户故事） |
| `/speckit.plan`          | `speckit-plan`         | 用你选定的技术栈创建技术实现计划 |
| `/speckit.tasks`         | `speckit-tasks`        | 生成可执行的实现任务清单 |
| `/speckit.taskstoissues` | `speckit-taskstoissues`| 把生成的任务清单转换为 GitHub issue，便于跟踪和执行 |
| `/speckit.implement`     | `speckit-implement`    | 执行所有任务，按计划构建功能 |
| `/speckit.converge`      | `speckit-converge`     | 对照规范/计划/任务评估代码库现状，把剩余工作追加为新任务 |

### 可选命令

用于提升质量与验证的补充命令：

| 命令 | 智能体技能 | 说明 |
| -------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `/speckit.clarify`   | `speckit-clarify`      | 澄清规范中描述不足的部分（建议在 `/speckit.plan` 之前运行；曾用名 `/quizme`） |
| `/speckit.analyze`   | `speckit-analyze`      | 跨产物的一致性与覆盖度分析（在 `/speckit.tasks` 之后、`/speckit.implement` 之前运行） |
| `/speckit.checklist` | `speckit-checklist`    | 生成自定义质量检查清单，验证需求的完整性、清晰度和一致性（好比"给英语写单元测试"） |

## 🔧 Specify CLI 参考

完整的命令细节、选项和示例见 [CLI 参考](https://github.github.io/spec-kit/reference/overview.html)。

## 🧩 把 Spec Kit 变成你自己的：扩展与预设

Spec Kit 可以通过两套互补的系统来按需定制——**扩展**和**预设**——再加上用于一次性调整的项目本地覆盖：

| 优先级 | 组件类型 | 位置 |
| -------: | ------------------------------------------------- | -------------------------------- |
|      ⬆ 1 | 项目本地覆盖 | `.specify/templates/overrides/`  |
|        2 | 预设——定制核心与扩展 | `.specify/presets/templates/`    |
|        3 | 扩展——增加新能力 | `.specify/extensions/templates/` |
|      ⬇ 4 | Spec Kit 核心——内置的规范驱动开发命令与模板 | `.specify/templates/`            |

- **模板**在**运行时**解析——Spec Kit 自上而下遍历这个栈，使用第一个匹配项。
- 项目本地覆盖（`.specify/templates/overrides/`）让你可以只为单个项目做一次性调整，不必创建完整的预设。
- **扩展/预设的命令**在**安装时**生效——运行 `specify extension add` 或 `specify preset add` 时，命令文件会被写入智能体目录（例如 `.claude/commands/`）。
- 如果多个预设或扩展提供了同名命令，优先级最高的版本胜出。移除时，次高优先级的版本会被自动恢复。
- 如果不存在任何覆盖或定制，Spec Kit 使用其核心默认值。

### 扩展——增加新能力

当你需要超出 Spec Kit 核心的功能时，使用**扩展**。扩展引入新的命令和模板——例如添加内置规范驱动开发命令未覆盖的领域专属工作流、与外部工具集成，或增加全新的开发阶段。它们扩展的是 *Spec Kit 能做什么*。

```bash
# 搜索可用的扩展
specify extension search

# 安装一个扩展
specify extension add <extension-name>
```

举例来说，扩展可以添加 Jira 集成、实现后代码审查、V 模型测试追溯，或项目健康诊断。

完整命令指南见[扩展参考](https://github.github.io/spec-kit/reference/extensions.html)。可用的扩展见[社区扩展](https://github.github.io/spec-kit/community/extensions.html)。

### 预设——定制既有工作流

当你想改变 Spec Kit 的*工作方式*而不增加新能力时，使用**预设**。预设覆盖核心*以及*已安装扩展自带的模板和命令——例如强制使用面向合规的规范格式、使用领域专属术语，或把组织标准应用到计划和任务上。它们定制的是 Spec Kit 及其扩展所产出的产物和指令。

```bash
# 搜索可用的预设
specify preset search

# 安装一个预设
specify preset add <preset-name>
```

举例来说，预设可以重构规范模板以要求合规追溯性、让工作流适配你使用的方法论（如敏捷、看板、瀑布、jobs-to-be-done 或领域驱动设计）、在计划中加入强制的安全审查关卡、强制测试先行的任务排序，或者把整个工作流本地化为另一种语言。[海盗腔演示](https://github.com/mnriem/spec-kit-pirate-speak-preset-demo)展示了定制可以做到多深。多个预设可以按优先级叠加。

完整命令指南（包括解析顺序与优先级叠加）见[预设参考](https://github.github.io/spec-kit/reference/presets.html)。

## 📦 套装：按角色一键配置

扩展和预设是单个的积木。**套装**把一组精选的组件——扩展、预设、步骤和工作流——打包成一个带版本、面向角色的配置，让整个团队角色（产品经理、业务分析师、安全研究员、开发者……）都能用一条命令完成配备。

套装由手写的 `bundle.yml` 清单描述。它把每个组件固定到某个版本，还可以选择性地指定目标集成；不含 `integration` 的套装是**集成无关**的，会继承项目已在使用的集成。

```bash
# 在当前生效的目录源栈中发现套装
specify bundle search [<query>]

# 查看某个套装将添加的确切组件集（与 install 实际做的一致）
specify bundle info <bundle-id>

# 一次性安装套装的完整组件集
specify bundle install <bundle-id>

# 查看已安装内容，然后无损地更新或移除
specify bundle list
specify bundle update <bundle-id>     # 或 --all
specify bundle remove <bundle-id>     # 只移除这个套装的组件
```

套装从一个**按优先级排序的目录源栈**（项目 > 用户 > 内置）解析。每个来源带有安装策略：`install-allowed` 的来源可以安装，而 `discovery-only` 的来源在 `search`/`info` 中可见但拒绝安装。用 `specify bundle catalog list|add|remove` 管理这个栈。

作者在本地验证并打包套装。分发方式是托管构建产物并添加目录源；社区套装的提交使用 [Bundle Submission](https://github.com/github/spec-kit/issues/new?template=bundle_submission.yml) issue 模板，以便审查所需的组件目录和安装证据：

```bash
specify bundle validate --path ./my-bundle      # 结构与引用检查
specify bundle build --path ./my-bundle         # 产出带版本的 .zip 构建产物
```

[`examples/bundles/`](examples/bundles/) 下有四个可直接阅读的示例清单（产品经理、业务分析师、安全研究员、开发者）。

关键保证：`info` 展示的就是 `install` 将添加的内容（透明性）；安装是幂等的且只作用于项目根目录内；`remove` 绝不触碰其他已安装套装仍在使用的组件；所有使用/创作命令都能针对本地或固定版本的来源**离线**工作。

### 什么时候用哪个

| 目标 | 用什么 |
| --- | --- |
| 添加全新的命令或工作流 | 扩展 |
| 定制规范、计划或任务的格式 | 预设 |
| 集成外部工具或服务 | 扩展 |
| 强制执行组织或合规标准 | 预设 |
| 分发可复用的领域专属模板 | 都可以——模板覆盖用预设，模板与新命令一起打包用扩展 |
| 一条命令配备完整的角色化环境 | 套装 |

## 📚 核心理念

规范驱动开发是一个结构化的过程，它强调：

- **意图驱动的开发**——规范先定义"*做什么*"，再谈"*怎么做*"
- **富规范的创建**——借助护栏和组织级原则
- **多步精炼**——而不是靠一句提示词一次性生成代码
- **深度依赖**先进 AI 模型的规范理解能力

## 🌟 开发阶段

| 阶段 | 焦点 | 关键活动 |
| ---------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **0 到 1 开发**（从零开发，"greenfield"） | 从零生成 | <ul><li>从高层需求出发</li><li>生成规范</li><li>规划实现步骤</li><li>构建生产可用的应用</li></ul> |
| **创造性探索** | 并行实现 | <ul><li>探索多样化的解决方案</li><li>支持多种技术栈与架构</li><li>试验不同的用户体验模式</li></ul> |
| **迭代增强**（存量项目，"brownfield"） | 存量系统现代化 | <ul><li>迭代式添加功能</li><li>现代化改造遗留系统</li><li>调整适配流程</li></ul> |

对于已有项目，请把 Spec Kit 工具本身的更新与功能产物的演进分开管理：升级时刷新受管的项目文件，预期行为变化时更新 `specs/` 产物。[规范演进指南](./docs/guides/evolving-specs.md)描述了推荐的存量项目开发循环。

## 🎯 实验目标

我们的研究和实验聚焦于：

### 技术无关性

- 用多样化的技术栈创建应用
- 验证这一假设：规范驱动开发是一个不绑定特定技术、编程语言或框架的过程

### 企业级约束

- 演示关键业务应用的开发
- 纳入组织级约束（云服务商、技术栈、工程实践）
- 支持企业设计系统与合规要求

### 以用户为中心的开发

- 为不同的用户群体和偏好构建应用
- 支持多种开发方式（从氛围编码到 AI 原生开发）

### 创造性与迭代式流程

- 验证并行实现探索的概念
- 提供健壮的迭代式功能开发工作流
- 把流程延伸到升级与现代化改造任务

## 🔧 前置条件

- **Linux/macOS/Windows**
- 一个[受支持的](#-支持的-ai-编码智能体集成) AI 编码智能体
- [uv](https://docs.astral.sh/uv/) 用于包管理（推荐），或 [pipx](https://pipx.pypa.io/) 用于持久安装
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

如果你在使用某个智能体时遇到问题，请提交 issue，帮助我们完善对应的集成。

## 📖 深入了解

- **[完整的规范驱动开发方法论](./spec-driven.md)**——深入了解整个流程
- **[详细实战](#-详细流程)**——分步实现指南

---

## 📋 详细流程

<details>
<summary>点击展开详细的分步实战演练</summary>

你可以用 Specify CLI 引导项目初始化，它会把所需的产物带入你的环境。运行：

```bash
specify init <project_name>
```

或在当前目录初始化：

```bash
specify init .
# 或使用 --here 标志
specify init --here
# 目录已有文件时跳过确认
specify init . --force
# 或
specify init --here --force
```

![Specify CLI 在终端中引导新项目初始化](./media/specify_cli.gif)

在交互式终端中，你会被提示选择正在使用的编码智能体集成。在非交互式会话（如 CI 或管道运行）中，`specify init` 默认使用 GitHub Copilot，除非传入 `--integration`。你也可以在终端里直接主动指定集成：

```bash
specify init <project_name> --integration copilot
specify init <project_name> --integration gemini
specify init <project_name> --integration codex

# 或在当前目录：
specify init . --integration copilot
specify init . --integration codex --integration-options="--skills"

# 或使用 --here 标志
specify init --here --integration copilot
specify init --here --integration codex --integration-options="--skills"

# 强制合并进非空的当前目录
specify init . --force --integration copilot

# 或
specify init --here --force --integration copilot
```

当所选集成标记了 `requires_cli: True` 时，CLI 会检查你机器上是否安装了该集成所需的 CLI 工具。如果没有安装，或者你只想获取模板而不做工具检查，在命令中加上 `--ignore-agent-tools`：

```bash
specify init <project_name> --integration copilot --ignore-agent-tools
```

### **第 1 步：** 确立项目原则

进入项目文件夹并运行你的编码智能体。本例中我们使用 `claude`。

![引导 Claude Code 环境初始化](./media/bootstrap-claude-code.gif)

如果你能看到 `/speckit.constitution`、`/speckit.specify`、`/speckit.plan`、`/speckit.tasks` 和 `/speckit.implement` 这些命令可用，就说明配置正确。

第一步应该用 `/speckit.constitution` 命令确立项目的治理原则。这有助于在后续所有开发阶段保持一致的决策：

```text
/speckit.constitution 创建聚焦于代码质量、测试标准、用户体验一致性和性能要求的项目原则。包含这些原则应如何指导技术决策与实现选择的治理规则。
```

这一步会创建或更新 `.specify/memory/constitution.md` 文件，写入项目的基础准则，编码智能体在规范、规划和实现阶段都会参考它。

### **第 2 步：** 创建项目规范

项目原则确立后，就可以创建功能规范了。使用 `/speckit.specify` 命令，然后提供你要开发项目的具体需求。

> [!IMPORTANT]
> 尽可能明确地说明你要构建*什么*以及*为什么*。**这个阶段不要纠结技术栈**。

示例提示词：

```text
开发 Taskify，一个团队生产力平台。它应该允许用户创建项目、添加团队成员、
分配任务、评论，并以看板（Kanban）风格在不同看板列之间移动任务。这个功能的初始阶段
我们叫它"创建 Taskify"，支持多个用户，但用户是预先声明、预定义好的。
我需要两类共五个用户：一名产品经理和四名工程师。创建三个不同的示例项目。
每个任务的状态使用标准看板列，比如"待办"、"进行中"、"评审中"和"已完成"。
这个应用不需要登录，因为这只是第一个测试版本，用来确认基本功能是否就绪。
在任务卡片的 UI 中，你应该能在看板的不同列之间修改任务的当前状态。
你应该能给某张卡片留下不限数量的评论。你应该能从任务卡片上指派一个有效用户。
首次启动 Taskify 时，它会给出五个用户的列表供选择，不需要密码。
点击某个用户后进入主视图，显示项目列表。点击某个项目会打开该项目的看板。
你会看到各个列，可以在不同列之间来回拖拽卡片。分配给你（当前登录用户）的卡片
会用不同于其他卡片的颜色显示，让你一眼看到自己的任务。你可以编辑自己发表的评论，
但不能编辑别人发表的评论。你可以删除自己发表的评论，但不能删除任何其他人的评论。
```

输入这条提示词后，你会看到 Claude Code 启动规划和规范起草流程。Claude Code 还会触发一些内置脚本来完成仓库配置。

这一步完成后，会创建一个新分支（例如 `001-create-taskify`），以及 `specs/001-create-taskify` 目录下的一份新规范。

产出的规范应包含一组用户故事和功能需求，如模板中所定义。

到这个阶段，你的项目文件夹内容应该类似这样：

```text
.
├── .specify
│   ├── memory
│   │   └── constitution.md
│   ├── scripts
│   │   └── bash
│   │       ├── check-prerequisites.sh
│   │       ├── common.sh
│   │       ├── create-new-feature.sh
│   │       ├── setup-plan.sh
│   │       └── setup-tasks.sh
│   └── templates
│       ├── plan-template.md
│       ├── spec-template.md
│       └── tasks-template.md
└── specs
    └── 001-create-taskify
        └── spec.md
```

### **第 3 步：** 功能规范澄清（规划前必做）

基线规范创建好之后，你可以澄清第一轮尝试中没有捕捉到位的需求。

你应该在创建技术计划**之前**运行结构化的澄清工作流，以减少下游的返工。

推荐顺序：

1. 使用 `/speckit.clarify`（结构化）——按顺序、基于覆盖度提问，并把回答记录在规范的"澄清"（Clarifications）小节中。
2. 如果仍有模糊之处，可再进行自由形式的补充澄清。

如果你有意跳过澄清（例如技术验证或探索性原型），请明确说明，这样智能体就不会因为缺少澄清而卡住。

自由形式的补充澄清提示词示例（在 `/speckit.clarify` 之后仍有需要时使用）：

```text
对于你创建的每个示例项目，每个项目应有 5 到 15 个数量不等的任务，
随机分布在不同的完成状态中。确保每个完成阶段至少有一个任务。
```

你还应该让 Claude Code 校验**评审与验收检查清单**（Review & Acceptance Checklist），把已验证/符合要求的项勾选，不符合的留空。可以使用这样的提示词：

```text
阅读评审与验收检查清单，如果功能规范满足某项标准就勾选该项，不满足则留空。
```

重要的是把与 Claude Code 的交互当作澄清规范、围绕规范提问的机会——**不要把它的第一次尝试当成最终版本**。

### **第 4 步：** 生成计划

现在可以具体说明技术栈和其他技术要求了。使用项目模板内置的 `/speckit.plan` 命令，配合这样的提示词：

```text
我们将使用 .NET Aspire 来生成这个应用，数据库使用 Postgres。前端使用
Blazor Server，支持拖拽式任务看板和实时更新。需要创建 REST API，包括
projects API、tasks API 和 notifications API。
```

这一步的产出会包含若干实现细节文档，目录树类似这样：

```text
.
├── CLAUDE.md
├── .specify
│   ├── memory
│   │   └── constitution.md
│   ├── scripts
│   │   └── bash
│   │       ├── check-prerequisites.sh
│   │       ├── common.sh
│   │       ├── create-new-feature.sh
│   │       ├── setup-plan.sh
│   │       └── setup-tasks.sh
│   └── templates
│       ├── CLAUDE-template.md
│       ├── plan-template.md
│       ├── spec-template.md
│       └── tasks-template.md
└── specs
    └── 001-create-taskify
        ├── contracts
        │   ├── api-spec.json
        │   └── signalr-spec.md
        ├── data-model.md
        ├── plan.md
        ├── quickstart.md
        ├── research.md
        └── spec.md
```

检查 `research.md` 文档，确认根据你的指示使用了正确的技术栈。如果有哪个组件不对劲，可以让 Claude Code 完善它，甚至让它检查你想用的平台/框架在本机安装的版本（例如 .NET）。

此外，如果所选技术栈变化很快（例如 .NET Aspire、JS 框架），你可能还想让 Claude Code 研究相关细节，可以用这样的提示词：

```text
我想让你通读实现计划和实现细节，找出可以从进一步研究中受益的部分，
因为 .NET Aspire 是一个快速变化的库。对于你识别出的需要进一步研究的部分，
我想让你用我们将在这个 Taskify 应用中使用的具体版本信息更新研究文档，
并派生并行的研究任务，借助网络调研澄清所有细节。
```

在这个过程中，你可能会发现 Claude Code 卡在研究错误的方向上——可以用这样的提示词把它拉回正轨：

```text
我认为我们需要把这拆解成一系列步骤。首先，列出一份你在实现过程中
需要做但没有把握、或者能从进一步研究中受益的任务清单。把这些任务写下来。
然后针对每一个任务，分别启动一个独立的研究任务，最终的效果是我们在
并行地研究所有这些非常具体的任务。我看到你刚才做的像是在泛泛地研究
.NET Aspire，这种研究对我们这个场景帮助不大，太没有针对性了。
研究必须帮你解决一个具体的、有针对性的问题。
```

> [!NOTE]
> Claude Code 可能会过于积极，添加你没要求的组件。让它解释变更的理由和来源。

### **第 5 步：** 让 Claude Code 校验计划

计划就位后，你应该让 Claude Code 通读一遍，确保没有遗漏。可以使用这样的提示词：

```text
现在我想让你审计实现计划和实现细节文件。
通读时带着这个问题：从这些文档里能否读出一个明显的、你需要依次执行的任务序列？
因为我不确定这里的信息是否足够。比如，看核心实现部分时，如果能在核心实现
或细化的每一步中引用实现细节里对应的位置，让它知道去哪里找信息，会很有用。
```

这有助于完善实现计划，避免 Claude Code 在规划周期中遗漏的盲点。初轮完善完成后，在进入实现之前，再让 Claude Code 把检查清单过一遍。

如果你安装了 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)，还可以让 Claude Code 直接从当前分支向 `main` 创建一个带详细描述的 PR，确保工作被妥善跟踪。

> [!NOTE]
> 在让智能体实现之前，还值得让 Claude Code 交叉检查细节，看是否存在过度设计的部分（记住——它可能过于积极）。如果存在过度设计的组件或决策，可以让 Claude Code 解决。确保 Claude Code 把 `.specify/memory/constitution.md` 中的宪章作为制定计划时必须遵守的基础。

### **第 6 步：** 用 /speckit.tasks 生成任务拆解

实现计划验证完毕后，就可以把它拆解为具体的、可按正确顺序执行的任务了。使用 `/speckit.tasks` 命令从实现计划自动生成详细的任务拆解：

```text
/speckit.tasks
```

这一步会在功能规范目录下创建 `tasks.md` 文件，其中包含：

- **按用户故事组织的任务拆解**——每个用户故事成为一个独立的实现阶段，拥有自己的任务集
- **依赖管理**——任务按组件间依赖排序（例如先模型、再服务、再接口端点）
- **并行执行标记**——可以并行运行的任务标注 `[P]`，优化开发工作流
- **文件路径说明**——每个任务都包含实现应发生的确切文件路径
- **测试驱动开发结构**——如果要求了测试，测试任务会被纳入并排在实现之前
- **检查点校验**——每个用户故事阶段都包含检查点，验证功能的独立可用性

生成的 tasks.md 为 `/speckit.implement` 命令提供了清晰的路线图，确保实现过程系统化、保持代码质量，并支持用户故事的增量交付。

### **第 7 步：** 实现

准备就绪后，使用 `/speckit.implement` 命令执行你的实现计划：

```text
/speckit.implement
```

`/speckit.implement` 命令会：

- 验证所有前置条件已就位（宪章、规范、计划和任务清单）
- 解析 `tasks.md` 中的任务拆解
- 按正确顺序执行任务，遵守依赖关系和并行执行标记
- 遵循任务计划中定义的测试驱动开发方式
- 提供进度更新并妥善处理错误

> [!IMPORTANT]
> 编码智能体会执行本地 CLI 命令（如 `dotnet`、`npm` 等）——请确保你的机器上安装了所需工具。

实现完成后，测试应用并解决那些在 CLI 日志中看不到的运行时错误（例如浏览器控制台错误）。你可以把这类错误复制粘贴回编码智能体来解决。

</details>

---

## 💬 支持

需要支持请提交 [GitHub issue](https://github.com/github/spec-kit/issues/new)。我们欢迎缺陷报告、功能请求，以及关于如何使用规范驱动开发的问题。

## 🙏 致谢

本项目深受 [John Lam](https://github.com/jflam) 的工作与研究的影响，并以其为基础。

## 📄 许可证

本项目基于 MIT 开源许可证发布。完整条款见 [LICENSE](./LICENSE) 文件。
