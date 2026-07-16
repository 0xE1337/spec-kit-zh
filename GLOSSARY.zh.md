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
