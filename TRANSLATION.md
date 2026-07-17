# Spec Kit 中文翻译计划（spec-kit-zh）

> **定位：持续跟随官方版本的 spec-kit 全量中文学习版。**
> 上游：<https://github.com/github/spec-kit>

## 为什么是这个形态

- **并存式翻译**：上游英文文件一字不改，中文译文作为**新增**的同级文件存在
  （`README.md` → `README.zh.md`，`docs/installation.md` → `docs/installation.zh.md`）。
  因为从不修改上游文件，`git merge upstream/main` 永不冲突，同步成本趋近于零。
- **中英对照**：英文原文始终在旁边，方便核对术语、对照学习。
- **可审计的过期检测**：每个译文头部记录翻译基准 commit，脚本自动列出哪些译文落后于上游。

## 文件约定

每个译文文件头部包含两行元数据：

```html
<!-- zh-source: docs/installation.md -->   ← 对应的英文源文件
<!-- zh-base: ad601e5 -->                  ← 翻译时源文件的最新 commit
```

## 工具

| 命令 | 作用 |
| --- | --- |
| `tools/zh/translate.sh <file.md> [...]` | 用 Claude 按术语表初翻一个或多个文件，生成同级 `.zh.md`（初翻后必须人工审校） |
| `tools/zh/check-stale.sh [--fetch]` | 对比上游，列出所有过期译文及原文改动次数 |

## 同步策略（两档）

| 内容 | 节奏 | 原因 |
| --- | --- | --- |
| `templates/`、各命令提示词 | 跟随上游 release（自动化） | 既是学习材料也是可用件，时效敏感 |
| `docs/`、README、方法论文档 | 每周批量同步一次 | 纯学习材料，官方对 docs 的周改动约 10 个文件 |

同步流程：

```bash
git fetch upstream
git merge upstream/main          # 并存式结构，不会冲突
tools/zh/check-stale.sh          # 列出过期译文
tools/zh/translate.sh <过期文件的英文源>   # 增量重翻
# 人工审校 → 提交
```

## 翻译范围（按优先级）

1. ✅ 一期（已完成）：`README.md`、`spec-driven.md`（方法论）、`docs/`、`templates/`
2. ✅ 二期（已完成）：`extensions/`、`presets/` 全量（含内置扩展与示例预设）
3. ❌ 不翻：`src/`、`tests/`、newsletters、CHANGELOG、CODE_OF_CONDUCT、`.github/` 内部文件

## 术语

见 [GLOSSARY.zh.md](GLOSSARY.zh.md)。所有翻译（人工与 AI）必须遵守。
