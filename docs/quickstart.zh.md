<!-- zh-source: docs/quickstart.md -->
<!-- zh-base: a5560fc -->

# 快速上手指南

本指南帮助你开始使用 Spec Kit 进行规范驱动开发。全文将用一个贯穿始终的示例来说明每一步：**Taskify**，一个小型的团队生产力平台。

> [!NOTE]
> 自动化脚本提供 Bash（`.sh`）、PowerShell（`.ps1`）和 Python（`.py`）三个版本。交互式的 `specify init` 会提示你选择其一；非交互式运行则默认为适配你操作系统的 shell 版本。传入 `--script sh|ps|py` 可显式选择。

> [!NOTE]
> 这里的命令都以 `/speckit.*` 形式给出，但具体的调用方式取决于你的智能体。一些基于技能的智能体使用 `$speckit-*`（例如 Codex、ZCode）或 `/skill:speckit-*`（例如 Kimi）。用你的智能体所暴露的形式即可——其余步骤完全相同。

## 推荐流程

> [!TIP]
> **上下文感知**：Spec Kit 通过记录在 `.specify/feature.json` 中的功能目录来跟踪活跃的功能（可用 `SPECIFY_FEATURE_DIRECTORY` 环境变量覆盖）。命令从该状态解析功能，**而不是**从当前检出的 Git 分支——无需 Git。按需启用（opt-in）的 **git** 扩展会添加带编号的功能分支（例如 `001-feature-name`），用于在版本控制中组织工作，但活跃的功能仍然是该状态所指向的目录；单独执行 `git checkout` 并不会改变它。要让命令指向另一个功能，请更新 `.specify/feature.json`（或设置 `SPECIFY_FEATURE_DIRECTORY`）。

安装 Spec Kit 之后，下面的每个命令都是流程中的一步。常见有两条路径：

**较短路径**——适用于较小的功能：

1. `/speckit.specify`
2. `/speckit.plan`
3. `/speckit.tasks`
4. `/speckit.implement`
5. `/speckit.converge`

**完整路径**——适用于生产功能，加入 `/speckit.clarify`、`/speckit.checklist` 和 `/speckit.analyze` 作为质量关卡：

1. `/speckit.constitution`
2. `/speckit.specify`
3. `/speckit.clarify`
4. `/speckit.plan`
5. `/speckit.checklist`
6. `/speckit.tasks`
7. `/speckit.analyze`
8. `/speckit.implement`
9. `/speckit.converge`

### 安装 Specify

**在终端中**，从 PyPI 安装 CLI（需要 [uv](install/uv.md)），然后初始化你的项目：

```bash
uv tool install specify-cli
specify init taskify   # 或：specify init .   使用当前目录
```

`init` 让你交互式地选择编码智能体，也可以用 `--integration` 显式指定（例如 `--integration copilot`）。

> [!NOTE]
> 更想用 `pipx`、一次性 `uvx` 运行、固定发布版本，或离线隔离（air-gapped）环境？所有受支持的方式见[安装指南](installation.md)。

### 第 1 步：`/speckit.constitution`——设定基本规则

确立项目的指导原则，后续每一步都会据此评估。在最开始运行一次，把你的原则作为参数传入。

```text
/speckit.constitution Taskify 是一个"安全优先"的应用。所有用户输入都必须校验。我们采用微服务架构。代码必须有完整的文档。
```

### 第 2 步：`/speckit.specify`——描述要构建什么

根据自然语言描述创建功能规范。聚焦于**做什么**和**为什么做**，而不是技术栈。

```text
/speckit.specify 开发 Taskify，一个团队生产力平台，其中预定义好的用户可以创建项目、分配任务、评论，并在看板（Kanban）的不同列（"待办"、"进行中"、"评审中"、"已完成"）之间移动任务。五名用户（一名产品经理、四名工程师），三个示例项目，第一阶段不设登录。
```

### 第 3 步：`/speckit.clarify`——解决歧义

针对任何描述不足之处提出有针对性的问题，并把你的回答融回规范，这样你就不会在歧义之上做规划。在规划前运行，可选地指定一个关注领域。

```text
/speckit.clarify 聚焦于任务卡片的行为——状态变更、评论权限和用户指派。
```

### 第 4 步：`/speckit.plan`——选择技术栈

根据规范生成设计产物。实现细节属于这一步——在此提供你的技术栈和架构。

```text
/speckit.plan 使用 .NET Aspire，数据库用 Postgres。前端使用 Blazor Server，支持拖拽式看板和实时更新。对外提供 projects、tasks 和 notifications 三个 REST API。
```

### 第 5 步：`/speckit.checklist`——验证规范

生成质量检查清单——相当于"给需求写的单元测试"——在拆解工作之前确认规范完整、清晰、一致。

```text
/speckit.checklist
```

### 第 6 步：`/speckit.tasks`——拆解工作

根据设计产物生成一份可执行、按依赖排序的 `tasks.md`。

```text
/speckit.tasks
```

### 第 7 步：`/speckit.analyze`——检查一致性

报告 `spec.md`、`plan.md` 和 `tasks.md` 之间的冲突、缺口和歧义。它是只读的——如果它标记出问题，就在源头修复，并在实现前重新运行。

```text
/speckit.analyze
```

### 第 8 步：`/speckit.implement`——开始构建

按依赖顺序执行 `tasks.md` 中的任务。可以运行一次构建全部，也可以对大型功能一次只限定在一个阶段。

```text
/speckit.implement
```

### 第 9 步：`/speckit.converge`——验证完整性

对照规范、计划和任务检查代码库。如果发现缺口，就把新任务追加到 `tasks.md`；再运行 `/speckit.implement` 并再次收敛，直到它报告已收敛。否则就完成了——可以进入评审或提交 PR。

```text
/speckit.converge
```

> [!TIP]
> 每个命令的完整参考——参数、输出、分阶段实现，以及它们之间如何交互——见 [智能体化 SDD](reference/agentic-sdd.md)。

## 关键原则

- **明确说清**你要构建什么、为什么构建
- 规范阶段**不要纠结技术栈**
- 在实现之前**迭代和精炼**你的规范
- 在开始编码前**验证**需求和计划
- **把实现细节交给**编码智能体处理

## 下一步

- 每个命令的完整细节见 [智能体化 SDD](reference/agentic-sdd.md) 参考文档
- 阅读[完整方法论](https://github.com/github/spec-kit/blob/main/spec-driven.md)获得深入指导
- 查看仓库中的[更多示例](https://github.com/github/spec-kit/tree/main/templates)
- 浏览 [GitHub 上的源码](https://github.com/github/spec-kit)
