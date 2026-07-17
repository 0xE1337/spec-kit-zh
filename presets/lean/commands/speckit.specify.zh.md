---
description: 创建规范并存入 spec.md。
---

<!-- zh-source: presets/lean/commands/speckit.specify.md -->
<!-- zh-base: 43cb0fa -->

## 用户输入

```text
$ARGUMENTS
```

## 概要

1. **询问用户**功能目录路径（例如 `specs/my-feature`）。在用户提供之前不要继续。

2. 创建该目录并写入 `.specify/feature.json`：
   ```json
   { "feature_directory": "<feature_directory>" }
   ```

3. 根据用户输入创建规范，存入 `<feature_directory>/spec.md`。
   - 概述、功能需求、用户场景、成功标准
   - 每条需求都必须可测试
   - 对未明确说明的细节做出合理的默认假设
