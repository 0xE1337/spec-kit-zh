<!-- zh-source: docs/reference/agentic-sdd.md -->
<!-- zh-base: 396fc2c -->

# 智能体化规范驱动开发（Agentic SDD）

`/speckit.*` 斜杠命令驱动核心的规范驱动开发（SDD）流程——这是一个由你的编码智能体逐步执行的**智能体式流程**。想要有引导的端到端完整运行，参见[快速上手指南](../quickstart.md)；本页是每个命令的详细参考——包括参数、输出，以及它们之间如何交互。关于该流程背后的理念，参见[什么是 SDD？](../concepts/sdd.md)。关于缺陷分诊（triage），参见[智能体化缺陷修复](agentic-bugfix.md)。

这些命令设计为按顺序运行，但只有 `/speckit.specify` 是 `/speckit.plan` 之前严格必需的。clarify、checklist 和 analyze 命令是你为任何存在实质性歧义的情况添加的质量关卡。

> [!NOTE]
> 本页通篇以 `/speckit.*` 形式书写命令。确切的调用方式取决于你的智能体——一些基于技能的智能体使用 `$speckit-*`（如 Codex、ZCode）或 `/skill:speckit-*`（如 Kimi）。请替换为你的智能体所暴露的形式。

```text
/speckit.constitution -> /speckit.specify -> /speckit.clarify -> /speckit.plan -> /speckit.checklist -> /speckit.tasks -> /speckit.analyze -> /speckit.implement -> /speckit.converge
```

## `/speckit.constitution`

创建或更新项目**宪章**——后续每个阶段都据以评估的指导原则——并保持依赖它的模板同步。开始时运行一次，之后每当你的原则变化时更新它。把原则作为参数传入。

```text
/speckit.constitution 本项目采用"库优先"（Library-First）方针。所有功能都必须先实现为独立的库。我们严格执行 TDD。我们偏好函数式编程风格。
```

## `/speckit.specify`

根据自然语言描述创建或更新功能**规范**。聚焦于**做什么**和**为什么**——面向用户的行为和目标——而不是技术栈，技术栈属于 `/speckit.plan`。

```text
/speckit.specify 构建一个帮我把照片整理到相册的应用，相册按日期分组，可以在主页面通过拖拽重新排列，每个相册内照片以瓦片式预览。
```

## `/speckit.clarify`

针对当前规范中描述不足的部分提出最多五个有针对性的问题，并把你的回答编码回 `spec.md`。规划之前可按需运行多次，每次处理一个不同的部分。可以选择把关注的部分作为参数传入。

```text
/speckit.clarify 聚焦任务卡片的行为：状态变更、评论数量限制，以及可以指派给谁。
```

在规划之前澄清，能避免你在歧义之上做设计。如果 `/speckit.analyze` 之后暴露出需求缺口，回来再次运行 `/speckit.clarify`（或 `/speckit.specify`）。

## `/speckit.plan`

运行规划流程，从规范生成设计产物。这里正是放实现细节的地方——把你的技术栈、架构和技术约束作为参数提供。

```text
/speckit.plan 使用 .NET Aspire，数据库用 Postgres。前端使用 Blazor Server，支持拖拽看板和实时更新。为 projects、tasks 和 notifications 暴露 REST API。
```

## `/speckit.checklist`

为功能生成一份质量检查清单——把它想成**"给你的需求写单元测试"**。它检查的不是代码，而是规范本身是否完整、清晰、无歧义且一致（例如："是否为每一列都定义了拖拽规则？"、"是否为被删除的受指派用户指定了行为？"）。

不带参数运行做一次广泛检查，或传入一个关注的部分以针对某个方面：

```text
/speckit.checklist
```

```text
/speckit.checklist 聚焦看板（Kanban）交互和评论权限。
```

审查生成的检查清单。如果它暴露出缺口，回到 `/speckit.clarify` 或 `/speckit.specify` 收紧规范，然后再拆解工作。

## `/speckit.tasks`

从设计产物生成一份可执行、按依赖排序的 `tasks.md`。任务被组织为若干阶段：**准备**（Setup）、**基础**（Foundational，阻塞性前置条件），然后按优先级顺序**为每个用户故事各设一个阶段**，最后是处理横切关注点的**打磨**（Polish）阶段。要求测试时，测试会生成在对应用户故事的阶段内，而不是作为独立阶段，并且在可能的地方标记任务以便并行执行。

```text
/speckit.tasks
```

## `/speckit.analyze`

在 `spec.md`、`plan.md` 和 `tasks.md` 之间执行**只读**的跨产物一致性与质量分析，报告冲突、缺口和歧义（例如某个任务没有匹配的需求，或某个计划选型与规范相矛盾）。它从不编辑文件——它产出一份报告，并可以选择性地提出整改建议供你批准。

```text
/speckit.analyze
```

在实现之前运行它，趁产物还能低成本调整。如果它暴露出问题，**回到拥有这些问题的更早步骤**，从源头修复——需求问题用 `/speckit.specify` 或 `/speckit.clarify`，设计问题用 `/speckit.plan`，重新生成任务清单用 `/speckit.tasks`——然后重新运行 `/speckit.analyze`，直到它返回干净的结果。你也可以在实现之后再次运行 `/speckit.analyze`，作为一次额外的审查。

## `/speckit.implement`

执行 `tasks.md` 中的任务，按依赖顺序运行每个阶段，并遵守并行标记。

对于小功能，运行一次就能构建一切：

```text
/speckit.implement
```

对于大功能，分阶段进行，以免压垮智能体的上下文——用参数为每次运行划定范围，验证结果，然后继续：

```text
/speckit.implement 只实现准备（Setup）和基础（Foundational）阶段：项目脚手架，以及带基础 CRUD 的 project/task 数据模型。在用户故事功能之前停下。
```

```text
/speckit.implement 现在实现看板（Kanban）用户故事：在不同列之间拖拽。
```

在进入下一阶段之前，先验证每一阶段可用。

## `/speckit.converge`

对照功能的规范、计划和任务清单评估代码库，确认没有遗漏。它是**只追加**的：它从不编辑或删除代码，唯一可能的写入是向 `tasks.md` 添加任务。只在当前 `tasks.md` 上运行过 `/speckit.implement` 之后才运行它。

```text
/speckit.converge
```

它首先打印一份按严重级别分级的发现摘要，然后归结为两种结果之一：

- **已收敛**（Converged）——未发现缺口。`tasks.md` 逐字节保持不变，你会看到一个干净的结果，例如 `✅ Converged — the implementation satisfies the spec, plan, and tasks.`。到此完成；可以进入审查或开一个 PR。
- **已追加任务**（Tasks appended）——发现了缺口。converge 会把它们作为新任务追加到 `tasks.md` 的一个 Convergence 小节下，并告诉你数量。再次运行 `/speckit.implement` 完成它们，然后再运行一次 `/speckit.converge`。每一轮发现的条目会更少；重复直到它报告已收敛。
