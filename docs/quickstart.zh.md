<!-- zh-source: docs/quickstart.md -->
<!-- zh-base: 3e97b10 -->

# 快速上手指南

本指南帮助你开始使用 Spec Kit 进行规范驱动开发。

> [!NOTE]
> 所有自动化脚本现在都同时提供 Bash（`.sh`）和 PowerShell（`.ps1`）两个版本。除非你传入 `--script sh|ps`，`specify` CLI 会根据操作系统自动选择。

## 推荐工作流

> [!TIP]
> **上下文感知**：Spec Kit 命令会根据你当前的 Git 分支（例如 `001-feature-name`）自动识别活跃的功能。要在不同规范之间切换，直接切换 Git 分支即可。

安装 Spec Kit 并定义好项目宪章后，快速实验可以走精简的功能路径：`/speckit.specify` -> `/speckit.plan` -> `/speckit.tasks` -> `/speckit.implement`。对于生产功能或任何存在明显歧义的工作，请把 `/speckit.clarify`、`/speckit.checklist` 和 `/speckit.analyze` 当作常规的质量关卡：

```text
/speckit.constitution -> /speckit.specify -> /speckit.clarify -> /speckit.plan -> /speckit.checklist -> /speckit.tasks -> /speckit.analyze -> /speckit.implement -> /speckit.converge
```

用 `/speckit.clarify` 在规划前减少需求歧义；在 `/speckit.plan` 之后用 `/speckit.checklist` 生成质量检查清单，验证需求的完整性、清晰度和一致性；再用 `/speckit.analyze` 在实现开始前检查规范/计划/任务的一致性。实现之后可以再跑一次 `/speckit.analyze` 作为额外复查，但第一次分析要放在 `/speckit.implement` 之前，这样发现缺口时还来得及调整计划和任务。最后，在实现完成后运行 `/speckit.converge`，验证所有计划内的工作都已完成，并为剩余缺口生成任务。如果 `/speckit.converge` 追加了新任务，就再次运行 `/speckit.implement`（然后再次收敛），直到它报告功能已经收敛。

### 第 1 步：安装 Specify

**在终端中**，运行 `specify` CLI 命令初始化项目：

```bash
# 创建一个新的项目目录
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# 或在当前目录初始化
uvx --from git+https://github.com/github/spec-kit.git specify init .
```

> [!NOTE]
> 你也可以用 `pipx` 持久安装 CLI：
>
> ```bash
> pipx install git+https://github.com/github/spec-kit.git
> ```
>
> 用 `pipx` 安装后，直接运行 `specify`，无需再用 `uvx --from ... specify`，例如：
>
> ```bash
> specify init <PROJECT_NAME>
> specify init .
> ```

