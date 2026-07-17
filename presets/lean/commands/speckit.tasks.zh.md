---
description: 创建实现所需的任务清单并存入 tasks.md。
---

<!-- zh-source: presets/lean/commands/speckit.tasks.md -->
<!-- zh-base: 43cb0fa -->

## 用户输入

```text
$ARGUMENTS
```

## 概要

1. 读取 `.specify/feature.json`，获取功能目录路径。

2. **加载上下文**：`.specify/memory/constitution.md`、`<feature_directory>/spec.md` 和 `<feature_directory>/plan.md`。

3. 创建按依赖排序的实现任务，存入 `<feature_directory>/tasks.md`。
   - 每个任务都使用检查清单格式：`- [ ] [TaskID] Description with file path`（即"[任务 ID] 带文件路径的任务描述"）
   - 按阶段组织：准备、基础、按优先级排序的用户故事、打磨
