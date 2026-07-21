<!-- zh-source: docs/reference/agentic-bugfix.md -->
<!-- zh-base: 396fc2c -->

# 智能体化缺陷修复（Agentic Bug Fix）

**bug** 扩展增加了一个三步的缺陷分诊（triage）流程——评估、修复和验证——由你的编码智能体与核心的[智能体化规范驱动开发](agentic-sdd.md)流程并行运行。每个缺陷都存放在 `.specify/bugs/<slug>/` 下各自的目录中，每个阶段一份 Markdown 报告。

> [!NOTE]
> 本页通篇以 `/speckit.bug.*` 形式书写命令。确切的调用方式取决于你的智能体——一些基于技能的智能体使用 `$speckit-bug-*`（如 Codex、ZCode）或 `/skill:speckit-bug-*`（如 Kimi）。请替换为你的智能体所暴露的形式。

bug 扩展是一个随 Spec Kit 内置、按需启用（opt-in）的扩展。使用这些命令之前先安装它：

```bash
specify extension add bug
```

这三个命令共享同一个句柄——**slug**（短标识名），即 `.specify/bugs/` 下每个缺陷的目录名。用 `slug=<name>` 提供它；如果省略，`/speckit.bug.assess` 会要一个（或在自动化模式下生成一个唯一的）。slug 会被统一规范为小写 kebab-case。如果某个 slug 已经存在评估，交互式运行会在覆盖它之前询问，而自动化运行会拒绝并转而挑选一个新的唯一 slug。

```text
/speckit.bug.assess -> /speckit.bug.fix -> /speckit.bug.test
```

## `/speckit.bug.assess`

对照代码库对一份缺陷报告——粘贴的文本（如堆栈跟踪）或一个 URL（如 GitHub issue）——进行分诊：它判断该报告是否是真正的缺陷，定位可疑的代码路径，并提出整改方案。该命令是**只读**的：它只写入 `assessment.md`，从不修改源代码。

```text
/speckit.bug.assess "TypeError: cannot read properties of undefined (reading 'token') at /auth/callback"
```

```text
/speckit.bug.assess https://github.com/example/repo/issues/1234 slug=callback-token
```

输出：`.specify/bugs/<slug>/assessment.md`。

## `/speckit.bug.fix`

应用评估中描述的整改，并准确记录改动了什么。这是**唯一**会编辑源代码的 bug 命令，它只在评估列出的文件范围内操作，除非有新证据需要扩大范围（记录在 **Deviations from Assessment**（偏离评估）小节下）。

```text
/speckit.bug.fix slug=callback-token
```

输出：`.specify/bugs/<slug>/fix.md`。

## `/speckit.bug.test`

通过重新运行复现步骤和任何新增的测试来验证修复，然后记录验证结果——`verified`、`partial` 或 `failed` 之一。和 `assess` 一样，它对源代码而言是**只读**的。判定绝不夸大：如果评估列出的某个复现实际上没有被执行，整体结果会被降级为 `partial`，而不是报告为 `verified`。

```text
/speckit.bug.test slug=callback-token
```

输出：`.specify/bugs/<slug>/test.md`。