显式指定脚本类型（可选）：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script ps  # 强制使用 PowerShell
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script sh  # 强制使用 POSIX shell
```

### 第 2 步：定义你的宪章

**在编码智能体的聊天界面中**，使用 `/speckit.constitution` 斜杠命令确立项目的核心规则和原则。你应该把项目的具体原则作为参数提供。

```markdown
/speckit.constitution 本项目遵循"库优先"方式。所有功能必须先实现为独立的库。我们严格执行 TDD。我们偏好函数式编程模式。
```

### 第 3 步：创建规范

**在聊天中**，使用 `/speckit.specify` 斜杠命令描述你想构建什么。聚焦于**做什么**和**为什么做**，而不是技术栈。

```markdown
/speckit.specify 构建一个帮我把照片整理到不同相册的应用。相册按日期分组，可以在主页面通过拖拽重新排列。相册不会嵌套在其他相册里。每个相册内，照片以瓦片式界面预览。
```

### 第 4 步：精炼并验证规范

**在聊天中**，使用 `/speckit.clarify` 斜杠命令识别并解决规范中的歧义。你可以把特定的关注领域作为参数提供。

```bash
/speckit.clarify 聚焦于安全和性能需求。
```

### 第 5 步：创建技术实现计划

**在聊天中**，使用 `/speckit.plan` 斜杠命令提供你的技术栈和架构选型。

```markdown
/speckit.plan 应用使用 Vite，尽量少引入库。尽可能使用原生 HTML、CSS 和 JavaScript。图片不上传到任何地方，元数据存储在本地 SQLite 数据库中。
```

计划就绪后，用 `/speckit.checklist` 生成质量检查清单：

```bash
/speckit.checklist
```

### 第 6 步：拆解、分析并实现

**在聊天中**，使用 `/speckit.tasks` 斜杠命令创建可执行的任务清单。

```markdown
/speckit.tasks
```

在实现之前，用 `/speckit.analyze` 验证跨产物的一致性：

```markdown
/speckit.analyze
```

使用 `/speckit.implement` 斜杠命令执行计划。

```markdown
/speckit.implement
```

> [!TIP]
> **分阶段实现**：对于复杂项目，请分阶段实现，避免撑爆智能体的上下文。先做核心功能，验证可用后，再增量添加其他功能。

## 完整示例：构建 Taskify

以下是构建一个团队生产力平台的完整示例：

### 第 1 步：定义宪章

初始化项目宪章，确立基本规则：

```markdown
/speckit.constitution Taskify 是一个"安全优先"的应用。所有用户输入都必须校验。我们采用微服务架构。代码必须有完整的文档。
```

### 第 2 步：用 `/speckit.specify` 定义需求

```text
/speckit.specify 开发 Taskify，一个团队生产力平台。它应该允许用户创建项目、添加团队成员、
分配任务、评论，并以看板（Kanban）风格在不同看板列之间移动任务。这个功能的初始阶段
我们叫它"创建 Taskify"，支持多个用户，但用户是预先声明、预定义好的。
我需要两类共五个用户：一名产品经理和四名工程师。创建三个不同的示例项目。
每个任务的状态使用标准看板列，比如"待办"、"进行中"、"评审中"和"已完成"。
这个应用不需要登录，因为这只是第一个测试版本，用来确认基本功能是否就绪。
```

### 第 3 步：精炼规范

使用 `/speckit.clarify` 命令交互式地解决规范中的歧义。你也可以补充你希望确保覆盖的具体细节。

```bash
/speckit.clarify 我想澄清任务卡片的细节。在任务卡片的 UI 中，你应该能在看板的不同列之间修改任务的当前状态。你应该能给某张卡片留下不限数量的评论。你应该能从任务卡片上指派一个有效用户。
```

你可以继续用 `/speckit.clarify` 补充更多细节来精炼规范：

```bash
/speckit.clarify 首次启动 Taskify 时，它会给出五个用户的列表供选择，不需要密码。点击某个用户后进入主视图，显示项目列表。点击某个项目会打开该项目的看板。你会看到各个列，可以在不同列之间来回拖拽卡片。分配给你（当前登录用户）的卡片会用不同于其他卡片的颜色显示，让你一眼看到自己的任务。你可以编辑自己发表的评论，但不能编辑别人发表的评论。你可以删除自己发表的评论，但不能删除任何其他人的评论。
```

### 第 4 步：用 `/speckit.plan` 生成技术计划

明确说明你的技术栈和技术要求：

```bash
/speckit.plan 我们将使用 .NET Aspire 来生成这个应用，数据库使用 Postgres。前端使用 Blazor Server，支持拖拽式任务看板和实时更新。需要创建 REST API，包括 projects API、tasks API 和 notifications API。
```

### 第 5 步：验证规范

使用 `/speckit.checklist` 命令生成质量检查清单来验证规范：

```bash
/speckit.checklist
```

### 第 6 步：定义任务

使用 `/speckit.tasks` 命令生成可执行的任务清单：

```bash
/speckit.tasks
```

### 第 7 步：验证并实现

在实现之前，让编码智能体用 `/speckit.analyze` 审计规范、计划和任务：

```bash
/speckit.analyze
```

最后，实现这个解决方案：

```bash
/speckit.implement
```

### 第 8 步：收敛

实现完成后运行 `/speckit.converge` 命令，对照功能的各项产物评估当前代码库，把尚未构建的剩余工作以新任务的形式追加到 `tasks.md`。如果该命令追加了新任务，就再次运行 `/speckit.implement` 完成它们，并重复收敛步骤，直到功能完全完成。

```bash
/speckit.converge
```

> [!TIP]
> **分阶段实现**：对于 Taskify 这样的大项目，考虑分阶段实现（例如阶段 1：基本的项目/任务结构；阶段 2：看板功能；阶段 3：评论与任务指派）。这可以防止上下文饱和，并允许在每个阶段进行验证。

## 关键原则

- **明确说清**你要构建什么、为什么构建
- 规范阶段**不要纠结技术栈**
- 在实现之前**迭代和精炼**你的规范
- 在开始编码前**验证**需求和计划
- **把实现细节交给**编码智能体处理

## 下一步

- 阅读[完整方法论](https://github.com/github/spec-kit/blob/main/spec-driven.md)获得深入指导
- 查看仓库中的[更多示例](https://github.com/github/spec-kit/tree/main/templates)
- 浏览 [GitHub 上的源码](https://github.com/github/spec-kit)
