---
description: 对照功能的规范、计划与任务清单评估当前代码库，把尚未完成的剩余工作作为新任务追加到 tasks.md，供 implement 完成。
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
  py: scripts/python/check_prerequisites.py --json --require-tasks --include-tasks
---

<!-- zh-source: templates/commands/converge.md -->
<!-- zh-base: 55da30c -->

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑上述用户输入（如果不为空）。

## 执行前检查

**检查扩展钩子（收敛之前）**：

- 检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.before_converge` 键下的条目
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并正常继续
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **可选钩子**（`optional: true`）：

    ```text
    ## 扩展钩子

    **可选前置钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```

  - **强制钩子**（`optional: false`）：

    ```text
    ## 扩展钩子

    **自动前置钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}

    等待钩子命令的结果返回后，再继续进入"目标"。
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。

- 如果没有注册任何钩子，或 `.specify/extensions.yml` 不存在，则静默跳过

## 目标

弥合功能的规范、计划、任务清单所要求的内容与代码库当前实现之间的差距。把 `spec.md`、`plan.md` 和 `tasks.md` 作为**唯一的意图来源**（宪章作为治理约束），评估代码的当前状态，判断哪些需求、验收标准、计划决策和现有任务未被满足、未完成或仅部分满足，并把每一项剩余工作作为**新的、可追溯的任务追加**到 `tasks.md` 底部，供 `__SPECKIT_COMMAND_IMPLEMENT__` 完成。本命令必须在 `__SPECKIT_COMMAND_IMPLEMENT__` 已针对当前 `tasks.md` 运行过、且 `__SPECKIT_COMMAND_TASKS__` 已产出完整的 `tasks.md` 之后才能运行。

这**不是**一个 diff 工具，也**不**跟踪变更。它评估的是代码相对于该功能各产物的当前状态——不涉及 git、不做分支对比、不看历史。

## 运行约束

**只追加，绝不重写**：本命令**唯一**的写操作是向 `tasks.md` 追加一个新的
`## Phase N: Convergence` 小节。它绝不能：

- 以任何方式修改 `spec.md` 或 `plan.md`；
- 重写、重新编号、重新排序或删除任何现有任务（包括先前收敛阶段产生的任务）；
- 修改、创建或删除任何应用代码——完成所追加的任务是 `__SPECKIT_COMMAND_IMPLEMENT__` 的职责。

当代码库已经满足所有要求时，本命令必须保持 `tasks.md` **逐字节不变**（不留下空的收敛小节标题），并报告一个干净的结果。

**宪章权威性**：项目宪章（`/memory/constitution.md`）**不可协商**。违反 MUST 原则的代码是最高严重级别的发现，并产生对应的整改任务。如果宪章还是未填写的模板，则得体地跳过宪章检查，而不是直接失败。

## 执行步骤

### 1. 初始化收敛上下文

在仓库根目录运行一次 `{SCRIPT}`，解析 JSON 中的 FEATURE_DIR 和 AVAILABLE_DOCS。推导绝对路径：

- SPEC = FEATURE_DIR/spec.md
- PLAN = FEATURE_DIR/plan.md
- TASKS = FEATURE_DIR/tasks.md
- CONSTITUTION = `/memory/constitution.md`（如果存在）
如果 `spec.md`、`plan.md` 或 `tasks.md` 缺失，立即停止，并给出清晰、可执行的提示，指明需要先运行的前置命令（规范缺失运行 `__SPECKIT_COMMAND_SPECIFY__`，计划缺失运行 `__SPECKIT_COMMAND_PLAN__`，任务缺失运行 `__SPECKIT_COMMAND_TASKS__`）。不要产出不完整的输出。
参数中包含单引号时（如 "I'm Groot"），使用转义语法：例如 'I'\''m Groot'（或在可能时改用双引号："I'm Groot"）。

### 2. 加载产物（渐进式披露）

只从每个产物中加载最少必要的上下文：

**从 spec.md：**

- 功能需求（FR-###）
- 成功标准（SC-###）——只纳入需要实际构建工作的项；排除上线后的结果指标和业务 KPI
- 用户故事及其验收场景
- 边界情况（如有）

**从 plan.md：**

- 架构/技术栈选择与技术决策
- 数据模型引用
- 阶段和点名的接触点（计划中声明将创建或编辑的文件/组件）
- 技术约束

**从 tasks.md：**

- 任务 ID（用于计算下一个 ID 和下一个阶段编号）
- 描述、阶段分组和引用的文件路径

**从宪章（如果不是未填写的模板）：**

- 原则名称和 MUST/SHOULD 规范性声明

### 3. 构建意图清单

创建内部模型（不要复述原始产物）：

- **需求清单**：为每个 FR-### / SC-### / 用户故事验收场景（例如 `US1/AC2`）记录一个稳定键，另外纳入带来实际构建义务的计划决策和宪章原则。
- **代码范围映射**：根据 `plan.md` 和 `tasks.md` 中点名的文件路径，加上按各需求所描述概念做的关键词搜索，推导出纳入评估范围的源文件与组件集合。评估必须限定在这个范围内——**不要**推断产物定义之外的范围。

