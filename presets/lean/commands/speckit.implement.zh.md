---
description: 处理 tasks.md 中的所有任务，执行实现计划。
---

<!-- zh-source: presets/lean/commands/speckit.implement.md -->
<!-- zh-base: 43cb0fa -->

## 用户输入

```text
$ARGUMENTS
```

## 概要

1. 读取 `.specify/feature.json`，获取功能目录路径。

2. **加载上下文**：`.specify/memory/constitution.md`、`<feature_directory>/spec.md`、`<feature_directory>/plan.md` 和 `<feature_directory>/tasks.md`。

3. **按顺序执行任务**：
   - 完成当前任务后再进入下一个
   - 在 `<feature_directory>/tasks.md` 中把 `- [ ]` 改为 `- [x]` 来标记已完成的任务
   - 失败时停下并报告问题

4. **验证**：确认所有任务都已完成，且实现与规范一致。
