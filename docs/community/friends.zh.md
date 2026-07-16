<!-- zh-source: docs/community/friends.md -->
<!-- zh-base: 3f7392a -->

# 社区友邻项目

> [!NOTE]
> 此处列出的社区项目由各自的作者独立创建和维护。它们**未经 GitHub 审查、背书或支持**。安装前请审查源码，使用风险自行判断。

扩展、可视化或构建于 Spec Kit 之上的社区项目：

- **[cc-spex](https://github.com/rhuss/cc-spex)**——一个 Claude Code 插件，在 Spec Kit 之上添加可组合的特性（traits），提供基于 [Superpowers](https://github.com/obra/superpowers) 的质量关卡、规范/代码评审、git worktree 隔离，以及通过智能体团队进行的并行实现。

- **[VS Code Spec Kit Assistant](https://marketplace.visualstudio.com/items?itemName=rfsales.speckit-assistant)**——一个 VS Code 扩展，为完整的 SDD 工作流（宪章 → 规范 → 规划 → 任务 → 实现）提供可视化编排器，包含阶段状态可视化、交互式任务检查清单、DAG 可视化，并支持 Claude、Gemini、GitHub Copilot 和 OpenAI 后端。需要 PATH 中有 `specify` CLI。

- **[SpecKit Assistant](https://www.npmjs.com/package/speckit-assistant)**——一个规范驱动开发（SDD）的可视化编排器。它把你本地的规范、规划和任务检查清单与 AI 智能体（Claude、Gemini、GitHub Copilot）连接起来。无需全局安装——直接通过 `npx speckit-assistant` 运行即可。

- **[SpecKit Companion](https://marketplace.visualstudio.com/items?itemName=alfredoperez.speckit-companion)**——一个为 Spec Kit 带来可视化 GUI 的 VS Code 扩展。在富 Markdown 查看器中浏览规范（文件引用可点击）、创建带图片附件的规范、对每一步进行内联评论与打磨（GitHub 风格的评审）、通过可视化阶段步进器跟踪 SDD 工作流进度，并管理宪章、模板等指导文档。

- **[cc-spec-kit](https://github.com/speckit-community/cc-spec-kit)**——由社区维护的 Claude Code 与 GitHub Copilot CLI 插件，通过插件市场安装 Spec Kit 技能。

- **[spectatui](https://github.com/tinesoft/spectatui)**——一个 Spec Kit 的终端 UI（TUI）仪表盘，可以跟踪功能，管理规范、集成、预设、工作流和扩展，并监控 AI 智能体工作流。可以接入既有 AI 会话，也可以从终端启动新会话。支持键盘和鼠标操作，支持浅色/深色主题，可定制且注重性能。需要 PATH 中有 `specify` CLI。
