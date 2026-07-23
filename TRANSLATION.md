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
| `tools/zh/check-stale.sh [--fetch]` | 对比上游，列出所有过期译文及原文改动次数 |
| `tools/zh/detect.sh` | **只读**检测：定时任务用。检测过期/新增，开或原地刷新单个「待翻清单」issue；已同步则自动关闭该 issue。不翻译、不改仓库 |
| `tools/zh/translate.sh <file.md> [...]` | 用 Claude 按术语表初翻文件，生成同级 `.zh.md`（初翻后必须人工审校） |
| `tools/zh/translate-patch.sh <file.md>` | 按 git diff 增量更新一个过期译文，保留已定稿内容 |
| `tools/zh/sync.sh` | 全自动 fetch→merge→翻译→开 PR。仅供**已登录 claude 的本地手动**运行；定时任务不用它（无人值守下 claude 无法认证） |

## 同步机制（B 档半自动）

- **检测（自动）**：launchd 每天 10:00 跑只读的 `detect.sh`，有待翻内容就在仓库开一个「待翻清单」issue（复用同一 issue、原地刷新）。plist 见 `tools/zh/com.spec-kit-zh.sync.plist`，日志 `tools/zh/sync.log`。
- **翻译（人工触发）**：看到「待翻清单」issue，在 Claude Code 会话说一句「同步官方更新」，即按术语表翻译并合并。翻译不走无人值守（claude 认证受限），由会话里可靠地做，保证质量。

## 同步纪律（每次同步必须遵守）

1. **流程**：`git fetch upstream` → `git merge upstream/main`（并存式结构，零冲突）→ `check-stale.sh` 列过期 → **同时**扫描范围内的新增未译文件（两者都要，别只看过期）→ 增量补丁过期 + 全量翻译新增 → `check-stale.sh` 必须全绿 → 提交推送。
2. **过期文件用增量补丁**（`translate-patch.sh` 或按 diff 手改），**不整篇重翻**，保住已定稿/已审校内容。
3. **改完更新每个译文头的 `zh-base`** 为对应源文件的最新 commit。
4. **收尾必须关掉对应的「待翻清单」issue**：会话里手动同步后，要么直接关该 issue，要么跑一次 `detect.sh` 让它自动关（`detect.sh` 发现已对齐会自动关闭）。曾因漏关遗留过 open issue。
5. **README.md 是唯一我们也改的英文文件**（顶部中文入口）；合并后它会产生与上游不同的 commit 哈希，`check-stale.sh` 已特殊处理（0 新改动不误报）。
6. **绝不修改上游英文文件**（README.md 首行 banner 除外）；任何 `gh` 写操作必须显式 `-R 0xE1337/spec-kit-zh`，避免误发到 upstream。

## 翻译范围（按优先级）

1. ✅ 一期（已完成）：`README.md`、`spec-driven.md`（方法论）、`docs/`、`templates/`
2. ✅ 二期（已完成）：`extensions/`、`presets/` 全量（含内置扩展与示例预设）
3. ❌ 不翻：`src/`、`tests/`、newsletters、CHANGELOG、CODE_OF_CONDUCT、`.github/` 内部文件

## 术语

见 [GLOSSARY.zh.md](GLOSSARY.zh.md)。所有翻译（人工与 AI）必须遵守。
