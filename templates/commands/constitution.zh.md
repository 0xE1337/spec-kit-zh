---
description: 根据交互式或用户提供的原则输入创建或更新项目宪章，并确保所有依赖它的模板保持同步。
handoffs:
  - label: Build Specification
    agent: speckit.specify
    prompt: Implement the feature specification based on the updated constitution. I want to build...
---

<!-- zh-source: templates/commands/constitution.md -->
<!-- zh-base: 8c816fa -->

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑上述用户输入（如果不为空）。

## 范围守护

本命令自身的工作仅限于更新项目宪章，并把由宪章驱动的变更传播到本命令所指明的依赖产物。

- 把用户输入的每一部分归类为宪章内容，或是与治理无关的独立意图。
- 如果输入中包含功能实现、代码生成、重构、构建或部署请求，你**绝不能**执行它们，而应把它们提取为延后意图。
- 你**绝不能**创建、修改或删除应用源文件、功能路由、组件、测试、部署文件，或其他与宪章工作流及其必要传播无关的产物。
- 如果无法确定某条指令是否属于宪章内容，先请求澄清再做改动。
- 完成宪章更新后，为每个延后意图添加一个"后续行动"（Next Actions）小节。列出原始意图，并建议对应的后续 Spec Kit 命令（例如 `__SPECKIT_COMMAND_SPECIFY__`），但不要调用它。
- 如果没有与治理无关的意图，则省略"后续行动"小节。

## 执行前检查

**检查扩展钩子（宪章更新之前）**：
- 检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.before_constitution` 键下的条目
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

你正在更新位于 `.specify/memory/constitution.md` 的项目宪章。这个文件是一个模板，包含方括号形式的占位符（例如 `[PROJECT_NAME]`、`[PRINCIPLE_1_NAME]`）。你的工作是：(a) 收集/推导具体的值，(b) 精确地填充模板，(c) 把所有修订传播到依赖它的产物中。

**注意**：如果 `.specify/memory/constitution.md` 尚不存在，它本应在项目初始化时从 `.specify/templates/constitution-template.md` 生成。如果确实缺失，先复制该模板。

按以下执行流程操作：

1. 加载 `.specify/memory/constitution.md` 中的现有宪章。
   - 识别所有 `[ALL_CAPS_IDENTIFIER]` 形式的占位符。
   **重要**：用户需要的原则数量可能比模板中使用的更少或更多。如果指定了数量，遵照执行——按通用模板的方式处理，并相应更新文档。

2. 收集/推导占位符的值：
   - 如果用户输入（对话）提供了某个值，使用它。
   - 否则从现有仓库上下文推断（README、docs、嵌入的先前宪章版本等）。
   - 关于治理日期：`RATIFICATION_DATE` 是最初的通过日期（如果未知就询问用户或标记 TODO）；`LAST_AMENDED_DATE` 在有修改时取今天，否则保留先前的值。
   - `CONSTITUTION_VERSION` 必须按语义化版本规则递增：
     - MAJOR：不向后兼容的治理/原则删除或重新定义。
     - MINOR：新增原则/章节，或实质性扩充指导内容。
     - PATCH：澄清、措辞、错别字修复等非语义性完善。
   - 如果版本递增类型不明确，先给出理由再定稿。

3. 起草更新后的宪章内容：
   - 用具体文本替换每一个占位符（不留下方括号标记，除非是项目有意保留、尚未定义的模板槽位——对任何保留项都要明确说明理由）。
   - 保持标题层级不变；注释在被替换后即可删除，除非它们仍能提供澄清价值。
   - 确保每个"原则"小节包含：一行简洁的名称、一段（或一组要点）阐明不可协商的规则，以及在理由不显而易见时的明确说明。
   - 确保"治理"（Governance）小节列出修订程序、版本策略和合规审查要求。

4. 一致性传播检查清单（把先前的检查清单转为主动校验）：
   - 阅读 `.specify/templates/plan-template.md`，确保其中的"宪章检查"（Constitution Check）或相关规则与更新后的原则一致。
   - 阅读 `.specify/templates/spec-template.md`，检查范围/需求的一致性——如果宪章增删了强制章节或约束，进行更新。
   - 阅读 `.specify/templates/tasks-template.md`，确保任务分类反映新增或删除的、由原则驱动的任务类型（例如可观测性、版本管理、测试纪律）。
   - 阅读为你的智能体安装的每个 Spec Kit 命令文件（包括本文件）——命名为 `speckit.*` 或 `speckit-*`（点号或连字符取决于智能体），对于基于技能的集成则以 `speckit-<name>/SKILL.md` 的形式存放，例如位于 `.github/agents/`、`.github/skills/`、`.claude/skills/` 或你的智能体对应的命令目录中——核验在需要通用指导的地方不再残留过时引用（仅限 CLAUDE 或其他智能体专属的名称）。
   - 阅读所有运行时指导文档（例如 `README.md`、`docs/quickstart.md`，或存在的智能体专属指导文件）。更新其中对已变更原则的引用。

5. 产出一份同步影响报告（Sync Impact Report，在更新后以 HTML 注释形式添加到宪章文件顶部）：
   - 版本变化：旧 → 新
   - 修改过的原则列表（如有重命名，给出旧标题 → 新标题）
   - 新增的章节
   - 删除的章节
   - 需要更新的模板（✅ 已更新 / ⚠ 待处理），附文件路径
   - 如有占位符被有意延后处理，列出后续 TODO。

6. 最终输出前的校验：
   - 没有遗留的、无法解释的方括号标记。
   - 版本行与报告一致。
   - 日期使用 ISO 格式 YYYY-MM-DD。
   - 原则是声明式、可检验的，且没有含糊措辞（"should" → 在合适之处改为 MUST/SHOULD 并附理由）。

7. 把完成的宪章写回 `.specify/memory/constitution.md`（覆盖写入）。

8. 向用户输出最终摘要，包含：
   - 新版本号及递增理由。
   - 任何被标记为需要手动跟进的文件。
   - 建议的 commit 信息（例如 `docs: amend constitution to vX.Y.Z (principle additions + governance update)`）。
   - 针对任何延后的、与治理无关的意图，给出一个"后续行动"小节。

格式与风格要求：

- 严格使用模板中的 Markdown 标题层级（不要降级/升级标题）。
- 较长的理由说明适当换行以保持可读性（理想情况下每行少于 100 字符），但不要为此生硬断行。
- 各章节之间保留单个空行。
- 避免行尾空白。

如果用户只提供部分更新（例如只修订一条原则），仍然要执行校验和版本判定步骤。

如果关键信息缺失（例如通过日期确实无从得知），插入 `TODO(<FIELD_NAME>): 说明`，并在同步影响报告的延后事项中列出。

不要创建新模板；始终在现有的 `.specify/memory/constitution.md` 文件上操作。

## 执行后检查

**检查扩展钩子（宪章更新之后）**：
检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.after_constitution` 键下的条目
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并正常继续
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```
  - **强制钩子**（`optional: false`）：
    ```
    ## 扩展钩子

    **自动钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。
- 如果没有注册任何钩子，或 `.specify/extensions.yml` 不存在，则静默跳过
