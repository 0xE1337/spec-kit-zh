# 术语表（Glossary）

> 本项目所有翻译（人工与 AI 初翻）必须遵守本表，保证全库术语一致。
> 修改本表须同时全库检索受影响的旧译文。

## 核心术语

| English | 中文 | 说明 |
| --- | --- | --- |
| Spec-Driven Development (SDD) | 规范驱动开发 | 统一用"规范"，不用"规格" |
| specification / spec | 规范 | 指产出的规范文档时可译"规范文档" |
| constitution | 宪章 | 项目治理原则文件 `constitution.md` |
| plan / implementation plan | 实现计划 | |
| tasks | 任务清单 | |
| implement / implementation | 实现 | |
| clarify / clarification | 澄清 | |
| analyze / analysis | 分析 | |
| checklist | 检查清单 | |
| template | 模板 | |
| artifact | 产物 | 指 spec/plan/tasks 等生成的文档 |
| user story | 用户故事 | |
| guardrails | 护栏 | |
| scaffolding | 脚手架 | |
| checkpoint | 检查点 | |

## 生态与定制

| English | 中文 | 说明 |
| --- | --- | --- |
| extension | 扩展 | 增加新能力 |
| preset | 预设 | 定制既有工作流 |
| bundle | 套装 | 面向角色的组件打包 |
| override | 覆盖（项） | 项目本地覆盖 |
| catalog | 目录源 | bundle 的来源 |
| catalog stack | 目录源栈 | 优先级排序的目录源集合 |
| integration | 集成 | 指对接的 AI 编码工具 |
| skills mode | 技能模式 | |
| agent skill | 智能体技能 | |
| workflow | 工作流 | |
| walkthrough | 实战演练 | |

## AI 相关

| English | 中文 | 说明 |
| --- | --- | --- |
| AI coding agent | AI 编码智能体 | |
| slash command | 斜杠命令 | 如 `/speckit.specify` |
| prompt | 提示词 | |
| vibe coding | 氛围编码（vibe coding） | 每篇首次出现保留英文注音 |
| greenfield | 从零开发（greenfield） | |
| brownfield | 存量项目（brownfield） | |
| one-shot | 一次性生成 | |

## 不翻译的词

产品与专有名词一律保留英文：GitHub Copilot、Claude Code、Cursor、Gemini、Codex、uv、pipx、Python、Git、Kanban（首次出现可注"看板"）、issue、PR、release、tag、commit、fork、merge。

## 行文规范

- 代码块中的**命令、路径、标志（`--flag`）不翻译**；代码块内的**注释要翻译**
- 示例提示词（用户输入给 AI 的自然语言）**要翻译**——这是中文读者的核心价值
- 链接 URL 保持原样，链接文字翻译
- 中英文之间加半角空格
- 语气自然、面向开发者，避免翻译腔；长英文从句拆成短中文句

## 机器标记与结构约束（一期校审定稿）

以下内容**一律原样保留英文**，因为有程序或下游流程按字面匹配：

- 程序占位符与机器标记：`[NEEDS CLARIFICATION]`、`EXECUTE_COMMAND:`、`{ARGS}`、`$ARGUMENTS`、`{SCRIPT}`、`__SPECKIT_COMMAND_*__`、`[FEATURE NAME]`、`[P]`/`[Story]`/`[US1]` 等
- 枚举值与状态值：CRITICAL/HIGH/MEDIUM/LOW、PASS/FAIL、`missing`/`partial`/`contradicts`、`verified`/`community` 等（在定义处用中文解释）
- 用户应答匹配词："yes"/"no"/"done"/"proceed" 等引号内的字面匹配词
- CLI 实际输出文本（用户真实看到的就是英文；故障排查标题可用「出现 "..." 警告」的混合形式）
- front matter 中 handoffs 的 `label`/`prompt`（一期决定，二期评估本地化）

结构约束：

- **YAML front matter 必须保持在文件首行**；`zh-source`/`zh-base` 注释放在 front matter 结束之后
- front matter 只翻译 `description` 等展示性字段的值，`scripts:` 等字段原样保留

## 一期新增术语（2026-07-17 校审回填）

### 方法论

| English | 中文 |
| --- | --- |
| The Power Inversion | 权力反转 |
| source of truth | 事实来源（single source of truth → 唯一事实来源） |
| The Nine Articles of Development | 开发九条款（Article I–IX → 第一条…第九条） |
| living documentation | 活文档 |
| Flow-Forward / Flow-Back / Living Spec | 前推式规范 / 回流式规范 / 活规范（均附英文） |
| intent-driven development | 意图驱动开发 |
| sub-agent | 子智能体 |
| context compaction | 上下文压缩 |

### 命令与模板结构（章节标题统一）

| English | 中文 |
| --- | --- |
| Outline | 概要 |
| Done When | 完成标准 |
| Pre-Execution Checks | 执行前检查 |
| Mandatory Post-Execution Hooks | 强制性执行后钩子 |
| hook | 钩子 |
| Completion Report | 完成报告 |
| Handoff | 交接 |
| Setup / Foundational / Polish（阶段名） | 准备 / 基础 / 打磨（Polish & Cross-Cutting Concerns → 打磨与横切关注点） |
| Given / When / Then | 假设 / 当 / 那么（Gherkin zh-CN 官方关键字） |
| Acceptance Scenarios / Edge Cases | 验收场景 / 边界情况 |
| Key Entities / Assumptions | 关键实体 / 假设条件 |
| Constitution Check / Complexity Tracking | 宪章检查 / 复杂度跟踪 |
| contract / contract test | 契约 / 契约测试 |
| converge / convergence | 收敛 |
| severity / remediation | 严重级别 / 整改 |
| traceability / coverage gap | 可追溯性 / 覆盖缺口 |
| Success Criteria | 成功标准 |

### 通用技术词

| English | 中文 |
| --- | --- |
| idempotent | 幂等 |
| fan-out / fan-in | 扇出 / 扇入 |
| append-only | 只追加 |
| provenance | 溯源记录 |
| drift / terminology drift | 漂移 / 术语漂移 |
| escape hatch | 兜底方案 |
| scope creep | 范围蔓延 |
| boy-scout rule | 童子军法则 |
| monorepo | 保留英文（首次出现注"单仓多项目"） |
| air-gapped | 离线隔离（air-gapped） |
| wheel / worktree | 保留英文 |
| fail-closed / secure-by-default | 故障即拒绝（fail-closed）/ 默认安全（secure-by-default） |
| authentication | 认证 |
| PAT / service principal / tenant | PAT（个人访问令牌）/ 服务主体 / 租户 |
