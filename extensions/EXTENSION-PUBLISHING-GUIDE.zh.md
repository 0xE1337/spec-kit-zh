<!-- zh-source: extensions/EXTENSION-PUBLISHING-GUIDE.md -->
<!-- zh-base: b042d2a -->

# 扩展发布指南

本指南说明如何把你的扩展发布到 Spec Kit 扩展目录源，让它能被 `specify extension search` 发现。

## 目录

1. [前置条件](#前置条件)
2. [准备你的扩展](#准备你的扩展)
3. [提交到目录源](#提交到目录源)
4. [发布工作流](#发布工作流)
5. [最佳实践](#最佳实践)

---

## 前置条件

发布扩展之前，请确保你已具备：

1. **有效的扩展**：一个可正常工作的扩展，带有有效的 `extension.yml` 清单
2. **Git 仓库**：扩展托管在 GitHub（或其他公开 git 托管服务）上
3. **文档**：README.md，包含安装和使用说明
4. **许可证**：开源许可证文件（MIT、Apache 2.0 等）
5. **版本管理**：语义化版本（如 1.0.0）
6. **测试**：扩展已在真实项目上测试过

---

## 准备你的扩展

### 1. 扩展结构

确保扩展遵循标准结构：

```text
your-extension/
├── extension.yml              # 必需：扩展清单
├── README.md                  # 必需：文档
├── LICENSE                    # 必需：许可证文件
├── CHANGELOG.md               # 推荐：版本历史
├── .gitignore                 # 推荐：Git 忽略规则
│
├── commands/                  # 扩展命令
│   ├── command1.md
│   └── command2.md
│
├── config-template.yml        # 配置模板（如需要）
│
└── docs/                      # 附加文档
    ├── usage.md
    └── examples/
```

### 2. extension.yml 校验

核实你的清单有效：

```yaml
schema_version: "1.0"

extension:
  id: "your-extension"           # 唯一的小写连字符 ID
  name: "Your Extension Name"     # 人类可读的名称
  version: "1.0.0"                # 语义化版本
  description: "Brief description (one sentence)"
  author: "Your Name or Organization"
  repository: "https://github.com/your-org/spec-kit-your-extension"
  license: "MIT"
  homepage: "https://github.com/your-org/spec-kit-your-extension"

requires:
  speckit_version: ">=0.1.0"    # 所需的 spec-kit 版本

provides:
  commands:                       # 列出全部命令
    - name: "speckit.your-extension.command"
      file: "commands/command.md"
      description: "Command description"

tags:                             # 2-5 个相关标签
  - "category"
  - "tool-name"
```

**校验检查清单**：

- ✅ `id` 只含小写字母和连字符（没有下划线、空格或特殊字符）
- ✅ `version` 遵循语义化版本（X.Y.Z）
- ✅ `description` 简明扼要（100 字符以内）
- ✅ `repository` URL 有效且公开
- ✅ 所有命令文件都存在于扩展目录中
- ✅ 标签为小写且具有描述性

### 3. 创建 GitHub Release

为你的扩展版本创建 GitHub release：

```bash
# 给 release 打 tag
git tag v1.0.0
git push origin v1.0.0

# 在 GitHub 上创建 release
# 前往：https://github.com/your-org/spec-kit-your-extension/releases/new
# - Tag：v1.0.0
# - 标题：v1.0.0 - 发布名称
# - 描述：变更日志/发布说明
```

release 压缩包的 URL 将是：

```text
https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.0.0.zip
```

### 4. 测试安装

测试用户能否从你的 release 安装：

```bash
# 测试开发安装
specify extension add --dev /path/to/your-extension

# 测试从 GitHub 压缩包安装
specify extension add <extension-name> --from https://github.com/your-org/spec-kit-your-extension/archive/refs/tags/v1.0.0.zip
```

---

## 提交到目录源

### 理解目录源

Spec Kit 使用双目录源体系。目录源的工作原理详见[扩展 README](README.md#extension-catalogs)。

**就扩展发布而言**：所有社区扩展都列在 `extensions/catalog.community.json` 中。用户浏览这个目录源，把自己信任的扩展复制到自己的 `catalog.json` 里。

### 如何提交

要把扩展提交到社区目录源，请使用 **[Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml)** 模板新建一个 issue。该模板会收集所有必需的元数据，包括：

- 扩展 ID、名称和版本
- 描述、作者和许可证
- 仓库、下载 URL 和文档链接
- 所需的 Spec Kit 版本及工具依赖
- 命令和钩子的数量
- 标签与主要特性
- 测试确认

> [!IMPORTANT]
> 请**不要**直接开 pull request 修改 `extensions/catalog.community.json`。所有社区扩展提交都必须走 issue 模板，以便维护者审查条目并更新目录源。

### 提交之后会发生什么

1. 你的 issue 会被自动打上标签，并分配给一位维护者审查
2. 维护者核实目录源条目完整且格式正确
3. 审核通过后，维护者把你的扩展加入 `extensions/catalog.community.json` 以及 README 中的社区扩展（Community Extensions）表格
4. 你的扩展即可通过 `specify extension search` 被发现

### 维护者检查什么

- 目录源条目字段完整且格式正确
- 下载 URL 可以访问
- 仓库存在且包含 `extension.yml` 清单

> [!NOTE]
> 维护者**不会**审查、审计或测试扩展代码本身。

### 典型审核时长

- **审核**：3-7 个工作日

### 更新已有扩展

要更新已在目录源中的扩展（例如发布新版本），请再次使用 **[Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml)** 模板提交一个新 issue，填写更新后的版本、下载 URL 以及其他有变化的字段。并在 issue 中说明这是对现有条目的更新。

---

## 发布工作流

### 发布新版本

发布新版本时：

1. **更新 `extension.yml` 中的版本号**：

   ```yaml
   extension:
     version: "1.1.0"  # 更新后的版本
   ```

2. **更新 CHANGELOG.md**：

   ```markdown
   ## [1.1.0] - 2026-02-15

   ### Added
   - New feature X

   ### Fixed
   - Bug fix Y
   ```

3. **创建 GitHub release**：

   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   # 在 GitHub 上创建 release
   ```

4. **提交更新申请**：使用 [Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml) 模板，附上新版本和下载 URL。并在 issue 中说明这是对现有条目的更新。

---

## 最佳实践

### 扩展设计

1. **单一职责**：每个扩展聚焦一个工具/集成
2. **命名清晰**：使用描述性、无歧义的名称
3. **最少依赖**：避免不必要的依赖
4. **向后兼容**：严格遵循语义化版本

### 文档

1. **README.md 结构**：
   - 概述与特性
   - 安装说明
   - 配置指南
   - 使用示例
   - 故障排查
   - 贡献指南

2. **命令文档**：
   - 清晰的描述
   - 列出前置条件
   - 分步说明
   - 错误处理指引
   - 示例

3. **配置**：
   - 提供模板文件
   - 说明所有选项
   - 附带示例
   - 解释默认值

### 安全

1. **输入校验**：校验所有用户输入
2. **不硬编码密钥**：绝不包含凭据
3. **依赖安全**：只使用可信的依赖
4. **定期审计**：检查漏洞

### 维护

1. **响应 issue**：1-2 周内处理 issue
2. **定期更新**：保持依赖为最新
3. **变更日志**：维护详细的变更日志
4. **弃用**：破坏性变更提前通知

### 社区

1. **许可证**：使用宽松的开源许可证（MIT、Apache 2.0）
2. **贡献**：欢迎贡献
3. **行为准则**：保持尊重与包容
4. **支持**：提供获取帮助的途径（issue、讨论、邮件）

---

## 常见问题

### 问：可以发布私有/专有扩展吗？

答：主目录源只收录公开扩展。私有扩展可以：

- 自行托管 catalog.json 文件
- 用户添加你的目录源：`specify extension add-catalog https://your-domain.com/catalog.json`
- 尚未实现——将在 Phase 4 提供

### 问：审核要多久？

答：通常 3-7 个工作日。更新已有扩展一般更快。

### 问：扩展被拒了怎么办？

答：你会收到说明需要修改哪些内容的反馈。修改后重新提交即可。

### 问：可以随时更新扩展吗？

答：可以。提交一个新的 [Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml) issue，附上更新后的版本和下载 URL，并说明这是对现有条目的更新。

### 问：进入目录源需要"已验证"（verified）身份吗？

答：不需要。所有社区扩展的提交经审核通过后都会被列入目录源。

### 问：扩展可以有付费功能吗？

答：扩展应保持免费和开源。允许提供商业支持/服务，但核心功能必须免费。

---

## 支持

- **目录源问题**：<https://github.com/statsperform/spec-kit/issues>
- **扩展模板**：<https://github.com/statsperform/spec-kit-extension-template>（即将推出）
- **开发指南**：见 EXTENSION-DEVELOPMENT-GUIDE.md
- **社区**：讨论区与问答

---

## 附录：目录源 Schema

### 完整的目录源条目 Schema

```json
{
  "name": "string（必填）",
  "id": "string（必填，唯一）",
  "description": "string（必填，<200 字符）",
  "author": "string（必填）",
  "version": "string（必填，semver）",
  "download_url": "string（必填，有效 URL）",
  "sha256": "string（可选，download_url 处压缩包的 SHA-256 十六进制摘要；安装前会校验）",
  "repository": "string（必填，有效 URL）",
  "homepage": "string（可选，有效 URL）",
  "documentation": "string（可选，有效 URL）",
  "changelog": "string（可选，有效 URL）",
  "license": "string（必填）",
  "requires": {
    "speckit_version": "string（必填，版本说明符）",
    "tools": [
      {
        "name": "string（必填）",
        "version": "string（可选，版本说明符）",
        "required": "boolean（默认：false）"
      }
    ]
  },
  "provides": {
    "commands": "integer（可选）",
    "hooks": "integer（可选）"
  },
  "tags": ["字符串数组（2-10 个标签）"],
  "verified": "boolean（默认：false，由维护者设置）",
  "downloads": "integer（自动更新）",
  "stars": "integer（自动更新）",
  "created_at": "string（ISO 8601 日期时间）",
  "updated_at": "string（ISO 8601 日期时间）"
}
```

### 有效标签

推荐的标签类别：

- **集成**：jira、linear、github、gitlab、azure-devops
- **类别**：issue-tracking、vcs、ci-cd、documentation、testing
- **平台**：atlassian、microsoft、google
- **功能**：automation、reporting、deployment、monitoring

选用 2-5 个最能描述你扩展的标签。

---

*最后更新：2026-01-28*
*目录源格式版本：1.0*
