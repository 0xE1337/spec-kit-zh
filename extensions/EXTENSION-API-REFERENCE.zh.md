<!-- zh-source: extensions/EXTENSION-API-REFERENCE.md -->
<!-- zh-base: 4ec4635 -->

# 扩展 API 参考

Spec Kit 扩展系统 API 与清单（manifest）Schema 的技术参考。

## 目录

1. [扩展清单](#扩展清单)
2. [Python API](#python-api)
3. [命令文件格式](#命令文件格式)
4. [配置 Schema](#配置-schema)
5. [钩子系统](#钩子系统)
6. [CLI 命令](#cli-命令)

---

## 扩展清单

### Schema 版本 1.0

文件：`extension.yml`

```yaml
schema_version: "1.0"  # 必填

extension:
  id: string           # 必填，模式：^[a-z0-9-]+$
  name: string         # 必填，人类可读的名称
  version: string      # 必填，语义化版本（X.Y.Z）
  description: string  # 必填，简短描述（<200 字符）
  author: string       # 必填
  repository: string   # 必填，有效 URL
  license: string      # 必填（如 "MIT"、"Apache-2.0"）
  homepage: string     # 可选，有效 URL

requires:
  speckit_version: string  # 必填，版本说明符（>=X.Y.Z）
  tools:                   # 可选，工具依赖数组
    - name: string         # 工具名称
      version: string      # 可选，版本说明符
      required: boolean    # 可选，默认：false

provides:
  commands:              # 必填，至少一个命令
    - name: string       # 必填，模式：^speckit\.[a-z0-9-]+\.[a-z0-9-]+$
      file: string       # 必填，命令文件的相对路径
      description: string # 必填
      aliases: [string]  # 可选，模式与 name 相同；命名空间必须与 extension.id 一致，且不得遮蔽核心命令或已安装扩展的命令

  config:                # 可选，配置文件数组
    - name: string       # 配置文件名
      template: string   # 模板文件路径
      description: string
      required: boolean  # 默认：false

hooks:                   # 可选，事件钩子。每个事件可用下面两种形式之一。
  event_name:            # 例如 "after_specify"、"after_plan"、"after_tasks"、"after_implement"
    command: string      # 要执行的命令
    priority: integer    # 可选，>= 1，默认 10（数字越小越先运行）
    optional: boolean    # 默认：true
    prompt: string       # 可选钩子的提示文本
    description: string  # 钩子描述
    condition: string    # 可选，条件表达式
  another_event:         # 任何事件也可以改用映射列表（多个命令）
    - command: string    # 与单个映射的字段相同，逐条填写
      priority: integer
    - command: string
      priority: integer

tags:                    # 可选，标签数组（建议 2-10 个）
  - string

defaults:                # 可选，默认配置值
  key: value             # 任意 YAML 结构
```

### 字段说明

#### `extension.id`

- **类型**：string
- **模式**：`^[a-z0-9-]+$`
- **说明**：扩展的唯一标识符
- **示例**：`jira`、`linear`、`azure-devops`
- **无效示例**：`Jira`、`my_extension`、`extension.id`

#### `extension.version`

- **类型**：string
- **格式**：语义化版本（X.Y.Z）
- **说明**：扩展版本
- **示例**：`1.0.0`、`0.9.5`、`2.1.3`
- **无效示例**：`v1.0`、`1.0`、`1.0.0-beta`

#### `requires.speckit_version`

- **类型**：string
- **格式**：版本说明符
- **说明**：所需的 spec-kit 版本范围
- **示例**：
  - `>=0.1.0`——0.1.0 及以上的任意版本
  - `>=0.1.0,<2.0.0`——0.1.x 或 1.x 版本
  - `==0.1.0`——精确等于 0.1.0
- **无效示例**：`0.1.0`、`>= 0.1.0`（含空格）、`latest`

#### `provides.commands[].name`

- **类型**：string
- **模式**：`^speckit\.[a-z0-9-]+\.[a-z0-9-]+$`
- **说明**：带命名空间的命令名
- **格式**：`speckit.{extension-id}.{command-name}`
- **示例**：`speckit.jira.specstoissues`、`speckit.linear.sync`
- **无效示例**：`jira.specstoissues`、`speckit.command`、`speckit.jira.CreateIssues`

#### `hooks`

- **类型**：object
- **键**：事件名（如 `after_specify`、`after_plan`、`after_tasks`、`after_implement`、`before_analyze`）
- **值**：单个钩子映射，或钩子映射列表（在同一事件上注册多个命令）
- **说明**：在生命周期事件处执行的钩子
- **事件**：由 spec-kit 核心命令定义
- **顺序**：同一事件内，钩子按 `priority` 升序运行（整数 ≥ 1，默认 10；数字越小越先运行；优先级相同时通过稳定排序保持书写顺序）

---

## Python API

### ExtensionManifest

**模块**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionManifest

manifest = ExtensionManifest(Path("extension.yml"))
```

**属性**：

```python
manifest.id                        # str：扩展 ID
manifest.name                      # str：扩展名称
manifest.version                   # str：版本
manifest.description               # str：描述
manifest.requires_speckit_version  # str：所需的 spec-kit 版本
manifest.commands                  # List[Dict]：命令定义
manifest.hooks                     # Dict：钩子定义
```

**方法**：

```python
manifest.get_hash()  # str：清单文件的 SHA256 哈希
```

**异常**：

```python
ValidationError       # 清单结构无效
CompatibilityError    # 与当前 spec-kit 版本不兼容
```

### ExtensionRegistry

**模块**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionRegistry

registry = ExtensionRegistry(extensions_dir)
```

**方法**：

```python
# 把扩展加入注册表
registry.add(extension_id: str, metadata: dict)

# 从注册表移除扩展
registry.remove(extension_id: str)

# 获取扩展元数据
metadata = registry.get(extension_id: str)  # Optional[dict]

# 列出所有扩展
extensions = registry.list()  # Dict[str, dict]

# 检查是否已安装
is_installed = registry.is_installed(extension_id: str)  # bool
```

**注册表格式**：

```json
{
  "schema_version": "1.0",
  "extensions": {
    "jira": {
      "version": "1.0.0",
      "source": "catalog",
      "manifest_hash": "sha256...",
      "enabled": true,
      "registered_commands": ["speckit.jira.specstoissues", ...],
      "installed_at": "2026-01-28T..."
    }
  }
}
```

### ExtensionManager

**模块**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionManager

manager = ExtensionManager(project_root)
```

**方法**：

```python
# 从目录安装
manifest = manager.install_from_directory(
    source_dir: Path,
    speckit_version: str,
    register_commands: bool = True
)  # 返回：ExtensionManifest

# 从 ZIP 安装
manifest = manager.install_from_zip(
    zip_path: Path,
    speckit_version: str
)  # 返回：ExtensionManifest

# 移除扩展
success = manager.remove(
    extension_id: str,
    keep_config: bool = False
)  # 返回：bool

# 列出已安装的扩展
extensions = manager.list_installed()  # List[Dict]

# 获取扩展清单
manifest = manager.get_extension(extension_id: str)  # Optional[ExtensionManifest]

# 检查兼容性
manager.check_compatibility(
    manifest: ExtensionManifest,
    speckit_version: str
)  # 不兼容时抛出 CompatibilityError
```

### CatalogEntry

**模块**：`specify_cli.extensions`

表示生效目录源栈中的单个目录源。

```python
from specify_cli.extensions import CatalogEntry

entry = CatalogEntry(
    url="https://example.com/catalog.json",
    name="default",
    priority=1,
    install_allowed=True,
    description="Built-in catalog of installable extensions",
)
```

**字段**：

| 字段 | 类型 | 说明 |
|-------|------|-------------|
| `url` | `str` | 目录源 URL（必须使用 HTTPS，localhost 可用 HTTP） |
| `name` | `str` | 人类可读的目录源名称 |
| `priority` | `int` | 排序序号（数字越小优先级越高，冲突时胜出） |
| `install_allowed` | `bool` | 是否允许安装来自该目录源的扩展 |
| `description` | `str` | 可选的人类可读目录源描述（默认：空） |

### ExtensionCatalog

**模块**：`specify_cli.extensions`

```python
from specify_cli.extensions import ExtensionCatalog

catalog = ExtensionCatalog(project_root)
```

**类属性**：

```python
ExtensionCatalog.DEFAULT_CATALOG_URL    # 默认目录源 URL
ExtensionCatalog.COMMUNITY_CATALOG_URL  # 社区目录源 URL
```

**方法**：

```python
# 获取按顺序排列的生效目录源列表
entries = catalog.get_active_catalogs()  # List[CatalogEntry]

# 获取目录源数据（主目录源，向后兼容）
catalog_data = catalog.fetch_catalog(force_refresh: bool = False)  # Dict

# 在所有生效的目录源中搜索扩展
# 每条结果都包含 _catalog_name 和 _install_allowed
results = catalog.search(
    query: Optional[str] = None,
    tag: Optional[str] = None,
    author: Optional[str] = None,
    verified_only: bool = False
)  # 返回：List[Dict]——每个 dict 都包含 _catalog_name、_install_allowed

# 获取扩展信息（搜索所有生效的目录源）
# 未找到时返回 None；结果包含 _catalog_name 和 _install_allowed
ext_info = catalog.get_extension_info(extension_id: str)  # Optional[Dict]

# 检查缓存有效性（主目录源）
is_valid = catalog.is_cache_valid()  # bool

# 清除所有目录源缓存
catalog.clear_cache()
```

**结果标注字段**：

`search()` 与 `get_extension_info()` 返回的每个扩展 dict 都包含：

| 字段 | 类型 | 说明 |
|-------|------|-------------|
| `_catalog_name` | `str` | 来源目录源的名称 |
| `_install_allowed` | `bool` | 是否允许从该目录源安装 |

**目录源配置文件**（`.specify/extension-catalogs.yml`）：

```yaml
catalogs:
  - name: "default"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json"
    priority: 1
    install_allowed: true
    description: "Built-in catalog of installable extensions"
  - name: "community"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json"
    priority: 2
    install_allowed: false
    description: "Community-contributed extensions (discovery only)"
```

### HookExecutor

**模块**：`specify_cli.extensions`

```python
from specify_cli.extensions import HookExecutor

hook_executor = HookExecutor(project_root)
```

**方法**：

```python
# 获取项目配置
config = hook_executor.get_project_config()  # Dict

# 保存项目配置
hook_executor.save_project_config(config: Dict)

# 注册钩子
hook_executor.register_hooks(manifest: ExtensionManifest)

# 注销钩子
hook_executor.unregister_hooks(extension_id: str)

# 获取某事件的钩子
hooks = hook_executor.get_hooks_for_event(event_name: str)  # List[Dict]

# 判断钩子是否应该执行
should_run = hook_executor.should_execute_hook(hook: Dict)  # bool

# 格式化钩子消息
message = hook_executor.format_hook_message(
    event_name: str,
    hooks: List[Dict]
)  # str
```

### CommandRegistrar

**模块**：`specify_cli.extensions`

```python
from specify_cli.extensions import CommandRegistrar

registrar = CommandRegistrar()
```

**方法**：

```python
# 为 Claude Code 注册命令
registered = registrar.register_commands_for_claude(
    manifest: ExtensionManifest,
    extension_dir: Path,
    project_root: Path
)  # 返回：List[str]（命令名）

# 解析 front matter
frontmatter, body = registrar.parse_frontmatter(content: str)

# 渲染 front matter
yaml_text = registrar.render_frontmatter(frontmatter: Dict)  # str
```

---

## 命令文件格式

### 通用命令格式

**文件**：`commands/{command-name}.md`

```markdown
---
description: "Command description"
tools:
  - 'mcp-server/tool_name'
  - 'other-mcp-server/other_tool'
---

# 命令标题

用 Markdown 编写的命令文档。

## 前置条件

1. 要求 1
2. 要求 2

## 用户输入

$ARGUMENTS

## 步骤

### 第 1 步：描述

指令文本……

\`\`\`bash
# Shell 命令
\`\`\`

### 第 2 步：另一个步骤

更多指令……

## 配置参考

关于配置选项的信息。

## 备注

其他备注与提示。
```

### Front matter 字段

```yaml
description: string   # 必填，简短的命令描述
tools: [string]       # 可选，所需的 MCP 工具
```

### 特殊变量

- `$ARGUMENTS`——用户提供参数的占位符
- 扩展上下文会被自动注入：

  ```markdown
  <!-- Extension: {extension-id} -->
  <!-- Config: .specify/extensions/{extension-id}/ -->
  ```

---

## 配置 Schema

### 扩展配置文件

**文件**：`.specify/extensions/{extension-id}/{extension-id}-config.yml`

扩展自行定义各自的配置 schema。常见模式：

```yaml
# 连接设置
connection:
  url: string
  api_key: string

# 项目设置
project:
  key: string
  workspace: string

# 功能开关
features:
  enabled: boolean
  auto_sync: boolean

# 默认值
defaults:
  labels: [string]
  assignee: string

# 自定义字段
field_mappings:
  internal_name: "external_field_id"
```

### 配置层级

1. **扩展默认值**（来自 `extension.yml` 的 `defaults` 小节）
2. **项目配置**（`{extension-id}-config.yml`）
3. **本地覆盖**（`{extension-id}-config.local.yml`，被 gitignore 忽略）
4. **环境变量**（`SPECKIT_{EXTENSION}_*`）

### 环境变量模式

格式：`SPECKIT_{EXTENSION}_{KEY}`

示例：

- `SPECKIT_JIRA_PROJECT_KEY`
- `SPECKIT_LINEAR_API_KEY`
- `SPECKIT_GITHUB_TOKEN`

---

## 钩子系统

### 钩子定义

每个事件接受单个钩子映射，或映射列表。列表可以在同一事件上注册多个命令。

**单个映射（extension.yml 中）**：

```yaml
hooks:
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    prompt: "Create Jira issues from tasks?"
    description: "Automatically create Jira hierarchy"
    condition: null
```

**带优先级的映射列表**：

```yaml
hooks:
  after_plan:
    - command: "speckit.my-ext.verify"
      priority: 5
      optional: false
      description: "Verify the plan"
    - command: "speckit.my-ext.report"
      priority: 10
      optional: true
      prompt: "Generate the report?"
      description: "Generate a report from the plan"
```

在同一个清单列表内，重复出现的 `command` 会按"后者胜出"（last wins）去重并移到列表末尾，因此在优先级相同时，它也会按书写顺序打破并列。

### 钩子事件

标准事件（由核心定义）：

- `before_specify`——规范生成之前
- `after_specify`——规范生成之后
- `before_plan`——实现规划之前
- `after_plan`——实现规划之后
- `before_tasks`——任务生成之前
- `after_tasks`——任务生成之后
- `before_implement`——实现之前
- `after_implement`——实现之后
- `before_analyze`——跨产物分析之前
- `after_analyze`——跨产物分析之后
- `before_checklist`——检查清单生成之前
- `after_checklist`——检查清单生成之后
- `before_clarify`——规范澄清之前
- `after_clarify`——规范澄清之后
- `before_constitution`——宪章更新之前
- `after_constitution`——宪章更新之后
- `before_taskstoissues`——任务转 issue 之前
- `after_taskstoissues`——任务转 issue 之后

### 钩子配置

**在 `.specify/extensions.yml` 中**：

```yaml
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"
      description: "..."
      condition: null
```

### 钩子消息格式

```markdown
## Extension Hooks

**Optional Hook**: {extension}
Command: `/{command}`
Description: {description}

Prompt: {prompt}
To execute: `/{command}`
```

强制钩子则为：

```markdown
**Automatic Hook**: {extension}
Executing: `/{command}`
EXECUTE_COMMAND: {command}
```

---

## CLI 命令

### extension list

**用法**：`specify extension list [OPTIONS]`

**选项**：

- `--available`——显示目录源中可用的扩展
- `--all`——同时显示已安装和可用的扩展

**输出**：已安装扩展的列表及其元数据

### extension catalog list

**用法**：`specify extension catalog list`

列出当前目录源栈中所有生效的目录源，显示名称、描述、URL、优先级和 `install_allowed` 状态。

### extension catalog add

**用法**：`specify extension catalog add URL [OPTIONS]`

**选项**：

- `--name NAME`——目录源名称（必填）
- `--priority INT`——优先级（数字越小优先级越高，默认：10）
- `--install-allowed / --no-install-allowed`——是否允许从该目录源安装（默认：false）
- `--description TEXT`——目录源的可选描述

**参数**：

- `URL`——目录源 URL（必须使用 HTTPS）

把目录源条目添加到 `.specify/extension-catalogs.yml`。

### extension catalog remove

**用法**：`specify extension catalog remove NAME`

**参数**：

- `NAME`——要移除的目录源名称

从 `.specify/extension-catalogs.yml` 中移除一个目录源条目。

### extension add

**用法**：`specify extension add EXTENSION [OPTIONS]`

**选项**：

- `--from URL`——从自定义 URL 安装
- `--dev PATH`——从本地目录安装

**参数**：

- `EXTENSION`——扩展名称或 URL

**注意**：来自 `install_allowed: false` 目录源的扩展无法通过此命令安装。

### extension remove

**用法**：`specify extension remove EXTENSION [OPTIONS]`

**选项**：

- `--keep-config`——保留配置文件
- `--force`——跳过确认

**参数**：

- `EXTENSION`——扩展 ID

### extension search

**用法**：`specify extension search [QUERY] [OPTIONS]`

同时搜索所有生效的目录源。结果包含来源目录源名称和 install_allowed 状态。

**选项**：

- `--tag TAG`——按标签过滤
- `--author AUTHOR`——按作者过滤
- `--verified`——只显示已验证（verified）的扩展

**参数**：

- `QUERY`——可选的搜索关键词

### extension info

**用法**：`specify extension info EXTENSION`

显示来源目录源和 install_allowed 状态。

**参数**：

- `EXTENSION`——扩展 ID

### extension update

**用法**：`specify extension update [EXTENSION]`

**参数**：

- `EXTENSION`——可选，扩展 ID（默认：全部）

### extension enable

**用法**：`specify extension enable EXTENSION`

**参数**：

- `EXTENSION`——扩展 ID

### extension disable

**用法**：`specify extension disable EXTENSION`

**参数**：

- `EXTENSION`——扩展 ID

---

## 异常

### ValidationError

扩展清单校验失败时抛出。

```python
from specify_cli.extensions import ValidationError

try:
    manifest = ExtensionManifest(path)
except ValidationError as e:
    print(f"Invalid manifest: {e}")
```

### CompatibilityError

扩展与当前 spec-kit 版本不兼容时抛出。

```python
from specify_cli.extensions import CompatibilityError

try:
    manager.check_compatibility(manifest, "0.1.0")
except CompatibilityError as e:
    print(f"Incompatible: {e}")
```

### ExtensionError

所有扩展相关错误的基类异常。

```python
from specify_cli.extensions import ExtensionError

try:
    manager.install_from_directory(path, "0.1.0")
except ExtensionError as e:
    print(f"Extension error: {e}")
```

---

## 版本函数

### version_satisfies

检查某个版本是否满足版本说明符。

```python
from specify_cli.extensions import version_satisfies

# 若 1.2.3 满足 >=1.0.0,<2.0.0 则为 True
satisfied = version_satisfies("1.2.3", ">=1.0.0,<2.0.0")  # bool
```

---

## 文件系统布局

```text
.specify/
├── extensions/
│   ├── .registry               # 扩展注册表（JSON）
│   ├── .cache/                 # 目录源缓存
│   │   ├── catalog.json
│   │   └── catalog-metadata.json
│   ├── .backup/                # 配置备份
│   │   └── {ext}-{config}.yml
│   ├── {extension-id}/         # 扩展目录
│   │   ├── extension.yml       # 清单
│   │   ├── {ext}-config.yml    # 用户配置
│   │   ├── {ext}-config.local.yml  # 本地覆盖（被 gitignore 忽略）
│   │   ├── {ext}-config.template.yml  # 模板
│   │   ├── commands/           # 命令文件
│   │   │   └── *.md
│   │   ├── scripts/            # 辅助脚本
│   │   │   └── *.sh
│   │   ├── docs/               # 文档
│   │   └── README.md
│   └── extensions.yml          # 项目扩展配置
└── scripts/                    # （spec-kit 已有）

.claude/
└── commands/
    └── speckit.{ext}.{cmd}.md  # 已注册的命令
```

---

*最后更新：2026-01-28*
*API 版本：1.0*
*Spec Kit 版本：0.1.0*
