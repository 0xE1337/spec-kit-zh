---
<!-- zh-base: 2a0ada9 -->
handoffs:
  - label: Create Tasks
    agent: speckit.tasks
    prompt: Break the plan into tasks
    send: true
  - label: Create Checklist
    agent: speckit.checklist
    prompt: Create a checklist for the following domain...
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
  py: scripts/python/setup_plan.py --json
---

<!-- zh-source: templates/commands/plan.md -->
<!-- zh-base: c8ce488 -->

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑用户输入（如果不为空）。

## 执行前检查

**检查扩展钩子（规划之前）**：
- 检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.before_plan` 键下的条目
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并正常继续
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对其余每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选前置钩子**：{extension}
    命令：`/{command}`
    描述：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```
  - **强制钩子**（`optional: false`）：
    ```
    ## 扩展钩子

    **自动前置钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}

    等待钩子命令的结果后，再继续执行"概要"部分。
    ```
    输出上面的代码块之后，你必须真正调用该钩子，并等待它完成后再继续。请像你在本智能体/会话中亲自运行该命令那样运行它（实际调用方式可能与上面所示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行）。仅输出代码块本身并不会运行钩子。
- 如果没有注册任何钩子，或 `.specify/extensions.yml` 不存在，静默跳过

## 概要

1. **准备**：在仓库根目录运行 `{SCRIPT}`，解析 JSON 中的 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。参数中含单引号（如 "I'm Groot"）时，使用转义语法：例如 'I'\''m Groot'（或尽可能用双引号："I'm Groot"）。

2. **加载上下文**：读取 FEATURE_SPEC 和 `/memory/constitution.md`。加载 IMPL_PLAN 模板（已复制到位）。

3. **执行计划工作流**：按照 IMPL_PLAN 模板中的结构：
   - 填写技术上下文（Technical Context）（把未知项标记为 "NEEDS CLARIFICATION"）
   - 根据宪章填写宪章检查（Constitution Check）小节
   - 评估关卡（若存在无正当理由的违规，则报 ERROR）
   - 阶段 0：生成 research.md（解决所有 NEEDS CLARIFICATION）
   - 阶段 1：生成 data-model.md、contracts/、quickstart.md
   - 设计完成后重新评估宪章检查

## 强制性执行后钩子

**你必须先完成本节，才能向用户报告完成。**

检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果不存在，或 `hooks.after_plan` 下没有注册任何钩子，直接跳到"完成报告"。
- 如果存在，读取它并查找 `hooks.after_plan` 键下的条目。
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并继续执行"完成报告"。
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对其余每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **强制钩子**（`optional: false`）——**你必须为每个强制钩子输出 `EXECUTE_COMMAND:`**：
    ```
    ## 扩展钩子

    **自动钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}
    ```
    输出上面的代码块之后，你必须真正调用该钩子，并等待它完成后再继续。请像你在本智能体/会话中亲自运行该命令那样运行它（实际调用方式可能与上面所示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行）。仅输出代码块本身并不会运行钩子。
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选钩子**：{extension}
    命令：`/{command}`
    描述：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```

## 完成报告

命令在阶段 1 设计完成后结束。报告分支、IMPL_PLAN 路径和已生成的产物。

## 阶段

### 阶段 0：概要与研究

1. **从上文的技术上下文（Technical Context）中提取未知项**：
   - 每个 NEEDS CLARIFICATION → 一个研究任务
   - 每个依赖 → 一个最佳实践调研任务
   - 每个集成 → 一个模式调研任务

2. **生成并派发研究智能体**：

   ```text
   对技术上下文中的每个未知项：
     Task: "针对 {feature context} 研究 {unknown}"
   对每个技术选型：
     Task: "调研 {tech} 在 {domain} 领域的最佳实践"
   ```

3. **汇总研究结果**到 `research.md`，使用以下格式：
   - 决策：[选择了什么]
   - 理由：[为什么选它]
   - 考虑过的备选方案：[还评估过什么]

**输出**：research.md，其中所有 NEEDS CLARIFICATION 均已解决

### 阶段 1：设计与契约

**前置条件**：`research.md` 已完成

1. **从功能规范中提取实体** → `data-model.md`：
   - 实体名称、字段、关系
   - 来自需求的验证规则
   - 状态流转（如适用）

2. **定义接口契约**（如果项目有对外接口）→ `/contracts/`：
   - 识别项目向用户或其他系统暴露哪些接口
   - 用适合项目类型的格式记录契约
   - 示例：库的公共 API、CLI 工具的命令模式（schema）、Web 服务的端点、解析器的文法、应用的 UI 契约
   - 如果项目纯属内部性质（构建脚本、一次性工具等），跳过此步

3. **创建快速上手验证指南** → `quickstart.md`：
   - 记录可运行的验证场景，证明功能端到端可用
   - 包含前置条件、环境准备命令、测试/运行命令和预期结果
   - 对契约和数据模型细节使用链接或引用，不要重复其内容
   - 不要包含完整的实现代码、模型/服务/控制器代码体、数据库迁移或完整的测试套件
   - 让这份产物保持为验证/运行指南；实现细节属于 `tasks.md` 和实现阶段

**输出**：data-model.md、/contracts/*、quickstart.md

## 关键规则

- 文件系统操作使用绝对路径；文档中的引用使用项目相对路径
- 关卡失败或存在未解决的澄清项时报 ERROR

## 完成标准

- [ ] 计划工作流已执行，设计产物已生成
- [ ] 扩展钩子已按上文"强制性执行后钩子"的规则分发或跳过
- [ ] 已向用户报告完成情况，包含分支、计划路径和已生成的产物
