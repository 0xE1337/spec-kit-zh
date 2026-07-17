<!-- zh-source: presets/PUBLISHING.md -->
<!-- zh-base: 96039d3 -->

# 预设发布指南

本指南介绍如何把你的预设发布到 Spec Kit 预设目录源，让它可以被 `specify preset search` 发现。

## 目录

1. [前置条件](#前置条件)
2. [准备你的预设](#准备你的预设)
3. [提交到目录源](#提交到目录源)
4. [审核流程](#审核流程)
5. [版本发布流程](#版本发布流程)
6. [最佳实践](#最佳实践)

---

## 前置条件

发布预设之前，请确保你已具备：

1. **有效的预设**：一个可用的预设，带有效的 `preset.yml` 清单（manifest）
2. **Git 仓库**：预设托管在 GitHub（或其他公开的 git 托管服务）上
3. **文档**：一份预设专属的 README.md，解释如何使用**这个预设**，并包含一条有效的 `specify preset add ...` 安装命令（见[使用说明 README 的要求](#使用说明-readme-的要求)）
4. **许可证**：开源许可证文件（MIT、Apache 2.0 等）
5. **版本管理**：语义化版本（例如 1.0.0）
6. **测试**：已用 `specify preset add --dev` 在真实项目上测试过预设

---

## 准备你的预设

### 1. 预设结构

确保你的预设遵循标准结构：

```text
your-preset/
├── preset.yml                 # 必需：预设清单
├── README.md                  # 必需：文档
├── LICENSE                    # 必需：许可证文件
├── CHANGELOG.md               # 推荐：版本历史
│
├── templates/                 # 模板覆盖
│   ├── spec-template.md
│   ├── plan-template.md
│   └── ...
│
└── commands/                  # 命令覆盖（可选）
    └── speckit.specify.md
```

创建新预设时，建议从[脚手架](scaffold/)起步。

### 2. preset.yml 校验

确认你的清单是有效的：

```yaml
schema_version: "1.0"

preset:
  id: "your-preset"               # 唯一 ID，小写并用连字符分隔
  name: "Your Preset Name"        # 人类可读的名称
  version: "1.0.0"                # 语义化版本
  description: "Brief description (one sentence)"  # 简短描述（一句话）
  author: "Your Name or Organization"
  repository: "https://github.com/your-org/spec-kit-preset-your-preset"
  license: "MIT"

requires:
  speckit_version: ">=0.1.0"      # 要求的 spec-kit 版本

provides:
  templates:
    - type: "template"
      name: "spec-template"
      file: "templates/spec-template.md"
      description: "Custom spec template"
      replaces: "spec-template"

tags:                              # 2-5 个相关标签
  - "category"
  - "workflow"
```

**校验检查清单**：

- ✅ `id` 全小写，只用连字符（不含下划线、空格或特殊字符）
- ✅ `version` 遵循语义化版本（X.Y.Z）
- ✅ `description` 简明扼要（200 字符以内）
- ✅ `repository` URL 有效且公开可访问
- ✅ 所有模板和命令文件都实际存在于预设目录中
- ✅ 模板名全小写，只用连字符
- ✅ 命令名使用点分记法（例如 `speckit.specify`）
- ✅ 标签全小写且有描述性

### 3. 本地测试

```bash
# 从本地目录安装
specify preset add --dev /path/to/your-preset

# 验证模板从你的预设解析
specify preset resolve spec-template

# 验证预设信息
specify preset info your-preset

# 列出已安装的预设
specify preset list

# 测试完成后移除
specify preset remove your-preset
```

如果预设包含命令覆盖，验证它们出现在智能体目录中：

```bash
# 检查 Claude 命令（如果使用 Claude）
ls .claude/commands/speckit.*.md

# 检查 Copilot 命令（如果使用 Copilot）
ls .github/agents/speckit.*.agent.md

# 检查 Gemini 命令（如果使用 Gemini）
ls .gemini/commands/speckit.*.toml
```

### 4. 创建 GitHub Release

为你的预设版本创建 GitHub release：

```bash
# 打 release tag
git tag v1.0.0
git push origin v1.0.0
```

release 压缩包 URL 将是：

```text
https://github.com/your-org/spec-kit-preset-your-preset/archive/refs/tags/v1.0.0.zip
```

### 5. 测试从压缩包安装

```bash
specify preset add --from https://github.com/your-org/spec-kit-preset-your-preset/archive/refs/tags/v1.0.0.zip
```

### 使用说明 README 的要求

目录源的 `documentation` 字段必须指向一份解释如何使用**这个预设**的 README——而不是某个更大框架的产品宣传页，也不是另一个独立 CLI 的文档。

提交工作流会**机械化地强制检查**：链接的 README 必须是 GitHub 托管的 URL，路径以 `README.md` 结尾，解析后是可读文件，并且至少包含一条有效的 `specify preset add ...` 命令。其余事项（monorepo 中优先使用预设专属 README、覆盖最小结构）由人工评审检查——请照做，避免你的提交被打回修改。

- **把 `documentation` 指向预设专属的 README。** 在 monorepo（单仓多项目）中，如果预设位于子目录（例如 `presets/<id>/`），请链接该目录内的 README（`presets/<id>/README.md`），而不是仓库根目录的 README。根目录 README 通常是营销/概览页面；目录源应该呈现的是预设的使用说明。关键要求是这份 README 能通过 `documentation` URL 访问到，让用户在下载 release 产物*之前*就能阅读——同一份文件同时打包进 release ZIP 也没有问题。
- **包含一条有效的 Spec Kit CLI 安装命令** *（强制检查）*。链接的 README 必须至少包含一条 `specify preset add ...` 调用。最好使用 URL 与你的 Download URL 一致的目录源安装形式：

  ```bash
  # <download-url> 就是你提交为目录源 Download URL 的那个 URL——
  # 可以是 tag 压缩包，也可以是 release 资产，例如：
  specify preset add --from https://github.com/<org>/<repo>/archive/refs/tags/vX.Y.Z.zip
  specify preset add --from https://github.com/<org>/<repo>/releases/download/vX.Y.Z/<id>-X.Y.Z.zip
  ```

  `specify preset add <id>` 和 `specify preset add --dev <path>` 也可以接受，但 `--from <download-url>` 形式最能清晰地表明该 README 记录的正是这个预设的这次发布。
- **覆盖最小结构**，让读者能判断预设是否适合自己：
  - 预设做什么 / 提供什么
  - 使用 Spec Kit CLI 语法的安装命令（见上）
  - 何时该用 / 何时不该用

链接的 README 中缺少有效 `specify preset add ...` 命令的提交会**校验失败**（工作流检查项 2d），在修正之前不会被合入。

---

## 提交到目录源

### 理解两套目录源

Spec Kit 使用双目录源体系：

- **`catalog.json`** —— 官方的、已审核（verified）的预设（默认允许安装）
- **`catalog.community.json`** —— 社区贡献的预设（默认仅用于发现）

所有社区预设都应提交到 `catalog.community.json`。

### 1. Fork spec-kit 仓库

```bash
git clone https://github.com/YOUR-USERNAME/spec-kit.git
cd spec-kit
```

### 2. 把预设添加到社区目录源

编辑 `presets/catalog.community.json`，加入你的预设。

> **⚠️ 条目必须按预设 ID 的字母顺序排列。** 请把你的预设插入到 `"presets"` 对象中的正确位置。

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-03-10T00:00:00Z",
  "catalog_url": "https://raw.githubusercontent.com/github/spec-kit/main/presets/catalog.community.json",
  "presets": {
    "your-preset": {
      "name": "Your Preset Name",
      "id": "your-preset",
      "description": "Brief description of what your preset provides",
      "author": "Your Name",
      "version": "1.0.0",
      "download_url": "https://github.com/your-org/spec-kit-preset-your-preset/archive/refs/tags/v1.0.0.zip",
      "sha256": "OPTIONAL: SHA-256 hex digest of the archive above; verified before install",
      "repository": "https://github.com/your-org/spec-kit-preset-your-preset",
      "documentation": "https://github.com/your-org/spec-kit-preset-your-preset/blob/main/README.md",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "provides": {
        "templates": 3,
        "commands": 1
      },
      "tags": [
        "category",
        "workflow"
      ],
      "created_at": "2026-03-10T00:00:00Z",
      "updated_at": "2026-03-10T00:00:00Z"
    }
  }
}
```

### 3. 更新社区预设表格

把你的预设加到文档站的社区预设表格中，位于 `docs/community/presets.md`：

```markdown
| Your Preset Name | Brief description of what your preset does | N templates, M commands[, P scripts] | — | [repo-name](https://github.com/your-org/spec-kit-preset-your-preset) |
```

按预设**名称**（表格第一列）的字母顺序插入你的行。

### 4. 提交 Pull Request

```bash
git checkout -b add-your-preset
git add presets/catalog.community.json docs/community/presets.md
git commit -m "Add your-preset to community catalog

- Preset ID: your-preset
- Version: 1.0.0
- Author: Your Name
- Description: Brief description
"
git push origin add-your-preset
```

**Pull Request 检查清单**（提交到上游仓库时请使用英文原文）：

```markdown
## Preset Submission

**Preset Name**: Your Preset Name
**Preset ID**: your-preset
**Version**: 1.0.0
**Repository**: https://github.com/your-org/spec-kit-preset-your-preset

### Checklist
- [ ] Valid preset.yml manifest
- [ ] Usage README with a valid `specify preset add ...` command, linked from `documentation` (preset-scoped README recommended for monorepos)
- [ ] LICENSE file included
- [ ] GitHub release created
- [ ] Preset tested with `specify preset add --dev`
- [ ] Templates resolve correctly (`specify preset resolve`)
- [ ] Commands register to agent directories (if applicable)
- [ ] Commands match template sections (command + template are coherent)
- [ ] Added to presets/catalog.community.json
- [ ] Added row to docs/community/presets.md table
```

---

## 审核流程

提交后，维护者会审查：

1. **清单校验** —— `preset.yml` 有效，所有文件都存在
2. **模板质量** —— 模板有用且结构良好
3. **命令一致性** —— 命令引用的章节确实存在于模板中
4. **安全性** —— 没有恶意内容，文件操作安全
5. **文档** —— `documentation` 链接的 README 解释了如何使用*这个*预设，且包含有效的 `specify preset add ...` 命令

> **评审者注：** 工作流可以机械化地检查*结构*（链接的 README 可访问且包含有效的 `specify preset add ...` 片段；当该片段使用 `--from <url>` 形式时，其 URL 必须与提交的下载 URL 完全一致——其他被接受的形式如 `specify preset add <id>` 根本不引用下载 URL）。但 README 是否真正记录了*这个*预设，部分属于内容判断，所以人工评审者在批准前仍应确认链接的文档不只是把人引流到另一个产品或 CLI 的入口。

审核通过后，条目会被设置 `verified: true`，预设就会出现在 `specify preset search` 的结果中。

---

## 版本发布流程

发布新版本时：

1. 更新 `preset.yml` 中的 `version`
2. 更新 CHANGELOG.md
3. 打 tag 并推送：`git tag v1.1.0 && git push origin v1.1.0`
4. 提交 PR，更新 `presets/catalog.community.json` 中的 `version` 和 `download_url`

---

## 最佳实践

### 模板设计

- **章节保持清晰** —— 使用标题和 LLM 可以替换的占位文本
- **命令与模板匹配** —— 如果预设覆盖了命令，确保命令引用的是你模板里的章节
- **标注定制点** —— 用 HTML 注释引导用户知道该改哪里

### 命名

- 预设 ID 应有描述性：`healthcare-compliance`、`enterprise-safe`、`startup-lean`
- 避免泛泛的名字：`my-preset`、`custom`、`test`

### 叠加

- 把预设设计成能与其他预设良好叠加
- 只覆盖你需要改动的模板
- 记录你的预设修改了哪些模板和命令

### 命令覆盖

- 只有在工作流本身需要变化时才覆盖命令，仅改输出格式不需要
- 如果你只需要不同的模板章节，覆盖模板就够了
- 用多个智能体（Claude、Gemini、Copilot）测试命令覆盖
