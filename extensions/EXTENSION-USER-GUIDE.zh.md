<!-- zh-source: extensions/EXTENSION-USER-GUIDE.md -->
<!-- zh-base: 171b65a -->

# 扩展用户指南

使用 Spec Kit 扩展增强工作流的完整指南。

## 目录

1. [简介](#简介)
2. [快速上手](#快速上手)
3. [查找扩展](#查找扩展)
4. [安装扩展](#安装扩展)
5. [使用扩展](#使用扩展)
6. [管理扩展](#管理扩展)
7. [配置](#配置)
8. [故障排查](#故障排查)
9. [最佳实践](#最佳实践)

---

## 简介

### 什么是扩展？

扩展是模块化的软件包，在不让核心框架膨胀的前提下为 Spec Kit 增加新命令和新功能。它们让你可以：

- **集成**外部工具（Jira、Linear、GitHub 等）
- 用钩子**自动化**重复性任务
- 为你的团队**定制**工作流
- 在项目之间**共享**解决方案

### 为什么使用扩展？

- **核心干净**：让 spec-kit 保持轻量、聚焦
- **功能可选**：只安装你需要的
- **社区驱动**：任何人都可以创建和分享扩展
- **独立版本管理**：扩展各自独立管理版本

---

## 快速上手

### 前置条件

- Spec Kit 0.1.0 或更高版本
- 一个 spec-kit 项目（包含 `.specify/` 文件夹的目录）

### 检查你的版本

```bash
specify version
# 应显示 0.1.0 或更高版本
```

### 第一个扩展

我们以安装 Jira 扩展为例：

```bash
# 1. 搜索扩展
specify extension search jira

# 2. 查看详细信息
specify extension info jira

# 3. 安装
specify extension add jira

# 4. 配置
vim .specify/extensions/jira/jira-config.yml

# 5. 使用
# （命令现在已在 Claude Code 中可用）
/speckit.jira.specstoissues
```

---

## 查找扩展

`specify extension search` 会同时搜索**所有生效的目录源**，默认也包括社区目录源。搜索结果会标注来源目录源和安装状态。

### 浏览所有扩展

```bash
specify extension search
```

显示所有生效目录源中的全部扩展（默认包括 default 与 community 两个目录源）。

### 按关键词搜索

```bash
# 搜索 "jira"
specify extension search jira

# 搜索 "issue tracking"（问题跟踪）类扩展
specify extension search issue
```

### 按标签过滤

```bash
# 查找所有问题跟踪类扩展
specify extension search --tag issue-tracking

# 查找所有 Atlassian 工具
specify extension search --tag atlassian
```

### 按作者过滤

```bash
# Stats Perform 出品的扩展
specify extension search --author "Stats Perform"
```

### 只看已验证的扩展

```bash
# 只显示已验证（verified）的扩展
specify extension search --verified
```

### 查看扩展详情

```bash
# 详细信息
specify extension info jira
```

显示内容包括：

- 描述
- 依赖要求
- 提供的命令
- 可用的钩子
- 相关链接（文档、仓库、变更日志）
- 安装状态

---

## 安装扩展

### 从目录源安装

```bash
# 按名称安装（来自目录源）
specify extension add jira
```

这条命令会：

1. 从 GitHub 下载扩展
2. 校验清单（manifest）
3. 检查与你的 spec-kit 版本的兼容性
4. 安装到 `.specify/extensions/jira/`
5. 把命令注册到你的编码智能体
6. 创建配置模板

### 从 URL 安装

```bash
# 从 GitHub release 安装
specify extension add <extension-name> --from https://github.com/org/spec-kit-ext/archive/refs/tags/v1.0.0.zip
```

### 从本地目录安装（开发用）

```bash
# 用于测试或开发
specify extension add --dev /path/to/extension
```

### 安装输出

```text
✓ Extension installed successfully!

Jira Integration (v1.0.0)
  Create Jira Epics, Stories, and Issues from spec-kit artifacts

Provided commands:
  • speckit.jira.specstoissues - Create Jira hierarchy from spec and tasks
  • speckit.jira.discover-fields - Discover Jira custom fields for configuration
  • speckit.jira.sync-status - Sync task completion status to Jira

⚠  Configuration may be required
   Check: .specify/extensions/jira/
```

### 自动注册智能体技能

如果你的项目使用基于技能的集成（例如 `--integration claude`、`--integration codex`），或初始化时带了 `--integration-options="--skills"`，扩展命令会在安装时**自动注册为智能体技能**。这保证了使用 [agentskills.io](https://agentskills.io) 技能规范的智能体也能发现这些扩展。

```text
✓ Extension installed successfully!

Jira Integration (v1.0.0)
  ...

✓ 3 agent skill(s) auto-registered
```

移除扩展时，对应的技能也会被自动清理。已经存在、且被手工定制过的技能永远不会被覆盖。

---

## 使用扩展

### 使用扩展命令

扩展添加的命令会出现在你的编码智能体（Claude Code）中：

```text
# 在 Claude Code 中
> /speckit.jira.specstoissues

# 或使用带命名空间的别名（如果扩展提供了）
> /speckit.jira.sync
```

### 扩展配置

大多数扩展需要配置：

```bash
# 1. 找到配置文件
ls .specify/extensions/jira/

# 2. 把模板复制为配置文件
cp .specify/extensions/jira/jira-config.template.yml \
   .specify/extensions/jira/jira-config.yml

# 3. 编辑配置
vim .specify/extensions/jira/jira-config.yml

# 4. 使用扩展
# （命令现在会按你的配置工作）
```

### 扩展钩子

有些扩展提供在核心命令之后执行的钩子：

**示例**：Jira 扩展挂在 `/speckit.tasks` 上

```text
# 运行核心命令
> /speckit.tasks

# 输出中包含：
## Extension Hooks

**Optional Hook**: jira
Command: `/speckit.jira.specstoissues`
Description: Automatically create Jira hierarchy after task generation

Prompt: Create Jira issues from tasks?
To execute: `/speckit.jira.specstoissues`
```

然后你可以选择运行该钩子，也可以跳过它。

---

## 管理扩展

### 列出已安装的扩展

```bash
specify extension list
```

输出：

```text
Installed Extensions:

  ✓ Jira Integration (v1.0.0)
     Create Jira Epics, Stories, and Issues from spec-kit artifacts
     Commands: 3 | Hooks: 1 | Status: Enabled
```

### 更新扩展

```bash
# 检查更新（所有扩展）
specify extension update

# 更新指定扩展
specify extension update jira
```

输出：

```text
🔄 Checking for updates...

Updates available:

  • jira: 1.0.0 → 1.1.0

Update these extensions? [y/N]:
```

### 临时禁用扩展

```bash
# 禁用而不移除
specify extension disable jira

✓ Extension 'jira' disabled

Commands will no longer be available. Hooks will not execute.
To re-enable: specify extension enable jira
```

### 重新启用扩展

```bash
specify extension enable jira

✓ Extension 'jira' enabled
```

### 移除扩展

```bash
# 移除扩展（带确认提示）
specify extension remove jira

# 移除时保留配置
specify extension remove jira --keep-config

# 强制移除（不确认）
specify extension remove jira --force
```

---

## 配置

### 配置文件

扩展可以有多个配置文件：

```text
.specify/extensions/jira/
├── jira-config.yml           # 主配置（纳入版本控制）
├── jira-config.local.yml     # 本地覆盖（被 gitignore 忽略）
└── jira-config.template.yml  # 模板（参考）
```

### 配置层级

配置按以下顺序合并（越靠后优先级越高）：

1. **扩展默认值**（来自 `extension.yml`）
2. **项目配置**（`jira-config.yml`）
3. **本地覆盖**（`jira-config.local.yml`）
4. **环境变量**（`SPECKIT_JIRA_*`）

### 示例：Jira 配置

**项目配置**（`.specify/extensions/jira/jira-config.yml`）：

```yaml
project:
  key: "MSATS"

defaults:
  epic:
    labels: ["spec-driven"]
```

**本地覆盖**（`.specify/extensions/jira/jira-config.local.yml`）：

```yaml
project:
  key: "MYTEST"  # 本地开发时的覆盖值
```

**环境变量**：

```bash
export SPECKIT_JIRA_PROJECT_KEY="DEVTEST"
```

最终解析出的配置使用来自环境变量的 `DEVTEST`。

### 项目级扩展设置

文件：`.specify/extensions.yml`

```yaml
# 本项目已安装的扩展
installed:
  - jira
  - linear

# 全局设置
settings:
  auto_execute_hooks: true

# 钩子配置
# 可用事件：before_specify, after_specify, before_plan, after_plan,
#           before_tasks, after_tasks, before_implement, after_implement,
#           before_analyze, after_analyze, before_checklist, after_checklist,
#           before_clarify, after_clarify, before_constitution, after_constitution,
#           before_taskstoissues, after_taskstoissues
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"
```

### 核心环境变量

除扩展专属的环境变量（`SPECKIT_{EXT_ID}_*`）外，spec-kit 还支持以下核心环境变量：

| 变量 | 说明 | 默认值 |
|----------|-------------|---------|
| `SPECKIT_CATALOG_URL`       | 用单个 URL 覆盖整个目录源栈（向后兼容） | 内置默认目录源栈 |
| `GH_TOKEN` / `GITHUB_TOKEN` | 向 GitHub 托管的 URL（`raw.githubusercontent.com`、`github.com`、`api.github.com`、`codeload.github.com`）发起认证请求所用的 GitHub token。当你的目录源 JSON 或扩展 ZIP 托管在私有 GitHub 仓库时必需。 | 无 |

#### 示例：用自定义目录源做测试

```bash
# 指向本地或替代目录源（替换整个目录源栈）
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"

# 或使用预发布（staging）目录源
export SPECKIT_CATALOG_URL="https://example.com/staging/catalog.json"
```

#### 示例：使用私有 GitHub 托管的目录源

```bash
# 用 token 认证（gh CLI、PAT，或 CI 中的 GITHUB_TOKEN）
export GITHUB_TOKEN=$(gh auth token)

# 搜索通过 `specify extension catalog add` 添加的私有目录源
specify extension search jira

# 从私有目录源安装
specify extension add jira-sync
```

token 会自动附加到面向 GitHub 域名的请求上。非 GitHub 的目录源 URL 始终以无凭据方式获取。

---

## 扩展目录源

Spec Kit 使用**目录源栈**——一个按优先级排序、同时被搜索的目录源列表。默认有两个目录源处于生效状态：

| 优先级 | 目录源 | 允许安装 | 用途 |
|----------|---------|-----------------|---------|
| 1 | `catalog.json`（default） | ✅ 是 | 可供安装的精选扩展 |
| 2 | `catalog.community.json`（community） | ❌ 否（仅发现） | 浏览社区扩展 |

### 列出生效的目录源

```bash
specify extension catalog list
```

### 通过 CLI 管理目录源

可以用 `--help` 查看主要的目录源管理命令：

```text
specify extension catalog --help

 Usage: specify extension catalog [OPTIONS] COMMAND [ARGS]...

 Manage extension catalogs
╭─ Options ────────────────────────────────────────────────────────────────────────╮
│ --help          Show this message and exit.                                      │
╰──────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands ───────────────────────────────────────────────────────────────────────╮
│ list     List all active extension catalogs.                                     │
│ add      Add a catalog to .specify/extension-catalogs.yml.                       │
│ remove   Remove a catalog from .specify/extension-catalogs.yml.                  │
╰──────────────────────────────────────────────────────────────────────────────────╯
```

### 添加目录源（项目级）

```bash
# 添加一个允许安装的内部目录源
specify extension catalog add \
  --name "internal" \
  --priority 2 \
  --install-allowed \
  https://internal.company.com/spec-kit/catalog.json

# 添加一个仅用于发现（discovery-only）的目录源
specify extension catalog add \
  --name "partner" \
  --priority 5 \
  https://partner.example.com/spec-kit/catalog.json
```

这会创建或更新 `.specify/extension-catalogs.yml`。

### 移除目录源

```bash
specify extension catalog remove internal
```

### 手动编辑配置文件

你也可以直接编辑 `.specify/extension-catalogs.yml`：

```yaml
catalogs:
  - name: "default"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json"
    priority: 1
    install_allowed: true
    description: "Built-in catalog of installable extensions"

  - name: "internal"
    url: "https://internal.company.com/spec-kit/catalog.json"
    priority: 2
    install_allowed: true
    description: "Internal company extensions"

  - name: "community"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json"
    priority: 3
    install_allowed: false
    description: "Community-contributed extensions (discovery only)"
```

用户级的对应文件位于 `~/.specify/extension-catalogs.yml`。只要项目级配置包含至少一个目录源条目，就会完全优先生效。空的 `catalogs: []` 列表会回退到内置默认值。

## 组织目录源定制

### 为什么要定制目录源

组织定制自己的目录源，通常是为了：

- **控制可用扩展**——精选团队可以安装哪些扩展
- **托管私有扩展**——不宜公开的内部工具
- **满足合规定制**——符合安全/审计要求
- **支持离线隔离（air-gapped）环境**——在没有互联网的环境中工作

### 搭建自定义目录源

#### 1. 创建目录源文件

创建一个包含你的扩展的 `catalog.json` 文件：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-02-03T00:00:00Z",
  "catalog_url": "https://your-org.com/spec-kit/catalog.json",
  "extensions": {
    "jira": {
      "name": "Jira Integration",
      "id": "jira",
      "description": "Create Jira issues from spec-kit artifacts",
      "author": "Your Organization",
      "version": "2.1.0",
      "download_url": "https://github.com/your-org/spec-kit-jira/archive/refs/tags/v2.1.0.zip",
      "repository": "https://github.com/your-org/spec-kit-jira",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0",
        "tools": [
          {"name": "atlassian-mcp-server", "required": true}
        ]
      },
      "provides": {
        "commands": 3,
        "hooks": 1
      },
      "tags": ["jira", "atlassian", "issue-tracking"],
      "verified": true
    },
    "internal-tool": {
      "name": "Internal Tool Integration",
      "id": "internal-tool",
      "description": "Connect to internal company systems",
      "author": "Your Organization",
      "version": "1.0.0",
      "download_url": "https://internal.your-org.com/extensions/internal-tool-1.0.0.zip",
      "repository": "https://github.internal.your-org.com/spec-kit-internal",
      "license": "Proprietary",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "provides": {
        "commands": 2
      },
      "tags": ["internal", "proprietary"],
      "verified": true
    }
  }
}
```

#### 2. 托管目录源

托管目录源的几种方式：

| 方式 | URL 示例 | 适用场景 |
| ------ | ----------- | -------- |
| GitHub Pages | `https://your-org.github.io/spec-kit-catalog/catalog.json` | 公开或组织内可见 |
| 内部 Web 服务器 | `https://internal.company.com/spec-kit/catalog.json` | 企业内网 |
| S3/云存储 | `https://s3.amazonaws.com/your-bucket/catalog.json` | 云端团队 |
| 本地文件服务器 | `http://localhost:8000/catalog.json` | 开发/测试 |

**安全要求**：URL 必须使用 HTTPS（测试用的 `localhost` 除外）。

#### 3. 配置你的环境

##### 方案 A：目录源栈配置文件（推荐）

在项目的 `.specify/extension-catalogs.yml` 中添加：

```yaml
catalogs:
  - name: "my-org"
    url: "https://your-org.com/spec-kit/catalog.json"
    priority: 1
    install_allowed: true
```

或使用 CLI：

```bash
specify extension catalog add \
  --name "my-org" \
  --install-allowed \
  https://your-org.com/spec-kit/catalog.json
```

##### 方案 B：环境变量（推荐用于 CI/CD、单目录源场景）

```bash
# 写入 ~/.bashrc、~/.zshrc 或 CI 流水线
export SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json"
```

#### 4. 验证配置

```bash
# 列出生效的目录源
specify extension catalog list

# 搜索结果现在应包含你目录源中的扩展
specify extension search

# 从你的目录源安装
specify extension add jira
```

### 目录源 JSON Schema

每个扩展条目的字段要求：

| 字段 | 类型 | 必填 | 说明 |
| ----- | ---- | -------- | ----------- |
| `name` | string | 是 | 人类可读的名称 |
| `id` | string | 是 | 唯一标识符（小写、连字符） |
| `version` | string | 是 | 语义化版本（X.Y.Z） |
| `download_url` | string | 是 | ZIP 压缩包的 URL |
| `repository` | string | 是 | 源码 URL |
| `description` | string | 否 | 简短描述 |
| `author` | string | 否 | 作者/组织 |
| `license` | string | 否 | SPDX 许可证标识符 |
| `requires.speckit_version` | string | 否 | 版本约束 |
| `requires.tools` | array | 否 | 所需的外部工具 |
| `provides.commands` | number | 否 | 命令数量 |
| `provides.hooks` | number | 否 | 钩子数量 |
| `tags` | array | 否 | 搜索标签 |
| `verified` | boolean | 否 | 验证状态 |

### 使用场景

#### 私有/内部扩展

托管与内部系统集成的专有扩展：

```json
{
  "internal-auth": {
    "name": "Internal SSO Integration",
    "download_url": "https://artifactory.company.com/spec-kit/internal-auth-1.0.0.zip",
    "verified": true
  }
}
```

#### 精选团队目录源

限制团队可以安装哪些扩展：

```json
{
  "extensions": {
    "jira": { "..." },
    "github": { "..." }
  }
}
```

`specify extension search` 中将只出现 `jira` 和 `github`。

#### 离线隔离（air-gapped）环境

对于无法访问互联网的网络：

1. 把扩展 ZIP 下载到内部文件服务器
2. 创建指向内部 URL 的目录源
3. 把目录源托管在内部 Web 服务器上

```json
{
  "jira": {
    "download_url": "https://files.internal/spec-kit/jira-2.1.0.zip"
  }
}
```

#### 开发/测试

在发布前测试新扩展：

```bash
# 启动本地服务器
python -m http.server 8000 --directory ./my-catalog/

# 让 spec-kit 指向本地目录源
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"

# 测试安装
specify extension add my-new-extension
```

### 与直接安装结合使用

你仍然可以用 `--from` 安装不在目录源中的扩展：

```bash
# 从目录源安装
specify extension add jira

# 直接 URL（绕过目录源）
specify extension add <extension-name> --from https://github.com/someone/spec-kit-ext/archive/v1.0.0.zip

# 本地开发
specify extension add --dev /path/to/extension
```

**注意**：直接通过 URL 安装会显示安全警告，因为该扩展并非来自你配置的目录源。

---

## 故障排查

### 找不到扩展

**错误**：`Extension 'jira' not found in catalog

**解决办法**：

1. 检查拼写：`specify extension search jira`
2. 刷新目录源：`specify extension search --help`
3. 检查网络连接
4. 该扩展可能尚未发布

### 找不到配置

**错误**：`Jira configuration not found`

**解决办法**：

1. 检查扩展是否已安装：`specify extension list`
2. 从模板创建配置：

   ```bash
   cp .specify/extensions/jira/jira-config.template.yml \
      .specify/extensions/jira/jira-config.yml
   ```

3. 重新安装扩展：`specify extension remove jira && specify extension add jira`

### 命令不可用

**问题**：扩展命令没有出现在编码智能体中

**解决办法**：

1. 检查扩展已启用：`specify extension list`
2. 重启编码智能体（Claude Code）
3. 检查命令文件是否存在：

   ```bash
   ls .claude/commands/speckit.jira.*.md
   ```

4. 重新安装扩展

### 版本不兼容

**错误**：`Extension requires spec-kit >=0.2.0, but you have 0.1.0`

**解决办法**：

1. 升级 spec-kit：

   ```bash
   uv tool upgrade specify-cli
   ```

2. 安装扩展的旧版本：

   ```bash
   specify extension add <extension-name> --from https://github.com/org/ext/archive/v1.0.0.zip
   ```

### MCP 工具不可用

**错误**：`Tool 'jira-mcp-server/epic_create' not found`

**解决办法**：

1. 检查 MCP 服务器是否已安装
2. 检查编码智能体的 MCP 配置
3. 重启编码智能体
4. 检查扩展的依赖要求：`specify extension info jira`

### 权限被拒

**错误**：访问 Jira 时出现 `Permission denied`

**解决办法**：

1. 检查 MCP 服务器配置中的 Jira 凭据
2. 核对 Jira 中的项目权限
3. 单独测试 MCP 服务器连接

---

## 最佳实践

### 1. 版本控制

**应该提交**：

- `.specify/extensions.yml`（项目扩展配置）
- `.specify/extensions/*/jira-config.yml`（项目配置）

**不要提交**：

- `.specify/extensions/.cache/`（目录源缓存）
- `.specify/extensions/.backup/`（配置备份）
- `.specify/extensions/*/*.local.yml`（本地覆盖）
- `.specify/extensions/.registry`（安装状态）

添加到 `.gitignore`：

```gitignore
.specify/extensions/.cache/
.specify/extensions/.backup/
.specify/extensions/*/*.local.yml
.specify/extensions/.registry
```

### 2. 团队工作流

**对团队来说**：

1. 商定要使用哪些扩展
2. 提交扩展配置
3. 在 README 中记录扩展用法
4. 团队统一更新扩展

**README 小节示例**：

```markdown
## 扩展

本项目使用：
- **jira**（v1.0.0）——Jira 集成
  - 配置：`.specify/extensions/jira/jira-config.yml`
  - 依赖：jira-mcp-server

安装方式：`specify extension add jira`
```

### 3. 本地开发

开发时使用本地配置：

```yaml
# .specify/extensions/jira/jira-config.local.yml
project:
  key: "DEVTEST"  # 你的测试项目

defaults:
  task:
    custom_fields:
      customfield_10002: 1  # 测试用的较低故事点
```

### 4. 环境相关配置

在 CI/CD 中使用环境变量：

```bash
# .github/workflows/deploy.yml
env:
  SPECKIT_JIRA_PROJECT_KEY: ${{ secrets.JIRA_PROJECT }}

- name: Create Jira Issues
  run: specify extension add jira && ...
```

### 5. 扩展更新

**定期检查更新**：

```bash
# 每周检查，或在重要发布前检查
specify extension update
```

**固定版本以保证稳定**：

```yaml
# .specify/extensions.yml
installed:
  - id: jira
    version: "1.0.0"  # 固定到特定版本
```

### 6. 只装必要的扩展

只安装你实际在用的扩展：

- 降低复杂度
- 命令加载更快
- 配置更少

### 7. 文档

在项目中记录扩展的用法：

```markdown
# PROJECT.md

## 使用 Jira

创建任务后同步到 Jira：
1. 运行 `/speckit.tasks` 生成任务
2. 运行 `/speckit.jira.specstoissues` 创建 Jira issue
3. 运行 `/speckit.jira.sync-status` 更新状态
```

---

## 常见问题

### 问：可以同时使用多个扩展吗？

**答**：可以！扩展在设计上就是可以协同工作的。需要多少装多少。

### 问：扩展会拖慢 spec-kit 吗？

**答**：不会。扩展按需加载，只有使用其命令时才会加载。

### 问：可以创建私有扩展吗？

**答**：可以。用 `--dev` 或 `--from` 安装并保持私有即可。提交到公共目录源是可选的。

### 问：如何判断扩展是否安全？

**答**：认准 ✓ Verified（已验证）徽章。已验证的扩展经过维护者审查。安装前请务必审查扩展代码。

### 问：扩展能修改 spec-kit 核心吗？

**答**：不能。扩展只能添加命令和钩子，无法修改核心功能。

### 问：两个扩展的命令重名了怎么办？

**答**：扩展使用带命名空间的命令（`speckit.{extension}.{command}`），因此冲突非常罕见。如果发生冲突，扩展系统会发出警告。

### 问：可以给现有扩展做贡献吗？

**答**：可以！大多数扩展是开源的。在 `specify extension info {extension}` 中查看仓库链接。

### 问：如何报告扩展的 bug？

**答**：前往该扩展的仓库（`specify extension info` 中会显示）并创建 issue。

### 问：扩展可以离线工作吗？

**答**：安装完成后，扩展本身可以离线工作。但有些扩展的功能可能需要联网（例如 Jira 需要访问 Jira API）。

### 问：如何备份扩展配置？

**答**：扩展配置位于 `.specify/extensions/{extension}/`。备份这个目录，或把配置提交到 git。

---

## 支持

- **扩展问题**：报告到扩展的仓库（见 `specify extension info`）
- **Spec Kit 问题**：<https://github.com/statsperform/spec-kit/issues>
- **扩展目录源**：<https://github.com/statsperform/spec-kit/tree/main/extensions>
- **文档**：参见 EXTENSION-DEVELOPMENT-GUIDE.md 与 EXTENSION-PUBLISHING-GUIDE.md

---

*最后更新：2026-01-28*
*Spec Kit 版本：0.1.0*
