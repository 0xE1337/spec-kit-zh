<!-- zh-source: extensions/bug/README.md -->
<!-- zh-base: 60302fe -->

# Bug 分诊工作流扩展

为 Spec Kit 提供的三步 bug 分诊（triage）工作流：评估、修复、验证。每个 bug 都有自己的目录，位于 `.specify/bugs/<slug>/` 下，每个阶段各产出一份 Markdown 报告。

## 概览

本扩展提供一套有明确主张、可重复执行的 bug 工作流，任何 AI 编码智能体都能驱动它：

1. **评估（Assess）**——阅读 bug 报告（粘贴的文本或 URL），判断它是否是真实的 bug，定位疑似代码路径，并提出整改方案。
2. **修复（Fix）**——应用提出的整改方案，并准确记录改了什么。
3. **测试（Test）**——重新执行复现步骤和新增的测试，然后记录验证结果。

三个阶段通过单个 bug 目录下的三份 Markdown 文件进行沟通：

```
.specify/bugs/<slug>/
├── assessment.md   # 由 speckit.bug.assess 写入
├── fix.md          # 由 speckit.bug.fix 写入
└── test.md         # 由 speckit.bug.test 写入
```

## 命令

| 命令 | 说明 | 输出 |
|---------|-------------|--------|
| `speckit.bug.assess` | 对照代码库分诊 bug 报告（粘贴的文本或 URL）。 | `.specify/bugs/<slug>/assessment.md` |
| `speckit.bug.fix` | 应用评估中提出的整改方案。 | `.specify/bugs/<slug>/fix.md` |
| `speckit.bug.test` | 验证修复并记录验证报告。 | `.specify/bugs/<slug>/test.md` |

## Slug 约定

*slug*（短标识名）是 `.specify/bugs/` 下的单个 bug 目录名。它是三个命令共享的唯一句柄。

- **用户提供**：用户想要什么形式都可以，规范化为小写 kebab-case（例如 `login-timeout`、`cve-2026-001`、`oauth-redirect-500`）。slug 在规范化之后按原样保留——不会自动追加时间戳或编号。
- **主动询问**：交互式使用时，若未提供 slug，`speckit.bug.assess` 会向用户询问，并根据 bug 摘要给出一个 kebab-case 的默认建议。
- **自动化场景**：没有人来回答时，智能体自行生成 slug。生成的 slug **必须**产生唯一目录——如果 `.specify/bugs/<slug>/` 已存在，智能体会追加所需的最短去重后缀（`-2`、`-3`、……）或短日期（`-20260605`）。已有的 bug 目录绝不会被覆盖。

## 安装

```bash
# 安装内置的 bug 扩展（无需联网）
specify extension add bug
```

## 停用

```bash
# 停用 bug 扩展
specify extension disable bug

# 重新启用
specify extension enable bug
```

## 典型流程

```bash
# 1. 从粘贴的堆栈跟踪分诊一个 bug
/speckit.bug.assess "TypeError: cannot read properties of undefined (reading 'token') at /auth/callback"

# 2. 从 GitHub issue URL 分诊一个 bug
/speckit.bug.assess https://github.com/example/repo/issues/1234 slug=callback-token

# 3. 应用提出的修复
/speckit.bug.fix slug=callback-token

# 4. 验证修复
/speckit.bug.test slug=callback-token
```

## 护栏

- `speckit.bug.assess` 和 `speckit.bug.test` **绝不修改源代码**。它们只读取仓库，并且只在 `.specify/bugs/<slug>/` 内写入。
- `speckit.bug.fix` 是唯一会编辑源代码的命令，并且只改动评估中列出的文件，除非新证据要求扩大范围（这种情况会记录在 `fix.md` 的**与评估的偏差**（Deviations from Assessment）小节中）。
- 任何命令都不会在没有明确确认的情况下覆盖已有的报告文件；在自动化模式下，它们会拒绝覆盖并改选一个新的唯一 slug。
- 判定和验证结果绝不夸大：没有实际执行过的复现会被报告为 `partial` 或 `not-run`，而不是 `verified`。

## 钩子

本扩展不注册任何钩子。三个命令始终由用户显式调用。
