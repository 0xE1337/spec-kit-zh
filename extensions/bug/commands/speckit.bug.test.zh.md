---
description: "验证先前修复的 bug 已解决，并记录验证报告"
---

<!-- zh-source: extensions/bug/commands/speckit.bug.test.md -->
<!-- zh-base: 60302fe -->

# 测试 Bug 修复

验证 `__SPECKIT_COMMAND_BUG_FIX__` 记录的修复确实解决了 `__SPECKIT_COMMAND_BUG_ASSESS__` 所描述的 bug。输出是位于 `.specify/bugs/<slug>/test.md` 的验证报告。

## 用户输入

```text
$ARGUMENTS
```

用户输入应指明要验证哪个 bug。接受以下任意形式：

- `slug=<bug-slug>`、`--slug <bug-slug>`，或一个像 slug 的词元。
- 包含 slug 的路径（例如 `.specify/bugs/login-timeout/`）。
- **空**——回退到上下文（见下文）。

## Slug 解析

按以下顺序解析 `BUG_SLUG`，命中即止：

1. **显式用户输入**——`$ARGUMENTS` 中传入的 slug（上述任意形式）。
2. **会话上下文**——如果当前会话刚运行过 `__SPECKIT_COMMAND_BUG_ASSESS__` 或 `__SPECKIT_COMMAND_BUG_FIX__`，它汇报的 slug 就是工作 slug。直接复用，无需再次询问。通过检查 `.specify/bugs/<slug>/fix.md` 是否存在来确认；如果不存在，继续往下走。
3. **磁盘上唯一候选**——列出 `.specify/bugs/*/fix.md`。如果恰好只有一个 bug 有 `fix.md`，就用它。
4. **消除歧义**：
   - **交互模式**：询问用户要验证哪个 bug，并列出候选项。
   - **自动化模式**：报错停止，并列出候选项。不要猜。

解析完成后，设置 `BUG_SLUG` 和 `BUG_DIR = .specify/bugs/<BUG_SLUG>`，并在回复中简要说明使用了哪条解析路径（显式/来自上下文/唯一候选/询问所得）。

## 前置条件

- `BUG_DIR/assessment.md` 必须存在。
- `BUG_DIR/fix.md` 必须存在。如果不存在，停止并告知用户先运行 `__SPECKIT_COMMAND_BUG_FIX__`。
- 如果 `BUG_DIR/test.md` 已存在，（交互模式下）询问用户是否覆盖，（自动化模式下）拒绝。
- 完整阅读 `assessment.md` 和 `fix.md`，以便掌握：
  - 原始症状和复现步骤（来自 `assessment.md`）。
  - 实际的代码改动和新增的测试（来自 `fix.md`）。

## 执行

1. **规划验证**
   - 决定哪些检查能证明 bug 已消失：
     - 重新执行评估中的复现步骤（或其自动化等价物）。
     - 运行修复中新增或更新的测试。
     - 运行触及改动文件的更大范围回归套件。
   - 决定哪些检查能证明没有破坏其他东西：
     - 改动模块的现有测试套件。
     - 如果项目使用 lint/类型检查，也运行它们。

2. **运行检查**
   - 执行每项计划中的检查。记录命令、退出状态和相关输出的简短摘录（最后几行，或失败的断言）。
   - 如果某项检查是破坏性的、依赖网络的或代价高昂的，跳过它并记录为 `skipped` 并附原因；未经用户明确同意不要运行。
   - 如果某项检查完全无法运行（缺少工具、未配置测试框架），记录为 `not-run` 并附原因，而不是捏造结果。

3. **判断结果**
   - 把修复标记为：
     - **verified（已验证）**——所有关键检查通过，且原始症状不再复现。
     - **partial（部分验证）**——原始症状消失，但出现了无关的回归，或某些检查结论不明。
     - **failed（失败）**——症状仍然复现，或修复破坏了回归套件。
   - 不要夸大。如果实际上没有执行复现（例如该 bug 需要生产环境），要明确说出来。

4. **写验证报告**

   使用以下结构写入 `BUG_DIR/test.md`：

   ```markdown
   # Bug 验证：<短标题>

   - **Slug**：<BUG_SLUG>
   - **测试时间**：<ISO 8601 日期>
   - **评估**：./assessment.md
   - **修复**：./fix.md
   - **结果**：verified | partial | failed

   ## 摘要

   <一两句话：bug 是否还复现，修复是否稳住了，是否发现回归。>

   ## 已执行的检查

   | 检查 | 命令/操作 | 结果 | 备注 |
   |-------|------------------|--------|-------|
   | 复现（修复后） | <命令或手动步骤> | pass / fail / skipped / not-run | <简短备注> |
   | 新增/更新的测试 | `<command>` | pass / fail | <简短备注> |
   | 回归套件 | `<command>` | pass / fail / skipped | <简短备注> |
   | Lint/类型检查 | `<command>` | pass / fail / skipped | <简短备注> |

   ## 输出摘录

   <相关输出的简短片段（例如测试运行的最后一行摘要、失败的断言）。保持精炼——不要贴完整日志。>

   ## 残余风险

   - <已知局限、未覆盖的环境等>

   ## 建议

   <一段话。示例：>
   - "关闭该 bug——已端到端验证。"
   - "暂缓——复现结论不明；需要在预发环境验证。"
   - "重新打开——症状仍复现；重新运行 `__SPECKIT_COMMAND_BUG_ASSESS__`。"
   ```

5. **汇报结果**，包含：
   - slug 和 `BUG_DIR/test.md` 路径。
   - 结果（`verified`、`partial`、`failed`）。
   - 如果结果是 `failed`，建议带着 `test.md` 中记录的新证据重新运行 `__SPECKIT_COMMAND_BUG_ASSESS__`。

## 护栏

- 本命令**绝不能**修改源代码。它只运行检查，并且只在 `.specify/bugs/<slug>/` 内写入。
- 绝不在未经确认的情况下覆盖已有的 `test.md`。
- 如果原始评估列出的复现你并没有实际执行，绝不能仅凭测试就把修复标记为 `verified`——降级为 `partial` 并如实说明。
