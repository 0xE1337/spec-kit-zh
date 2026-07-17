---
description: 创建计划并存入 plan.md。
---

<!-- zh-source: presets/lean/commands/speckit.plan.md -->
<!-- zh-base: 43cb0fa -->

## 用户输入

```text
$ARGUMENTS
```

## 概要

1. 读取 `.specify/feature.json`，获取功能目录路径。

2. **加载上下文**：`.specify/memory/constitution.md` 和 `<feature_directory>/spec.md`。

3. 创建实现计划，存入 `<feature_directory>/plan.md`。
   - 技术上下文：技术栈、依赖、项目结构
   - 设计决策、架构、文件结构
