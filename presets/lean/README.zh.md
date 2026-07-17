<!-- zh-source: presets/lean/README.md -->
<!-- zh-base: 8750e94 -->

# Lean 工作流

一个极简预设，把 Spec Kit 工作流削减到最本质的部分——只留提示词，只出产物。

## 何时使用

当你想要结构化的 specify → plan → tasks → implement 流水线，又不想被完整模板的繁文缛节拖累时，就用 Lean。每个命令只产出一个聚焦的 Markdown 文件，没有需要逐项填写的样板章节。

## 包含的命令

| 命令 | 输出 | 说明 |
|---------|--------|-------------|
| `speckit.specify` | `spec.md` | 从功能描述创建规范 |
| `speckit.plan` | `plan.md` | 从规范创建实现计划 |
| `speckit.tasks` | `tasks.md` | 从规范和计划创建按依赖排序的任务清单 |
| `speckit.implement` | *（代码）* | 按顺序执行所有任务并标记进度 |
| `speckit.constitution` | `constitution.md` | 创建或更新项目宪章 |

## 它替换了什么

Lean 用自包含的提示词覆盖五个核心工作流命令，直接产出每个产物——不涉及独立的模板文件。结果是一个更短、更直接的工作流。

## 安装

```bash
# Lean 是随 Spec Kit 内置的预设——无需下载
specify preset add lean
```

## 开发

```bash
# 从本地目录测试
specify preset add --dev ./presets/lean

# 验证命令解析
specify preset resolve speckit.specify

# 完成后移除
specify preset remove lean
```

## 许可证

MIT
