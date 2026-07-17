---
description: "应用 bug 评估中的整改方案并记录改动内容"
---

<!-- zh-source: extensions/bug/commands/speckit.bug.fix.md -->
<!-- zh-base: 60302fe -->

# 修复 Bug

应用 `__SPECKIT_COMMAND_BUG_ASSESS__` 提出的整改方案，并把改动记录在 `.specify/bugs/<slug>/fix.md` 的修复报告中。本命令**仅**在给定 slug 已存在评估时才有效。

## 用户输入

```text
$ARGUMENTS
```

用户输入应指明要修复哪个 bug。接受以下任意形式：

- `slug=<bug-slug>`、`--slug <bug-slug>`，或就是一个像 slug 的词元。
- 包含 slug 的路径（例如 `.specify/bugs/login-timeout/`）。
- **空**——回退到上下文（见下文）。

## Slug 解析

按以下顺序解析 `BUG_SLUG`，命中即止：

1. **显式用户输入**——`$ARGUMENTS` 中传入的 slug（上述任意形式）。
2. **会话上下文**——如果当前会话刚运行过 `__SPECKIT_COMMAND_BUG_ASSESS__`，它汇报的 slug 就是工作 slug。直接复用，无需再次询问。通过检查 `.specify/bugs/<slug>/assessment.md` 是否存在来确认；如果不存在，继续往下走。
3. **磁盘上唯一候选**——列出 `.specify/bugs/*/assessment.md`。如果恰好只找到一个匹配的 `assessment.md`，使用其父目录名作为 slug。
4. **消除歧义**：
   - **交互模式**：询问用户要修复哪个 bug，并列出候选项。
   - **自动化模式**：报错停止，并列出候选项。不要猜。

解析完成后，设置 `BUG_SLUG` 和 `BUG_DIR = .specify/bugs/<BUG_SLUG>`，并在回复中简要说明使用了哪条解析路径（显式/来自上下文/唯一候选/询问所得）。

## 前置条件

- `BUG_DIR/assessment.md` 必须存在。如果不存在，停止并告知用户先运行 `__SPECKIT_COMMAND_BUG_ASSESS__`。
- 如果 `BUG_DIR/fix.md` 已存在，（交互模式下）先询问用户是否覆盖再继续，（自动化模式下）拒绝。
- 完整阅读 `BUG_DIR/assessment.md`。把其中的**整改方案**、**可能要改的文件**、**要新增或更新的测试**和**风险与注意事项**小节视为本命令的契约。

## 执行

1. **确认计划**
   - 根据评估，用 3–6 个要点复述你将要改什么、在哪里改。
   - 如果评估的判定是 `invalid`，停止——没有什么可修的。告知用户并退出。
   - 如果判定是 `likely valid, needs reproduction` 且存在未解决的 `[NEEDS CLARIFICATION]` 项，把它们标出来：交互模式下询问用户是否继续，自动化模式下停止。

2. **应用整改方案**
   - 按首选整改方案描述的内容修改代码。只改动评估列出的文件，除非新发现的证据要求扩大范围（此时在报告中显式记录这次扩大）。
   - 新增或更新评估中点名的测试，使这个 bug 无法悄悄回归。
   - 保持改动最小——不要重构无关代码，不要引入评估没有要求的依赖。
   - 如果你发现评估是错的（提出的修复不奏效、根因在别处），立即停止修改代码，把新发现记录在修复报告的**与评估的偏差**小节，并建议重新运行 `__SPECKIT_COMMAND_BUG_ASSESS__`。

3. **运行本地检查**
   - 如果项目有明显的测试命令（例如 `pytest`、`npm test`、`cargo test`），运行覆盖改动路径的测试。记录通过/失败和关键输出。
   - 未经用户同意，不要运行破坏性的或依赖网络的测试套件。

4. **写修复报告**

   使用以下结构写入 `BUG_DIR/fix.md`：

   ```markdown
   # Bug 修复：<短标题>

   - **Slug**：<BUG_SLUG>
   - **修复时间**：<ISO 8601 日期>
   - **评估**：./assessment.md
   - **状态**：applied | partial | not-applied

   ## 摘要

   <一两句话描述改了什么、为什么。>

   ## 改动

   | 文件 | 改动 | 备注 |
   |------|--------|-------|
   | `path/to/file.py` | <新增/修改/删除> | <简短备注> |
   | `path/to/test_file.py` | 新增测试 | <简短备注> |

   ## 差异要点（可选）

   <最重要改动块的简短示意片段——不是完整的 diff 转储。>

   ## 新增或更新的测试

   - `path/to/test_file.py::test_name`——<它锁定了什么>

   ## 本地验证

   - 运行的命令：`<command>` → <结果，简短>
   - 手动检查：<手工验证了什么（如有）>

   ## 与评估的偏差

   <没有则留空。否则，列出实际修复与提出的整改方案不一致的地方及原因。>

   ## 后续事项

   - <建议的清理、监控、文档更新等>
   ```

5. **汇报结果**，包含：
   - slug 和 `BUG_DIR/fix.md` 路径。
   - 状态（`applied`、`partial`、`not-applied`）。
   - 建议的下一步：`__SPECKIT_COMMAND_BUG_TEST__ slug=<BUG_SLUG>`。

## 护栏

- 绝不修改项目工作区之外的文件。
- 绝不编辑 `assessment.md`——它是你工作所依据的契约。有分歧就记录在 `fix.md` 的**与评估的偏差**小节。
- 除非评估明确要求，绝不删除文件。
- 绝不在未经确认的情况下覆盖已有的 `fix.md`。
