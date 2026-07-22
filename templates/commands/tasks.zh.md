---
<!-- zh-base: 2a0ada9 -->
handoffs:
  - label: Analyze For Consistency
    agent: speckit.analyze
    prompt: Run a project analysis for consistency
    send: true
  - label: Implement Project
    agent: speckit.implement
    prompt: Start the implementation in phases
    send: true
scripts:
  sh: scripts/bash/setup-tasks.sh --json
  ps: scripts/powershell/setup-tasks.ps1 -Json
  py: scripts/python/setup_tasks.py --json
---

<!-- zh-source: templates/commands/tasks.md -->
<!-- zh-base: c8ce488 -->

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑上述用户输入（如果不为空）。

## 执行前检查

**检查扩展钩子（任务清单生成之前）**：
- 检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.before_tasks` 键下的条目
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并正常继续
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选前置钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```
  - **强制钩子**（`optional: false`）：
    ```
    ## 扩展钩子

    **自动前置钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}

    等待钩子命令的结果返回后，再继续进入"概要"。
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。
- 如果没有注册任何钩子，或 `.specify/extensions.yml` 不存在，则静默跳过

## 概要

1. **准备**：在仓库根目录运行 `{SCRIPT}`，解析 FEATURE_DIR、TASKS_TEMPLATE 和 AVAILABLE_DOCS 列表。提供时，`FEATURE_DIR` 和 `TASKS_TEMPLATE` 必须是绝对路径。`AVAILABLE_DOCS` 是 `FEATURE_DIR` 下可用文档的名称/相对路径列表（例如 `research.md` 或 `contracts/`）。参数中包含单引号时（如 "I'm Groot"），使用转义语法：例如 'I'\''m Groot'（或在可能时改用双引号："I'm Groot"）。

2. **加载设计文档**：从 FEATURE_DIR 读取：
   - **必需**：plan.md（技术栈、库、结构）、spec.md（带优先级的用户故事）
   - **可选**：data-model.md（实体）、contracts/（接口契约）、research.md（决策）、quickstart.md（测试场景）
   - **如果存在**：加载 `/memory/constitution.md`，获取项目原则与治理约束
   - 注意：并非所有项目都有全部文档。根据现有文档生成任务。

3. **执行任务生成工作流**：
   - 加载 plan.md，提取技术栈、库、项目结构
   - 加载 spec.md，提取用户故事及其优先级（P1、P2、P3 等）
   - 如果 data-model.md 存在：提取实体并映射到用户故事
   - 如果 contracts/ 存在：把接口契约映射到用户故事
   - 如果 research.md 存在：提取决策用于准备任务
   - 生成按用户故事组织的任务（见下文"任务生成规则"）
   - 生成展示用户故事完成顺序的依赖图
   - 为每个用户故事创建并行执行示例
   - 验证任务完整性（每个用户故事拥有全部所需任务，且可独立测试）

4. **生成 tasks.md**：从 TASKS_TEMPLATE（来自上面的 JSON 输出）读取任务模板并以其为结构。如果 TASKS_TEMPLATE 为空，回退到 `.specify/templates/tasks-template.md`。填入：
   - 来自 plan.md 的正确功能名称
   - 阶段 1：准备任务（项目初始化）
   - 阶段 2：基础任务（所有用户故事的阻塞性前置工作）
   - 阶段 3+：每个用户故事一个阶段（按 spec.md 中的优先级顺序）
   - 每个阶段包括：故事目标、独立测试标准、测试（如果要求）、实现任务
   - 最后阶段：打磨与横切关注点
   - 所有任务必须严格遵循检查清单格式（见下文"任务生成规则"）
   - 每个任务有清晰的文件路径
   - 展示故事完成顺序的"依赖"小节
   - 每个故事的并行执行示例
   - "实现策略"小节（MVP 优先、增量交付）

## 强制性执行后钩子

**你必须先完成本节内容，然后才能向用户报告完成。**

检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果它不存在，或 `hooks.after_tasks` 下没有注册任何钩子，直接跳到"完成报告"。
- 如果存在，读取它并查找 `hooks.after_tasks` 键下的条目。
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并继续进入"完成报告"。
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **强制钩子**（`optional: false`）——**你必须为每个强制钩子输出 `EXECUTE_COMMAND:`**：
    ```
    ## 扩展钩子

    **自动钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```

## 完成报告

输出生成的 tasks.md 的路径及摘要：
- 任务总数
- 每个用户故事的任务数
- 识别出的并行机会
- 每个故事的独立测试标准
- 建议的 MVP 范围（通常只是用户故事 1）
- 格式校验：确认所有任务都遵循检查清单格式（复选框、ID、标签、文件路径）

任务生成的上下文：{ARGS}

tasks.md 应当可以立即执行——每个任务必须足够具体，使 LLM 无需额外上下文即可完成。

## 任务生成规则

**关键**：任务必须按用户故事组织，以支持独立实现和独立测试。

**测试是可选的**：只有当功能规范中明确要求、或用户要求 TDD 方式时，才生成测试任务。

### 检查清单格式（必须遵守）

每个任务都必须严格遵循以下格式：

```text
- [ ] [TaskID] [P?] [Story?] 带文件路径的任务描述
```

**格式组成**：

1. **复选框**：必须以 `- [ ]` 开头（markdown 复选框）
2. **任务 ID**：按执行顺序的连续编号（T001、T002、T003……）
3. **[P] 标记**：仅当任务可并行时包含（涉及不同文件、不依赖未完成的任务）
4. **[Story] 标签**：仅用户故事阶段的任务必需
   - 格式：[US1]、[US2]、[US3] 等（对应 spec.md 中的用户故事）
   - 准备阶段：不加故事标签
   - 基础阶段：不加故事标签
   - 用户故事阶段：必须带故事标签
   - 打磨阶段：不加故事标签
5. **描述**：清晰的动作说明，附确切的文件路径

**示例**：

- ✅ 正确：`- [ ] T001 按实现计划创建项目结构`
- ✅ 正确：`- [ ] T005 [P] 在 src/middleware/auth.py 中实现认证中间件`
- ✅ 正确：`- [ ] T012 [P] [US1] 在 src/models/user.py 中创建 User 模型`
- ✅ 正确：`- [ ] T014 [US1] 在 src/services/user_service.py 中实现 UserService`
- ❌ 错误：`- [ ] 创建 User 模型`（缺少任务 ID 和故事标签）
- ❌ 错误：`T001 [US1] 创建模型`（缺少复选框）
- ❌ 错误：`- [ ] [US1] 创建 User 模型`（缺少任务 ID）
- ❌ 错误：`- [ ] T001 [US1] 创建模型`（缺少文件路径）

### 任务组织

1. **来自用户故事（spec.md）**——首要的组织方式：
   - 每个用户故事（P1、P2、P3……）拥有自己的阶段
   - 把所有相关组件映射到对应的故事：
     - 该故事所需的模型
     - 该故事所需的服务
     - 该故事所需的接口/UI
     - 如果要求测试：该故事专属的测试
   - 标记故事间依赖（大多数故事应相互独立）

2. **来自契约**：
   - 每个接口契约 → 映射到它所服务的用户故事
   - 如果要求测试：每个接口契约 → 契约测试任务 [P]，置于该故事阶段的实现任务之前

3. **来自数据模型**：
   - 把每个实体映射到需要它的用户故事
   - 如果实体服务多个故事：放入最早的故事或准备阶段
   - 关系 → 对应故事阶段中的服务层任务

4. **来自准备/基础设施**：
   - 共享基础设施 → 准备阶段（阶段 1）
   - 基础性/阻塞性任务 → 基础阶段（阶段 2）
   - 故事专属的准备工作 → 放入该故事的阶段

### 阶段结构

- **阶段 1**：准备（项目初始化）
- **阶段 2**：基础（阻塞性前置工作——必须在用户故事之前完成）
- **阶段 3+**：按优先级排序的用户故事（P1、P2、P3……）
  - 每个故事内部：测试（如果要求）→ 模型 → 服务 → 接口端点 → 集成
  - 每个阶段都应是一个完整、可独立测试的增量
- **最后阶段**：打磨与横切关注点

## 完成标准

- [ ] 已生成包含所有阶段、任务 ID 和文件路径的 tasks.md
- [ ] 已按上文"强制性执行后钩子"中的规则分发或跳过扩展钩子
- [ ] 已向用户报告完成情况，包含任务总数、按故事的拆分和 MVP 范围