### 4. 评估代码库并对发现分类

对意图清单中的每一项，检查范围内的当前代码，只有在存在差距时才产出一条 `Finding`。按**差距类型**对每条发现分类：

- **`missing`**：所需的工作在代码中完全不存在。
- **`partial`**：工作已存在，但尚未完全满足需求/验收标准/计划决策。
- **`contradicts`**：代码的行为与声明的意图或某条宪章 MUST 原则相冲突。
- **`unrequested`**：代码包含规范、计划或任务都没有要求的工作（仅提示知悉——converge **不会**删除代码，只会追加一个任务来评审/说明理由或移除它）。

每条 `Finding` 记录：一个稳定的 id、它追溯到的 `source-ref`、`gap-type`、严重级别，以及一段带证据（观察到的文件/区域）的简短的人类可读描述。

**边界情况：**

- **代码很少或还没有代码**：把整个既定的规范范围视为 `missing` 的剩余工作，而不是直接失败。
- **没有剩余工作**：产出零条发现，并按第 7 步中的已收敛分支处理。

### 5. 判定严重级别

- **CRITICAL**：违反宪章 MUST 原则，或阻塞 P1 用户故事基线功能的 `missing`/`contradicts` 差距。
- **HIGH**：核心功能需求或验收标准上的 `missing` 或 `partial` 差距。
- **MEDIUM**：次要需求上的 `partial` 差距，或理由不明的 `unrequested` 新增内容。
- **LOW**：轻微的部分差距、打磨类工作，或低风险的 `unrequested` 新增内容。

### 6. 呈现会话内发现摘要

在追加任何内容之前，先输出一份按严重级别分级的精简摘要（此时还不写任何文件）：

## 收敛发现

| ID | 差距类型 | 严重级别 | 来源 | 证据 | 剩余工作 |
|----|----------|----------|--------|----------|----------------|
| F1 | missing  | HIGH     | FR-008 | 示例：写入 tasks.md 时未在 path/to/module.py 中检测到只追加保护 | 添加只追加约束的强制检查 |

**摘要指标：**

- 已检查的需求/验收标准数
- 已检查的计划决策数
- 已检查的宪章原则数（或"已跳过——模板"）
- 按差距类型统计的发现数（missing / partial / contradicts / unrequested）
- 按严重级别统计的发现数

### 7. 追加收敛任务（或报告已收敛）

**如果存在一条或多条可执行的发现**（`tasks_appended` 结果）：

按以下追加契约向 `tasks.md` 的**末尾**追加：

1. 扫描所有现有任务 ID；令 `M` 为其中的最大值。确定下一个阶段编号 `N`（现有最高阶段编号 + 1）。
2. 写入单个新的小节标题 `## Phase N: Convergence`。
3. 为每条可执行的发现输出一个检查清单项，按 CRITICAL/HIGH 优先排序，并分配零填充的 ID `T{M+1:03d}, T{M+2:03d}, …`：

   ```markdown
   - [ ] T042 <imperative description> per <source-ref> (<gap-type>)
   ```

   `<source-ref>` 把任务追溯到其来源：例如 `FR-003`、`SC-002`、`US1/AC2`、`plan: storage decision`、`Constitution II`。

   `<gap-type>` 是 `missing`、`partial`、`contradicts`、`unrequested` 之一。

   宪章违规的任务必须最先输出，并描述为 `CRITICAL`。
4. 绝不复用或重新编号现有 ID。如果已存在先前的收敛阶段，在其下方新增一个单独编号的新阶段——不要动旧的那个。

**如果没有可执行的发现**（`converged` 结果）：

- 完全**不要**修改 `tasks.md`——不留下空的阶段标题。
- 报告：**"✅ 已收敛——实现满足规范、计划与任务清单。"**
- 附上已检查内容的摘要计数。

### 8. 给出后续行动（交接）

- `tasks_appended` 结果：说明在哪个阶段下追加了多少个任务，并建议运行 `__SPECKIT_COMMAND_IMPLEMENT__` 完成它们；说明后续再次运行 converge 会发现更少或不再有剩余项。
- `converged` 结果：建议进入评审/开 PR。该功能的既定范围不再需要新的 implement 轮次。

### 9. 检查扩展钩子

产出结果后，检查项目根目录是否存在 `.specify/extensions.yml`。

- 如果存在，读取它并查找 `hooks.after_converge` 键下的条目
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并正常继续
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 在列出任何钩子之前，先在会话内报告收敛结果（`converged` 或 `tasks_appended`），以便用户决定是否运行可选的后续命令。
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **可选钩子**（`optional: true`）：

    ```text
    ## 扩展钩子

    **可选钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```

  - **强制钩子**（`optional: false`）：

    ```text
    ## 扩展钩子

    **自动钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。

- 如果没有注册任何钩子，或 `.specify/extensions.yml` 不存在，则静默跳过
