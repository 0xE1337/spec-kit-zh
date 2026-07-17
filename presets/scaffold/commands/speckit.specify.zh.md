---
description: "创建功能规范（预设覆盖版）"
scripts:
  sh: scripts/bash/create-new-feature.sh "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 "{ARGS}"
---

<!-- zh-source: presets/scaffold/commands/speckit.specify.md -->
<!-- zh-base: 69ee7a8 -->

## 用户输入

```text
$ARGUMENTS
```

基于上面的功能描述：

1. **创建功能分支**，运行脚本：
   - Bash：`{SCRIPT} --json --short-name "<short-name>" "<description>"`
   - JSON 输出中包含 BRANCH_NAME 和 SPEC_FILE 路径。

2. **阅读 spec-template**，了解需要填写的章节。

3. **把规范写入** SPEC_FILE，用用户描述中的细节替换各章节
   （概述、需求、验收标准）中的占位符。
