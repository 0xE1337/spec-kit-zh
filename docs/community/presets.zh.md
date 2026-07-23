<!-- zh-source: docs/community/presets.md -->
<!-- zh-base: b91e30a -->

# 社区预设

> [!NOTE]
> 社区预设由各自的作者独立创建和维护。维护者只验证目录源条目完整且格式正确——他们**不会审查、审计、背书或支持预设代码本身**。安装前请审查预设源码，使用风险自行判断。

以下社区贡献的预设可以定制 Spec Kit 的行为——覆盖模板、命令和术语，而不改动任何工具链。这些预设收录在 [`catalog.community.json`](https://github.com/github/spec-kit/blob/main/presets/catalog.community.json) 中：

| 预设 | 用途 | 提供 | 依赖 | URL |
|--------|---------|----------|----------|-----|
| A11Y Governance | 添加无障碍（WCAG 2.2 AA）、德英双语交付、CEFR-B2 可读性、包容性内容治理、教学式代码内联注释审查，以及可供审计的 Spec Kit 运行证据 | 10 个模板、3 个命令 | — | [spec-kit-preset-a11y-governance](https://github.com/hindermath/spec-kit-preset-a11y-governance) |
| Agent Parity Governance | 在项目声明的各个 AI 智能体指令面上，添加共享指引一致性、可供审计的 Spec Kit 运行证据，以及与智能体无关的模型路由指引，防止智能体指引发生漂移。 | 6 个模板、3 个命令 | — | [spec-kit-preset-agent-parity-governance](https://github.com/hindermath/spec-kit-preset-agent-parity-governance) |
| AIDE In-Place Migration | 把 AIDE 扩展的工作流适配为原地技术迁移（X → Y 模式）——添加迁移目标、验证关卡、知识文档和行为等价性标准 | 2 个模板、8 个命令 | AIDE 扩展 | [spec-kit-presets](https://github.com/mnriem/spec-kit-presets) |
| Architecture Governance | 添加安全软件架构、STRIDE+CAPEC 威胁建模、arc42 安全横切概念、S-ADR、零信任适用性、OWASP SAMM 治理、BSI C3A 云自主性、BSI C5 云合规保障，以及可供审计的 Spec Kit 运行证据 | 13 个模板、3 个命令 | — | [spec-kit-preset-architecture-governance](https://github.com/hindermath/spec-kit-preset-architecture-governance) |
| Autonomous Run Governance | 为完整的 Spec Kit 自主交付添加权限受限、证据优先的治理，涵盖经校验的状态、停止、显式续跑、精确 HEAD 证明、合并后收尾、回顾式学习，以及功能创建前可选的、由策略驱动的入库审查关卡。 | 13 个模板、5 个命令、4 个脚本 | — | [spec-kit-preset-autonomous-run-governance](https://github.com/hindermath/spec-kit-preset-autonomous-run-governance) |
| Canon Core | 调整原版 Spec Kit 工作流，使其与 Canon 扩展协同工作 | 2 个模板、8 个命令 | — | [spec-kit-canon](https://github.com/maximiliamus/spec-kit-canon) |
| Claude AskUserQuestion | 把 Claude Code 上的 `/speckit.clarify` 和 `/speckit.checklist` 从 Markdown 表格式提问升级为原生的 AskUserQuestion 选择器，每个问题都带有推荐选项和理由 | 2 个命令 | — | [spec-kit-preset-claude-ask-questions](https://github.com/0xrafasec/spec-kit-preset-claude-ask-questions) |
| Command Density | 压缩九个核心 Spec Kit 命令提示词，同时保留脚本、交接、占位符、钩子输出块和规则结构 | 9 个命令 | — | [spec-kit-preset-command-density](https://github.com/Xopoko/spec-kit-preset-command-density) |
| Cross-Platform Governance | 为使用 Spec Kit 管理的脚本项目添加 Bash 与 PowerShell 对等实现、Unix man 手册页、双语注释式帮助、Verb-Noun Cmdlet 命名纪律，以及可供审计的 Spec Kit 运行证据 | 8 个模板、3 个命令 | — | [spec-kit-preset-cross-platform-governance](https://github.com/hindermath/spec-kit-preset-cross-platform-governance) |
| Explicit Task Dependencies | 在 tasks.md 中添加显式的 `(depends on T###)` 依赖声明和执行波次 DAG，用于并行调度 | 1 个模板、1 个命令 | — | [spec-kit-preset-explicit-task-dependencies](https://github.com/Quratulain-bilal/spec-kit-preset-explicit-task-dependencies) |
| Fiction Book Writing | 把规范驱动开发工作流适配为故事创作，支持以 12 种语言创作图书或有声书（含注释）：功能变成故事元素，规范变成故事简报，计划变成故事结构，任务变成逐场景的写作任务。支持单视角和多视角（POV）、所有主流情节结构框架，以及两种文风模式：作者语料样本或人性化 AI 行文原则。支持头脑风暴、访谈、角色扮演等交互元素，以及统计、封面生成器、插图生成器和作者简介命令等附加功能。可用 KDP、D2D 等平台的模板导出。 | 26 个模板、34 个命令、2 个脚本 | — | [speckit-preset-fiction-book-writing](https://github.com/adaumann/speckit-preset-fiction-book-writing) |
| Game Narrative Writing | 面向游戏叙事设计与交互式故事创作的预设。它把规范驱动开发工作流适配为游戏叙事：功能变成故事机制，规范变成叙事简报，计划变成故事地图，任务变成对白和场景写作任务。支持分支叙事、玩家能动性系统、状态机和交互式对话树。 | 37 个模板、34 个命令、5 个脚本 | — | [speckit-preset-game-narrative-writing](https://github.com/adaumann/speckit-preset-game-narrative-writing) |
| Intake Authoring Governance | 从有序的文本来源创建可追溯的 Spec Kit 入库文件和回执，同时保持澄清、更新和交付授权的边界。 | 7 个模板、2 个命令、2 个脚本 | — | [spec-kit-preset-intake-authoring-governance](https://github.com/hindermath/spec-kit-preset-intake-authoring-governance) |
| Intake Review Governance | 在交互式、自主或并行的 Spec Kit 执行之前，为单个、系列和批量的入库文件添加哈希绑定的审查、修复和状态关卡。 | 8 个模板、3 个命令、2 个脚本 | — | [spec-kit-preset-intake-review-governance](https://github.com/hindermath/spec-kit-preset-intake-review-governance) |
| iSAQB Architecture Governance | 添加通用的 iSAQB/CPSA-F 与 arc42 软件架构治理，包括覆盖架构目标、视图、质量场景、ADR、风险和技术债的可供审计的 Spec Kit 运行证据。 | 13 个模板、3 个命令 | — | [spec-kit-preset-isaqb-architecture-governance](https://github.com/hindermath/spec-kit-preset-isaqb-architecture-governance) |
| Jira Issue Tracking | 覆盖 `speckit.taskstoissues`，通过 Atlassian MCP 工具创建 Jira epic、story 和 task，替代 GitHub issue | 1 个命令 | — | [spec-kit-preset-jira](https://github.com/luno/spec-kit-preset-jira) |
| Model Driven Engineering | 聚焦于精简命令、应用仓库支持、跨规范支持，以及面向模型驱动工程工作流的能力感知项目记忆 | 6 个模板、11 个命令 | MDE 扩展 | [spec-kit-preset-mde](https://github.com/AI-MDE/spec-kit-preset-mde) |
| Multi-Repo Branching | 在计划和任务阶段，协调跨多个 git 仓库（独立仓库和子模块）的功能分支创建 | 2 个命令 | — | [spec-kit-preset-multi-repo-branching](https://github.com/sakitA/spec-kit-preset-multi-repo-branching) |
| Parallel Autonomous Run Governance | 协调隔离的 Spec Kit 自主批量任务，支持有界并发、混合智能体、可续跑的合并、受治理的合并后收尾、schema 1.2，以及调度 worker 前可选的当前入库审查关卡。 | 9 个模板、5 个命令、2 个脚本 | autonomous-run-governance >=0.3.2；可选：intake-review-governance >=0.1.0 | [spec-kit-preset-parallel-autonomous-run-governance](https://github.com/hindermath/spec-kit-preset-parallel-autonomous-run-governance) |
| Pirate Speak (Full) | 把所有 Spec Kit 输出变成海盗腔——规范变成"航海宣言"，计划变成"作战计划"，任务变成"船员任务分派" | 6 个模板、9 个命令 | — | [spec-kit-presets](https://github.com/mnriem/spec-kit-presets) |
| Screenwriting | 面向编剧/剧本创作/教程的规范驱动开发：支持电影长片、电视剧（试播集、单集、限定剧）和舞台剧。把 Spec Kit 工作流适配为剧本创作技艺——场景标题（slug line）、动作描述行、幕间转折、节拍表和行业标准的提案文档。支持三幕式、Save the Cat、电视试播集、电视网单集、有线/流媒体单集和舞台剧等结构框架。可导出为 Fountain、FTX、PDF | 26 个模板、32 个命令、1 个脚本 | — | [speckit-preset-screenwriting](https://github.com/adaumann/speckit-preset-screenwriting) |
| Security Governance | 添加内存安全语言偏好、按语言定制的安全编码配置、可供审计的 Spec Kit 运行证据、ASVS 验证、SBOM/AI-SBOM 供应链透明度、CRA 意识，以及针对 NIS2、CRA、欧盟 AI 法案和 DORA 的法规适用性筛查 | 14 个模板、3 个命令 | — | [spec-kit-preset-security-governance](https://github.com/hindermath/spec-kit-preset-security-governance) |
| SicarioSpec Core | 默认安全（secure-by-default）的 Spec Kit 治理基线配置。 | 5 个模板 | — | [sicario-spec](https://github.com/dfirs1car1o/sicario-spec) |
| Spec2Cloud | 为交付到 Azure 调优的规范驱动工作流：规范 → 计划 → 任务 → 实现 → 部署 | 5 个模板、8 个命令 | — | [spec2cloud](https://github.com/Azure-Samples/Spec2Cloud) |
| Table of Contents Navigation | 为生成的 spec.md、plan.md 和 tasks.md 文档添加可导航的目录 | 3 个模板、3 个命令 | — | [spec-kit-preset-toc-navigation](https://github.com/Quratulain-bilal/spec-kit-preset-toc-navigation) |
| Test-First Governance | 用覆盖完整的 BDD/ATDD Gherkin 场景、明确的测试套件归属、专业的测试报告、可追溯性和基于风险的质量关卡来治理 TDD。 | 10 个模板、8 个命令 | — | [spec-kit-preset-test-first-governance](https://github.com/ka-zo/spec-kit-preset-test-first-governance) |
| VS Code Ask Questions | 增强澄清命令，使用 `vscode/askQuestions` 进行批量交互式提问。 | 1 个命令 | — | [spec-kit-presets](https://github.com/fdcastel/spec-kit-presets) |
| Workflow Preset | 行为优先的规范编写、设计产物与智能体原生的交接编排——添加需求阶段的行为草稿、正式的 BDD/UIF/行为契约、可选的设计产物，以及带 Core Agent、Vertical Planner Agent 和 Worker Agent 模式的按范围划分的实现交接 | 22 个模板、8 个命令 | — | [spec-kit-workflow-preset](https://github.com/bigsmartben/spec-kit-workflow-preset) |

要构建并发布你自己的预设，参见[预设发布指南](https://github.com/github/spec-kit/blob/main/presets/PUBLISHING.md)。
