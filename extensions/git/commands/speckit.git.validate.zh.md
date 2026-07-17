---
description: "校验当前分支是否遵循功能分支命名约定"
---

<!-- zh-source: extensions/git/commands/speckit.git.validate.md -->
<!-- zh-base: f494a8e -->

# 校验功能分支

校验当前 Git 分支是否遵循预期的功能分支命名约定。

## 前置条件

- 运行 `git rev-parse --is-inside-work-tree 2>/dev/null` 检查 Git 是否可用
- 如果 Git 不可用，输出警告并跳过校验：
  ```
  [specify] Warning: Git repository not detected; skipped branch validation
  ```

## 校验规则

获取当前分支名：

```bash
git rev-parse --abbrev-ref HEAD
```

分支名的最后一个路径段必须以下列功能标记之一开头：

1. **顺序编号**：`[0-9]{3,}-`（例如 `001-feature-name`、`042-fix-bug`、`1000-big-feature`、`jdoe/web/008-guided-tour`）
2. **时间戳**：`[0-9]{8}-[0-9]{6}-`（例如 `20260319-143022-feature-name`、`jdoe/web/20260319-143022-feature-name`）

## 执行

如果在功能分支上（匹配任一模式）：
- 输出：`✓ On feature branch: <branch-name>`
- 检查 `specs/` 下是否存在对应的规范目录：
  - 顺序编号分支：查找 `specs/<prefix>-*`，其中 prefix 匹配数字部分，忽略分支的命名空间前缀
  - 时间戳分支：查找 `specs/<prefix>-*`，其中 prefix 匹配 `YYYYMMDD-HHMMSS` 部分，忽略分支的命名空间前缀
- 如果规范目录存在：`✓ Spec directory found: <path>`
- 如果规范目录缺失：`⚠ No spec directory found for prefix <prefix>`

如果**不在**功能分支上：
- 输出：`✗ Not on a feature branch. Current branch: <branch-name>`
- 输出：`Feature branches should be named like: 001-feature-name, 20260319-143022-feature-name, or <namespace>/001-feature-name`

## 优雅降级

如果 Git 未安装或目录不是 Git 仓库：
- 回退检查 `SPECIFY_FEATURE` 环境变量
- 如果已设置，用该值对照命名模式进行校验
- 如果未设置，跳过校验并给出警告
