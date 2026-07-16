<!-- zh-source: docs/community/extensions.md -->
<!-- zh-base: c40db8a -->

# 社区扩展

> [!NOTE]
> 社区扩展由各自的作者独立创建和维护。维护者只验证目录源条目完整且格式正确——他们**不会审查、审计、背书或支持扩展代码本身**。社区扩展网站同样是第三方资源。安装前请审查扩展源码，使用风险自行判断。

🔍 **在[社区扩展网站](https://speckit-community.github.io/extensions/)上浏览和搜索社区扩展。**

以下社区贡献的扩展收录在 [`catalog.community.json`](https://github.com/github/spec-kit/blob/main/extensions/catalog.community.json) 中：

**分类**（以下是常见取值，但允许任意字符串）：

- `docs` —— 读取、校验或生成规范产物
- `code` —— 审查、校验或修改源代码
- `process` —— 跨阶段编排工作流
- `integration` —— 与外部平台同步
- `visibility` —— 报告项目健康度或进度

**作用方式**（`extension.yml` 与目录源中的规范取值）：

- `read-only` —— 只生成报告，不修改文件（表格中显示为 `Read-only`）
- `read-write` —— 修改文件、创建产物或更新规范（表格中显示为 `Read+Write`）

> [!TIP]
> 扩展作者可以在 `extension.yml` 的 `extension:` 块中声明 `category` 和 `effect`。这些字段同样存在于 `catalog.community.json` 中，供工具链和 CLI（`specify extension info`）使用。

| 扩展 | 用途 | 分类 | 作用方式 | URL |
|-----------|---------|----------|--------|-----|
| Agent Assign | 为 spec-kit 任务指派专门的 Claude Code 智能体，实现有针对性的执行 | `process` | Read+Write | [spec-kit-agent-assign](https://github.com/xymelon/spec-kit-agent-assign) |
| Agent Governance | 从 Spec Kit 元数据生成智能体平台的仓库治理文件 | `process` | Read+Write | [spec-kit-agent-governance](https://github.com/bigsmartben/spec-kit-agent-governance) |
| AI-Driven Engineering (AIDE) | 借助 AI 助手从零构建新项目的结构化 7 步工作流——从愿景到实现 | `process` | Read+Write | [aide](https://github.com/mnriem/spec-kit-extensions/tree/main/aide) |
| Analytics | 度量你的 AI 构建了什么，以及它为你节省了多少时间 | `visibility` | Read+Write | [spec-kit-analytics](https://github.com/Fyloss/spec-kit-analytics) |
| API Evolve | 受管的 API 契约演进——覆盖 REST、GraphQL 和 gRPC 的破坏性变更检测、semver 强制执行、弃用编排和生命周期关卡 | `process` | Read+Write | [spec-kit-api-evolve](https://github.com/Quratulain-bilal/spec-kit-api-evolve) |
| Architect Impact Previewer | 在实现之前，预测拟议变更的架构影响、复杂度和风险。 | `visibility` | Read-only | [spec-kit-architect-preview](https://github.com/UmmeHabiba1312/spec-kit-architect-preview) |
| Architecture Guard | 与框架无关的架构审查扩展，用于对照治理与架构宪章校验实现、检测架构漂移，并生成非阻塞的重构任务 | `process` | Read+Write | [spec-kit-architecture-guard](https://github.com/DyanGalih/spec-kit-architecture-guard) |
| Architecture Workflow | 通过单视图命令与全流程命令，生成或逆向项目级 4+1 架构视图 | `docs` | Read+Write | [spec-kit-arch](https://github.com/bigsmartben/spec-kit-arch) |
| Archive Extension | 把已合并的功能归档到主项目记忆中。 | `docs` | Read+Write | [spec-kit-archive](https://github.com/stn1slv/spec-kit-archive) |
| Azure DevOps Integration | 使用 OAuth 认证，把用户故事和任务同步到 Azure DevOps 工作项 | `integration` | Read+Write | [spec-kit-azure-devops](https://github.com/pragya247/spec-kit-azure-devops) |
| Blueprint | 在 AI 驱动的开发中保持对代码的掌控：在 /speckit.implement 运行之前，基于规范产物审查每个任务的完整代码蓝图 | `docs` | Read+Write | [spec-kit-blueprint](https://github.com/chordpli/spec-kit-blueprint) |
| Branch Convention | 为 /specify 提供可配置的分支和文件夹命名约定，支持预设和自定义模式 | `process` | Read+Write | [spec-kit-branch-convention](https://github.com/Quratulain-bilal/spec-kit-branch-convention) |
| Brownfield Bootstrap | 为现有代码库引导启用 spec-kit——自动发现架构，渐进式采用规范驱动开发 | `process` | Read+Write | [spec-kit-brownfield](https://github.com/Quratulain-bilal/spec-kit-brownfield) |
| BrownKit | 面向现有代码库的证据驱动能力发现、安全与 QA 风险评估 | `process` | Read+Write | [BrownKit](https://github.com/MaksimShevtsov/BrownKit) |
| Bugfix Workflow | 结构化的缺陷修复工作流——捕获 bug、追溯到规范产物，并对规范做外科手术式修补 | `process` | Read+Write | [spec-kit-bugfix](https://github.com/Quratulain-bilal/spec-kit-bugfix) |
| Canon | 添加基准驱动（canon-driven）的工作流：规范优先、代码优先、规范漂移。需要先安装 Canon Core 预设。 | `process` | Read+Write | [spec-kit-canon](https://github.com/maximiliamus/spec-kit-canon/tree/master/extension) |
| Catalog CI | 对 spec-kit 社区目录源条目的自动化校验——结构、URL、差异和 lint 检查 | `process` | Read-only | [spec-kit-catalog-ci](https://github.com/Quratulain-bilal/spec-kit-catalog-ci) |
| Charter | 从共享片段注册表组合模块化的项目宪章。集中管理治理规则、按项目挑选片段、跟踪上游变更，保持多项目配置的一致性。 | `process` | Read+Write | [spec-kit-charter](https://github.com/Fyloss/spec-kit-charter) |
| CI Guard | 面向 CI/CD 的规范合规关卡——验证规范存在、检查漂移，并在有缺口时阻止 merge | `process` | Read-only | [spec-kit-ci-guard](https://github.com/Quratulain-bilal/spec-kit-ci-guard) |
| Checkpoint Extension | 在实现过程中途提交变更，避免最后只留下一个巨大的 commit | `code` | Read+Write | [spec-kit-checkpoint](https://github.com/aaronrsun/spec-kit-checkpoint) |
| Cleanup Extension | 实现后的质量关卡：审查变更、修复小问题（童子军法则）、为中等问题创建任务、为大问题生成分析 | `code` | Read+Write | [spec-kit-cleanup](https://github.com/dsrednicki/spec-kit-cleanup) |
| Coding Standards Drift Control | 为进行中的 Spec Kit 功能生成编码标准漂移报告和修复任务 | `code` | Read+Write | [spec-kit-coding-standards-drift-control](https://github.com/benizzio/spec-kit-coding-standards-drift-control) |
| Conduct Extension | 通过子智能体委派编排 spec-kit 各阶段，减少上下文污染。 | `process` | Read+Write | [spec-kit-conduct-ext](https://github.com/twbrandon7/spec-kit-conduct-ext) |
| Confluence Extension | 在 Confluence 中创建一篇文档，汇总规范与计划文件 | `integration` | Read+Write | [spec-kit-confluence](https://github.com/aaronrsun/spec-kit-confluence) |
| Cost Tracker | 跟踪规范驱动开发工作流中真实的 LLM 美元成本——按功能编制预算、按集成对比，并提供可直接交给财务的导出 | `visibility` | Read+Write | [spec-kit-cost](https://github.com/Quratulain-bilal/spec-kit-cost) |
| Data Model Diagram | 规划完成后，从 Spec Kit 数据模型生成 Mermaid ER 图 | `docs` | Read+Write | [spec-kit-data-model-diagram](https://github.com/benizzio/spec-kit-data-model-diagram) |
| DocGuard — CDD Enforcement | 唯一同时具备 MCP 服务器、SARIF/JUnit 输出和确定性零 LLM 内核的文档完整性引擎。对照代码校验、评分并追溯文档——27 个校验器、稳定的发现编码、面向遗留仓库的采纳基线、合规证据报告、带 PR 批注的 GitHub Action，以及 spec-kit 钩子。纯 Node.js，只有一个固定版本的依赖。 | `docs` | Read+Write | [spec-kit-docguard](https://github.com/raccioly/docguard) |
| Dotdog | 把 GitHub Spec Kit 产物导入本地知识图谱，用于校验、分析、搜索和 MCP 查询。 | `docs` | Read+Write | [dotdog](https://github.com/specdog/dotdog) |
| EARS Requirements Syntax | 使用 EARS 编写、检查和转换需求——五种行业标准句式，产出无歧义、可测试的需求 | `docs` | Read+Write | [spec-kit-ears](https://github.com/dhruv-15-03/spec-kit-ears) |
| Extensify | 创建并校验扩展和扩展目录源 | `process` | Read+Write | [extensify](https://github.com/mnriem/spec-kit-extensions/tree/main/extensify) |
| Figma Starter | 把 Figma 分区中的屏幕转换为逐屏的 spec.md 文件、应用级的 user-stories.md 和 build-order.md，然后交接给 /speckit.specify | `integration` | Read+Write | [spec-kit-figma-starter](https://github.com/wavemaker/spec-kit-figma-starter) |
| Fix Findings | 自动化的"分析—修复—再分析"循环，持续解决规范问题直至干净 | `code` | Read+Write | [spec-kit-fix-findings](https://github.com/Quratulain-bilal/spec-kit-fix-findings) |
| FixIt Extension | 感知规范的 bug 修复——把 bug 映射到规范产物、提出计划、应用最小改动 | `code` | Read+Write | [spec-kit-fixit](https://github.com/speckit-community/spec-kit-fixit) |
| Fleet Orchestrator | 编排完整的功能生命周期，在 SpecKit 所有阶段设置人工介入（human-in-the-loop）关卡 | `process` | Read+Write | [spec-kit-fleet](https://github.com/sharathsatish/spec-kit-fleet) |
| GitHub Issues Integration 1 | 从 GitHub issue 生成规范产物——导入 issue、同步更新，并维护双向可追溯性 | `integration` | Read+Write | [spec-kit-github-issues](https://github.com/Fatima367/spec-kit-github-issues) |
| GitHub Issues Integration 2 | 从已有的 GitHub issue 创建并同步本地规范 | `integration` | Read+Write | [spec-kit-issue](https://github.com/aaronrsun/spec-kit-issue) |
| Golden Demo | 确定性的行为漂移预言机。提取验收标准，生成模糊测试向量（seed=42），把黄金 Python 实现与任意语言的真实代码对比。带 warn/strict 两种模式的 CI/CD 守门员。 | `docs` | Read+Write | [spec-kit-golden-demo](https://github.com/jasstt/spec-kit-golden-demo) |
| Improve Extension | 以资深顾问的视角审计任意代码库，并在 specs/ 下写出按优先级排序、自包含的规范提示词，供 spec-kit 生命周期处理 | `process` | Read+Write | [spec-kit-improve](https://github.com/d0whc3r/spec-kit-improve) |
| Intake | 把 PRD、设计稿、HTML SSOT 和测试用例证据规整为可直接进入规范驱动开发的入库产物。 | `docs` | Read+Write | [spec-kit-intake](https://github.com/bigsmartben/spec-kit-intake) |
| Intelligent Agent Orchestrator | 跨目录源的智能体发现，以及从提示词到命令的智能路由 | `process` | Read+Write | [spec-kit-orchestrator](https://github.com/pragya247/spec-kit-orchestrator) |
| Iterate | 用"先定义、后应用"的两阶段工作流迭代规范文档——在实现中途完善规范，然后直接回去继续构建 | `docs` | Read+Write | [spec-kit-iterate](https://github.com/imviancagrace/spec-kit-iterate) |
| Jira Integration | 从 spec-kit 规范和任务拆解创建 Jira Epic、Story 和 Issue，支持可配置的层级和自定义字段 | `integration` | Read+Write | [spec-kit-jira](https://github.com/mbachorik/spec-kit-jira) |
| Jira Integration (Sync Engine) | 幂等、感知漂移、故障即拒绝（fail-closed）的对账引擎，把 spec-kit 规范镜像到 Jira（每个仓库一个 Epic、每份规范一个 Story、每个阶段一个 Subtask） | `integration` | Read+Write | [spec-kit-jira-sync](https://github.com/ashbrener/spec-kit-jira-sync) |
| Learning Extension | 从实现生成教学指南，并为澄清补充导师式讲解上下文 | `docs` | Read+Write | [spec-kit-learn](https://github.com/imviancagrace/spec-kit-learn) |
| Linear Integration | 把 spec-kit 功能目录镜像到 Linear（文件系统 → Linear，基于对账，单向）。 | `integration` | Read+Write | [spec-kit-linear-sync](https://github.com/ashbrener/spec-kit-linear-sync) |
| LLM Wiki | 由 LLM 维护、持续累积的项目 wiki：源码摄取、带引用的回答和一致性检查 | `docs` | Read+Write | [spec-kit-wiki](https://github.com/formin/spec-kit-wiki) |
| Loop Engineering | 为规范驱动开发构建安全的自主智能体循环：制作者/检查者分离、外置的循环状态，以及让你"始终当工程师"的护栏，对抗理解债务与认知弃权 | `process` | Read+Write | [spec-kit-loop](https://github.com/formin/spec-kit-loop) |
| MAQA — Multi-Agent & Quality Assurance | 协调者 → 功能 → QA 智能体的工作流，基于并行 worktree 实现。与语言无关。自动检测已安装的看板插件。可选 CI 关卡。 | `process` | Read+Write | [spec-kit-maqa-ext](https://github.com/GenieRobot/spec-kit-maqa-ext) |
| MAQA Azure DevOps Integration | MAQA 的 Azure DevOps Boards 集成——随功能推进同步 User Story 及其 Task 子项 | `integration` | Read+Write | [spec-kit-maqa-azure-devops](https://github.com/GenieRobot/spec-kit-maqa-azure-devops) |
| MAQA CI/CD Gate | 自动检测 GitHub Actions、CircleCI、GitLab CI 和 Bitbucket Pipelines。流水线全绿之前阻止移交 QA。 | `process` | Read+Write | [spec-kit-maqa-ci](https://github.com/GenieRobot/spec-kit-maqa-ci) |
| MAQA GitHub Projects Integration | MAQA 的 GitHub Projects v2 集成——随功能推进同步草稿 issue 和状态列 | `integration` | Read+Write | [spec-kit-maqa-github-projects](https://github.com/GenieRobot/spec-kit-maqa-github-projects) |
| MAQA Jira Integration | MAQA 的 Jira 集成——随功能在看板上推进，同步 Story 和 Subtask | `integration` | Read+Write | [spec-kit-maqa-jira](https://github.com/GenieRobot/spec-kit-maqa-jira) |
| MAQA Linear Integration | MAQA 的 Linear 集成——随功能推进，在各工作流状态之间同步 issue 和子 issue | `integration` | Read+Write | [spec-kit-maqa-linear](https://github.com/GenieRobot/spec-kit-maqa-linear) |
| MAQA Trello Integration | MAQA 的 Trello 看板集成——从规范填充看板、移动卡片、实时勾选检查清单 | `integration` | Read+Write | [spec-kit-maqa-trello](https://github.com/GenieRobot/spec-kit-maqa-trello) |
| MarkItDown Document Converter | 把文档（PDF、Word、PowerPoint、Excel 等）转换为 Markdown，用作规范参考材料 | `docs` | Read+Write | [spec-kit-markitdown](https://github.com/BenBtg/spec-kit-markitdown) |
| MDE | 极简的模型驱动工程工作流，提供 setup、next 和 status 命令 | `process` | Read+Write | [spec-kit-mde](https://github.com/AI-MDE/spec-kit-mde) |
| Memory Loader | 在生命周期命令之前加载 .specify/memory/ 文件，让 LLM 智能体具备项目治理上下文 | `docs` | Read-only | [spec-kit-memory-loader](https://github.com/KevinBrown5280/spec-kit-memory-loader) |
| Memory MD | 面向仓库原生 Markdown 记忆的 Spec Kit 扩展，沉淀持久的决策、bug 和项目上下文 | `docs` | Read+Write | [spec-kit-memory-hub](https://github.com/DyanGalih/spec-kit-memory-hub) |
| MemoryLint | 证据驱动的指令漂移检查器：审计智能体记忆文件的边界、现实、冲突和冗余漂移。 | `process` | Read+Write | [memorylint](https://github.com/RbBtSn0w/spec-kit-extensions/tree/main/memorylint) |
| Microsoft 365 Integration | 把 Teams 消息、会议转录和 SharePoint/OneDrive 文件抓取为本地 Markdown，用于生成规范 | `integration` | Read+Write | [spec-kit-m365](https://github.com/BenBtg/spec-kit-m365) |
| Multi-Model Review | 跨模型的 Spec Kit 交接，覆盖规范编写、实现路由和评审。 | `process` | Read+Write | [multi-model-review](https://github.com/formin/multi-model-review) |
| Multi-Repo Branch Sync | 通过 plan/tasks 钩子，在受影响的子仓库和 git 子模块中创建功能分支 | `process` | Read+Write | [multi-repo-sync](https://github.com/fyloss/spec-kit-multi-repo-sync) |
| Multi-Sites Spec Kit | 感知多站点的 specify 命令，支持按站点划分的规范文件夹、自动递增编号和 Drupal | `process` | Read+Write | [spec-kit-multi-sites](https://github.com/teeyo/spec-kit-multi-sites) |
| .NET Framework to Modern .NET Migration | 编排端到端的 .NET Framework 到现代 .NET 迁移，共 7 个阶段，并与规范驱动开发生命周期集成 | `process` | Read+Write | [spec-kit-fx-to-net](https://github.com/RogerBestMsft/spec-kit-FxToNet) |
| Onboard | 为 spec-kit 项目新人提供情境化入门与渐进式成长。讲解规范、梳理依赖、验证理解，并指引下一步 | `process` | Read+Write | [spec-kit-onboard](https://github.com/dmux/spec-kit-onboard) |
| Optimize | 审计并优化 AI 治理的上下文效率——token 预算、规则健康度、可解释性、压缩、连贯性和回声检测 | `process` | Read+Write | [spec-kit-optimize](https://github.com/sakitA/spec-kit-optimize) |
| Orchestration Task Context Management | 为生成的 Spec Kit 任务文件添加子智能体工作单元编排 | `process` | Read+Write | [spec-kit-orchestration-task-context-management](https://github.com/benizzio/spec-kit-orchestration-task-context-management) |
| OWASP LLM Threat Model | 基于 OWASP 2025 LLM 应用 Top 10，对智能体产物进行威胁分析 | `code` | Read-only | [spec-kit-threatmodel](https://github.com/NaviaSamal/spec-kit-threatmodel) |
| PatchWarden Evidence Pack | 把 Spec Kit 任务映射为受守护的 PatchWarden Goal，并为已接受的变更谱系导出有边界、可追溯的证据。 | `process` | Read+Write | [spec-kit-patchwarden](https://github.com/jiezeng2004-design/spec-kit-patchwarden) |
| Plan Review Gate | 要求 spec.md 和 plan.md 先通过 MR/PR 合并，才允许生成任务 | `process` | Read-only | [spec-kit-plan-review-gate](https://github.com/luno/spec-kit-plan-review-gate) |
| PR Bridge | 从规范产物自动生成 PR 描述、检查清单和摘要 | `process` | Read-only | [spec-kit-pr-bridge-](https://github.com/Quratulain-bilal/spec-kit-pr-bridge-) |
| Presetify | 创建并校验预设和预设目录源 | `process` | Read+Write | [presetify](https://github.com/mnriem/spec-kit-extensions/tree/main/presetify) |
| Product Forge | Spec Kit 的完整产品生命周期编排器：调研 → 产品规范 → 计划 → 任务 → 实现 → 验证 → 测试 → 发布就绪，提供 express/lite/standard/v-model 四种模式和人工介入关卡。 | `process` | Read+Write | [speckit-product-forge](https://github.com/VaiYav/speckit-product-forge) |
| Product Spec Extension | 从工程规范生成 PRFAQ、精益 PRD、干系人摘要和技术设计 | `docs` | Read+Write | [spec-kit-product](https://github.com/d0whc3r/spec-kit-product) |
| Project Health Check | 诊断 Spec Kit 项目，报告结构、智能体、功能、脚本、扩展和 git 各方面的健康问题 | `visibility` | Read-only | [spec-kit-doctor](https://github.com/KhawarHabibKhan/spec-kit-doctor) |
| Project Status | 显示当前规范驱动开发工作流的进度——进行中的功能、产物状态、任务完成度、工作流阶段和扩展摘要 | `visibility` | Read-only | [spec-kit-status](https://github.com/KhawarHabibKhan/spec-kit-status) |
| QA Testing Extension | 系统化的 QA 测试，通过浏览器驱动或 CLI 方式验证规范中的验收标准 | `code` | Read-only | [spec-kit-qa](https://github.com/arunt14/spec-kit-qa) |
| Quality Gates (Enforcement Layer) | 面向 Spec Kit 的确定性质量强制执行，覆盖智能体钩子、git 检查和 CI 流水线，用一个策略文件和一个验证入口在每个边界得到完全一致的结果。 | `process` | Read+Write | [spec-gates](https://github.com/schwichtgit/spec-gates) |
| RAG Azure Builder | 用于引导搭建并运维 Azure RAG 技术栈的 Spec Kit 扩展，附带引导式工作流。 | `process` | Read+Write | [spec-kit-extension-rag-azure-builder](https://github.com/Sertxito/spec-kit-extension-rag-azure-builder) |
| Ralph Loop | 使用 AI 智能体 CLI 的自主实现循环 | `code` | Read+Write | [spec-kit-ralph](https://github.com/Rubiss-Projects/spec-kit-ralph) |
| Reconcile Extension | 通过外科手术式更新功能产物来消解实现漂移。 | `docs` | Read+Write | [spec-kit-reconcile](https://github.com/stn1slv/spec-kit-reconcile) |
| Red Team | 在 /speckit.plan 之前对规范做对抗性评审——并行的多视角智能体揭示 clarify/analyze 在结构上无法发现的风险（提示词注入、完整性缺口、跨规范漂移、静默失败）。产出结构化的发现报告；不会自动修改规范。 | `docs` | Read+Write | [spec-kit-red-team](https://github.com/ashbrener/spec-kit-red-team) |
| Research Harness | 状态外置的研究框架：为规范驱动开发提供有预算约束的探索、证据整编和论断核验 | `process` | Read+Write | [spec-kit-harness](https://github.com/formin/spec-kit-harness) |
| Repository Governance | 从 Spec Kit 元数据生成项目治理投射文件 | `process` | Read+Write | [spec-kit-agent-governance](https://github.com/bigsmartben/spec-kit-agent-governance) |
| Repository Index | 为现有仓库生成概览、架构和模块层面的索引。 | `docs` | Read-only | [spec-kit-repoindex](https://github.com/liuyiyu/spec-kit-repoindex) |
| Reqnroll BDD | 为 Spec Kit 添加 Reqnroll BDD 规划、Gherkin 生成、可追溯性、安全的任务注入、交接和验证 | `process` | Read+Write | [spec-kit-reqnroll-bdd](https://github.com/LoogacyStudio/spec-kit-reqnroll-bdd) |
| Retro Extension | 冲刺回顾分析，附带指标、规范准确性评估和改进建议 | `process` | Read+Write | [spec-kit-retro](https://github.com/arunt14/spec-kit-retro) |
| Retrospective Extension | 实现后的回顾，包含规范遵循度评分、漂移分析，以及由人工把关的规范更新 | `docs` | Read+Write | [spec-kit-retrospective](https://github.com/emi-dm/spec-kit-retrospective) |
| Review Extension | 实现后的全面代码审查，由专门智能体分别负责代码质量、注释、测试、错误处理、类型设计和简化 | `code` | Read-only | [spec-kit-review](https://github.com/ismaelJimenez/spec-kit-review) |
| Ripple | 在实现后检测测试无法捕获的副作用——通过 9 个分析类别揭示隐藏的涟漪效应 | `code` | Read+Write | [spec-kit-ripple](https://github.com/chordpli/spec-kit-ripple) |
| SDD Utilities | 恢复被中断的工作流、校验项目健康度，并验证规范到任务的可追溯性 | `process` | Read+Write | [speckit-utils](https://github.com/mvanhorn/speckit-utils) |
| Security Review | 全项目的安全内建（secure-by-design）安全审计，外加暂存区、分支/PR、计划、任务、跟进和应用等多种审查 | `code` | Read+Write | [spec-kit-security-review](https://github.com/DyanGalih/spec-kit-security-review) |
| SFSpeckit | 企业级 Salesforce SDLC，18 个命令覆盖完整的规范驱动开发生命周期。 | `process` | Read+Write | [spec-kit-sf](https://github.com/ysumanth06/spec-kit-sf) |
| Ship Release Extension | 自动化发布流水线：发布前检查、分支同步、changelog 生成、CI 验证和 PR 创建 | `process` | Read+Write | [spec-kit-ship](https://github.com/arunt14/spec-kit-ship) |
| Spec Changelog | 从规范的 git 历史和需求差异自动生成 changelog 和 release 说明 | `docs` | Read-only | [spec-kit-changelog](https://github.com/Quratulain-bilal/spec-kit-changelog) |
| Spec Critique Extension | 从产品策略和工程风险双重视角，对规范和计划进行批判性评审 | `docs` | Read-only | [spec-kit-critique](https://github.com/arunt14/spec-kit-critique) |
| Spec Diagram | 自动生成规范驱动开发工作流状态、功能进度和任务依赖的 Mermaid 图 | `visibility` | Read-only | [spec-kit-diagram-](https://github.com/Quratulain-bilal/spec-kit-diagram-) |
| Spec Kit Discovery Extension | 运行技术探索命令，覆盖可行性、技术选型、特定场景的技术决策、遗留代码库评估、实现理解和概念验证 | `process` | Read+Write | [spec-kit-discovery](https://github.com/bigsmartben/spec-kit-discovery) |
| Spec Kit Figma | 与智能体无关的 SpecKit 扩展，让规范、计划和任务的生成扎根于 Figma 设计上下文——REST + 可选 MCP，支持单仓/monorepo/多仓，macOS/Linux/Windows。 | `integration` | Read+Write | [spec-kit-figma](https://github.com/Fyloss/spec-kit-figma) |
| Spec Kit Memory | 在 SDLC 各阶段之前，从可配置的记忆工具（如 memsearch）中召回既往规范和决策，让规划和规范编写从项目已有的知识出发 | `docs` | Read+Write | [spec-kit-memory](https://github.com/zaytsevand/spec-kit-memory) |
| Spec Kit Preview | 从 Spec Kit 产物生成有证据支撑的低、中、高保真预览，输出为 Markdown 或自包含 HTML | `docs` | Read+Write | [spec-kit-preview](https://github.com/bigsmartben/spec-kit-preview) |
| Spec Kit Schedule | 通过 CP-SAT 求解最优的多智能体任务调度——DAG 先后依赖、感知幻觉的上限、文件冲突规避、随机工期、重新规划和交互式 HTML 输出 | `process` | Read+Write | [spec-kit-schedule](https://github.com/jfranc38/spec-kit-schedule) |
| Spec Kit TLDR | 把功能的 spec.md / plan.md 渲染成面向评审的 TLDR（自包含 HTML 仪表盘 + PR 原生 Markdown），突出风险，加快 PR 评审。 | `visibility` | Read+Write | [speckit-tldr](https://github.com/qurore/speckit-tldr) |
| Spec Orchestrator | 跨功能编排——在并行规范之间跟踪状态、挑选任务并检测冲突 | `process` | Read-only | [spec-kit-orchestrator](https://github.com/Quratulain-bilal/spec-kit-orchestrator) |
| Spec Reference Loader | 读取功能规范中的 ## References 小节，只把列出的文档加载进上下文 | `docs` | Read-only | [spec-kit-spec-reference-loader](https://github.com/KevinBrown5280/spec-kit-spec-reference-loader) |
| Spec Refine | 原地更新规范，把变更传播到计划和任务，并对比各产物受到的影响 | `process` | Read+Write | [spec-kit-refine](https://github.com/Quratulain-bilal/spec-kit-refine) |
| Spec Roadmap | 在宪章之后沉淀一份持久的规范路线图，并在实现前后对照它评审规范，确保规范层面的决策、结果和约束永不丢失。 | `process` | Read+Write | [speckit-roadmap](https://github.com/srobroek/speckit-roadmap) |
| Spec Scope | 工作量估算与范围跟踪——估算工作、检测范围蔓延，并为每个阶段编制时间预算 | `process` | Read-only | [spec-kit-scope-](https://github.com/Quratulain-bilal/spec-kit-scope-) |
| Spec Sync | 检测并解决规范与实现之间的漂移。AI 辅助解决，人工批准 | `docs` | Read+Write | [spec-kit-sync](https://github.com/bgervin/spec-kit-sync) |
| Spec Trace | 从 spec.md 和测试套件构建"需求 → 测试"可追溯性矩阵——揭示未被测试覆盖的需求和孤儿测试 | `code` | Read+Write | [spec-kit-trace](https://github.com/Quratulain-bilal/spec-kit-trace) |
| Spec Validate | 面向 spec-kit 产物的理解验证、评审关卡和批准状态——分阶段小测、同行评审 SLA，以及 /speckit.implement 之前的硬性关卡 | `process` | Read+Write | [spec-kit-spec-validate](https://github.com/aeltayeb/spec-kit-spec-validate) |
| Spec-Kit BDD | ATDD/BDD 扩展：把规范转换为 Gherkin 场景、生成步骤定义脚手架，并验证验收测试覆盖率 | `process` | Read+Write | [spec-kit-bdd](https://github.com/RSginer/spec-kit-bdd) |
| Spec2Cloud | 为交付到 Azure 调优的规范驱动工作流 | `process` | Read+Write | [spec2cloud](https://github.com/Azure-Samples/Spec2Cloud) |
| SpecKit Companion | 实时的规范驱动进度——生命周期捕获、状态查看、续跑，以及一个 turbo 流水线配置 | `visibility` | Read+Write | [speckit-companion](https://github.com/alfredoperez/speckit-companion) |
| SpecTest | 从规范标准自动生成测试脚手架、映射覆盖率，并找出未被测试的需求 | `code` | Read+Write | [spec-kit-spectest](https://github.com/Quratulain-bilal/spec-kit-spectest) |
| Squad Bridge | 从你的 Speckit 规范和任务引导并同步一支 Squad 智能体团队。 | `process` | Read+Write | [spec-kit-squad](https://github.com/jwill824/spec-kit-squad) |
| Staff Review Extension | Staff 工程师级别的代码审查：对照规范校验实现，并检查安全、性能和测试覆盖率 | `code` | Read-only | [spec-kit-staff-review](https://github.com/arunt14/spec-kit-staff-review) |
| Status Report | 面向规范驱动工作流的项目状态、功能进度和下一步行动建议 | `visibility` | Read-only | [Open-Agent-Tools/spec-kit-status](https://github.com/Open-Agent-Tools/spec-kit-status) |
| Superpowers Bridge | 把精选的 Superpowers 纪律桥接进 Spec Kit，作为智能体工作流中证据优先的信任关卡。 | `process` | Read+Write | [superpowers-bridge](https://github.com/RbBtSn0w/spec-kit-extensions/tree/main/superpowers-bridge) |
| Superpowers Implementation Bridge | Spec Kit（设计）与 Superpowers（实现）之间的轻量编排器。跨智能体。 | `process` | Read+Write | [speckit-superpowers-bridge](https://github.com/lihan3238/speckit-superpowers-bridge) |
| Superspec | 把 spec-kit 与 obra/superpowers（头脑风暴、TDD、子智能体、代码审查）桥接成统一、可续跑的工作流，支持优雅降级和会话进度跟踪 | `process` | Read+Write | [superspec](https://github.com/WangX0111/superspec) |
| Tasks to GitHub Project | 把 Spec Kit 任务发布并同步为 GitHub Project（v2）看板上的卡片，在 spec.md/tasks.md 与看板之间同步优先级和状态。 | `integration` | Read+Write | [spec-kit-tasks-to-project](https://github.com/mancioshell/spec-kit-tasks-to-project) |
| Team Assign | 把 tasks.md 中的条目指派给人类工程师、拆分为子任务，并为每位工程师生成工作板 | `process` | Read+Write | [spec-kit-team-assign](https://github.com/tarunkumarbhati/spec-kit-team-assign) |
| Time Machine | 把完整的规范驱动开发工作流追溯性地应用到现有代码库——逐功能地分析、写规范、交付 | `process` | Read+Write | [spec-kit-time-machine](https://github.com/teeyo/spec-kit-time-machine) |
| TinySpec | 面向小任务的轻量单文件工作流——跳过厚重的多步规范驱动开发流程 | `process` | Read+Write | [spec-kit-tinyspec](https://github.com/Quratulain-bilal/spec-kit-tinyspec) |
| Token Budget | 降低 Spec Kit 工作流中的 LLM token 消耗：原地压缩产物、按阶段限定阅读范围、抑制冗余行文，并报告 token 用量 | `process` | Read+Write | [spec-kit-token-budget](https://github.com/tinesoft/spec-kit-token-budget) |
| Token Consumption Analyzer | 捕获、分析并对比各规范驱动开发工作流的 token 消耗 | `visibility` | Read-only | [spec-kit-token-analyzer](https://github.com/coderandhiker/spec-kit-token-analyzer) |
| Token Economy | token 路由、可度量的节省和上下文审计工作流 | `process` | Read+Write | [spec-kit-token-economy](https://github.com/formin/spec-kit-token-economy) |
| V-Model Extension Pack | 强制以 V 模型方式成对生成开发规范与测试规范，并保持完整的可追溯性 | `docs` | Read+Write | [spec-kit-v-model](https://github.com/leocamello/spec-kit-v-model) |
| Verify Extension | 实现后的质量关卡，对照规范产物校验已实现的代码 | `code` | Read-only | [spec-kit-verify](https://github.com/ismaelJimenez/spec-kit-verify) |
| Verify Review Ship | 为 Spec Kit 工作流添加实现后的验证、评审和交付就绪关卡 | `process` | Read-only | [spec-kit-verify-review-ship](https://github.com/cadugevaerd/spec-kit-verify-review-ship) |
| Verify Tasks Extension | 检测幽灵完成：tasks.md 中标记为 [X] 却没有真实实现的任务 | `code` | Read-only | [spec-kit-verify-tasks](https://github.com/datastone-inc/spec-kit-verify-tasks) |
| Version Guard | 在规划和实现之前，对照线上 npm 注册表核验技术栈版本 | `process` | Read-only | [spec-kit-version-guard](https://github.com/KevinBrown5280/spec-kit-version-guard) |
| What-if Analysis | 在敲定需求变更之前，预览其下游影响（复杂度、工作量、任务、风险） | `visibility` | Read-only | [spec-kit-whatif](https://github.com/DevAbdullah90/spec-kit-whatif) |
| Wireframe Visual Feedback Loop | 面向规范驱动开发的 SVG 线框图生成、评审与签核。通过审批的线框图会成为 /speckit.plan、/speckit.tasks 和 /speckit.implement 都会遵守的规范约束 | `visibility` | Read+Write | [spec-kit-extension-wireframe](https://github.com/TortoiseWolfe/spec-kit-extension-wireframe) |
| Work IQ | 把 Microsoft 365 组织知识集成进规范驱动开发工作流 | `integration` | Read-only | [spec-kit-workiq](https://github.com/sakitA/spec-kit-workiq) |
| Worktree Isolation | 为并行功能开发派生隔离的 git worktree，无需来回切换 checkout | `process` | Read+Write | [spec-kit-worktree](https://github.com/Quratulain-bilal/spec-kit-worktree) |
| Worktrees | 为并行智能体提供默认开启的 worktree 隔离——同级或嵌套布局 | `process` | Read+Write | [spec-kit-worktree-parallel](https://github.com/dango85/spec-kit-worktree-parallel) |

要提交你自己的扩展，参见[扩展发布指南](https://github.com/github/spec-kit/blob/main/extensions/EXTENSION-PUBLISHING-GUIDE.md)。
