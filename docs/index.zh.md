<!-- zh-source: docs/index.md -->
<!-- zh-base: 7bdf6c5 -->

<div class="landing-hero">

# GitHub Spec Kit

**规范驱动开发，或你自己的流程——逐步推进，或作为自动化工作流运行。**

Spec Kit 是一个可扩展的、意图驱动的框架，它推动任意编码智能体超越代码本身，引导它贯穿你的软件开发生命周期（SDLC）或任何业务流程。你可以用它来做[规范驱动开发](concepts/sdd.md)（SDD）：描述要构建*什么*，并通过结构化的阶段逐步精炼。逐步运行它、端到端地自动化它，或者塑造一套你自己的流程——始终把意图放在中心。

<a href="installation.md" class="btn btn-primary btn-lg">安装 Spec Kit</a>&nbsp;
<a href="quickstart.md" class="btn btn-outline-primary btn-lg">快速上手</a>

</div>

---

<div class="pillar-grid">

<div class="pillar-card">

### 默认规范驱动

核心 SDD 流程开箱即用：**规范 → 计划 → 任务 → 实现**。

在动手构建之前先定义要构建什么。丰富的模板、质量检查清单和跨产物分析全部开箱即备。每个阶段都产出一份 Markdown 产物并输入下一阶段——给你的 AI 编码智能体的是结构化上下文，而不是零散的临时提示词。

<a href="quickstart.md" class="pillar-link">完整走一遍工作流 →</a>

</div>

<div class="pillar-card">

### 任意编码智能体皆可用

<span class="pillar-stat">35 个集成</span>——Copilot、Gemini、Codex、Kilo Code、Zed、Claude、Forge、Kiro 等等。一条命令即可在智能体之间自由切换，没有锁定。

用你选择的智能体运行 `specify init`，Spec Kit 会自动配置好对应的命令文件和目录结构。如果你的智能体不在列表里，`generic` 集成是适配任意工具的兜底方案。

<a href="reference/integrations.md" class="pillar-link">查看所有集成 →</a>

</div>

<div class="pillar-card">

### 把它变成你自己的

<span class="pillar-stat">138 个社区扩展</span>（70+ 位作者）、<span class="pillar-stat">25 个预设</span>，并且还在增长。用预设调校核心流程，用扩展增强能力，用工作流编排它，把这一切打包成可以分享的套装——或者干脆整体替换整个流程。流程本身就寓于这些构建块之中，所以你永远不会被锁定在 SDD 上，甚至不局限于软件。

其中甚至包括完全不同的流程：

- **AIDE**——7 步 AI 驱动的工程生命周期
- **Canon**——基线驱动的工作流（规范优先、代码优先、规范漂移）
- **Product Forge**——面向产品管理的 SDD
- **FX→.NET**——横跨 7 个阶段的端到端 .NET Framework 迁移
- **MAQA**——带质量保证关卡的多智能体编排
- **Fiction Book Writing**——小说与长篇虚构创作，从故事设定集到投稿

<a href="reference/presets.md" class="pillar-link">预设 →</a>&nbsp;&nbsp;
<a href="reference/extensions.md" class="pillar-link">扩展 →</a>&nbsp;&nbsp;
<a href="reference/workflows.md" class="pillar-link">工作流 →</a>&nbsp;&nbsp;
<a href="reference/bundles.md" class="pillar-link">套装 →</a>

</div>

<div class="pillar-card">

### 融入你的组织

支持离线使用、防火墙内运行，覆盖 **Windows、macOS 和 Linux**。可以自建目录源，策展你的组织能发现和推荐哪些集成、扩展、预设、工作流和套装。

CI Guard、Architecture Guard 等社区扩展提供合规关卡和治理能力，贴合你团队现有的工作方式。

<a href="install/air-gapped.md" class="pillar-link">企业版 / 离线隔离（air-gapped） →</a>&nbsp;&nbsp;
<a href="reference/overview.md" class="pillar-link">参考 →</a>

</div>

</div>

---

<div class="community-section">

## 由社区共建

**240+ 位贡献者**支撑着 Spec Kit 生态——从核心集成到全新的流程。任何人都可以创建并发布扩展、预设或工作流。

<div class="stats-grid">
  <div class="stat-item">
    <span class="stat-number">121K+</span>
    <span class="stat-label">GitHub star</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">240+</span>
    <span class="stat-label">贡献者</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">35</span>
    <span class="stat-label">集成</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">138</span>
    <span class="stat-label">扩展</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">25</span>
    <span class="stat-label">预设</span>
  </div>
  <div class="stat-item">
    <span class="stat-number">6</span>
    <span class="stat-label">友邻项目</span>
  </div>
</div>

<a href="community/presets.md">预设</a> · <a href="community/walkthroughs.md">实战演练</a> · <a href="community/friends.md">友邻项目</a>

</div>

---

## 浏览文档

<div class="nav-cards">
  <a href="quickstart.md" class="nav-card">
    <strong>快速入门</strong>
    <span>安装、配置并跑通你的第一个 SDD 工作流</span>
  </a>
  <a href="reference/overview.md" class="nav-card">
    <strong>参考</strong>
    <span>核心命令、集成、扩展、预设与工作流</span>
  </a>
  <a href="community/overview.md" class="nav-card">
    <strong>社区</strong>
    <span>扩展、预设、实战演练与友邻项目</span>
  </a>
  <a href="local-development.md" class="nav-card">
    <strong>开发</strong>
    <span>参与 Spec Kit 贡献</span>
  </a>
  <a href="concepts/sdd.md" class="nav-card">
    <strong>什么是 SDD？</strong>
    <span>规范驱动开发背后的理念</span>
  </a>
</div>

---

<div class="footer-cta">

```bash
uv tool install specify-cli
specify init my-project --integration copilot
```

准备好开始了吗？跟随[快速上手指南](quickstart.md)。

</div>

<p class="text-end small text-body-secondary">最后更新：2026 年 7 月 16 日</p>
