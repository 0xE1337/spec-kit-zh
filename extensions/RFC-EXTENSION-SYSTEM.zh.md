<!-- zh-source: extensions/RFC-EXTENSION-SYSTEM.md -->
<!-- zh-base: 796b4f4 -->

# RFC：Spec Kit 扩展系统

**状态**：已实现（Implemented）
**作者**：Stats Perform Engineering
**创建日期**：2026-01-28
**更新日期**：2026-03-11

---

## 目录

1. [摘要](#摘要)
2. [动机](#动机)
3. [设计原则](#设计原则)
4. [架构概览](#架构概览)
5. [扩展清单规范](#扩展清单规范)
6. [扩展生命周期](#扩展生命周期)
7. [命令注册](#命令注册)
8. [配置管理](#配置管理)
9. [钩子系统](#钩子系统)
10. [扩展发现与目录源](#扩展发现与目录源)
11. [CLI 命令](#cli-命令)
12. [兼容性与版本管理](#兼容性与版本管理)
13. [安全考量](#安全考量)
14. [迁移策略](#迁移策略)
15. [实现阶段](#实现阶段)
16. [已解决的问题](#已解决的问题)
17. [未决问题（遗留）](#未决问题遗留)
18. [附录](#附录)

---

## 摘要

为 Spec Kit 引入一套扩展系统，以模块化的方式集成外部工具（Jira、Linear、Azure DevOps 等），同时不让核心框架变得臃肿。扩展是安装在 `.specify/extensions/` 中的自包含软件包，带有声明式清单，独立管理版本，并可通过中央目录源发现。

---

## 动机

### 当前问题

1. **单体式膨胀**：把 Jira 集成加进核心 spec-kit 会带来：
   - 影响所有用户的庞大配置文件
   - 让每个人都依赖 Jira MCP 服务器
   - 随着功能累积不断出现的合并冲突

2. **灵活性受限**：不同组织使用不同的工具：
   - GitHub Issues、Jira、Linear、Azure DevOps 各不相同
   - 还有自定义的内部工具
   - 不臃肿就无法全部支持

3. **维护负担**：每增加一个集成都会带来：
   - 文档复杂度上升
   - 测试矩阵扩张
   - 破坏性变更的暴露面变大

4. **社区参与阻力**：外部贡献者若不经过核心仓库的 PR 审批和发布周期，就无法轻松添加集成。

### 目标

1. **模块化**：核心 spec-kit 保持精简，扩展按需启用（opt-in）
2. **可扩展性**：为构建新集成提供清晰的 API
3. **独立性**：扩展独立于核心进行版本管理和发布
4. **可发现性**：通过中央目录源查找扩展
5. **安全性**：校验、兼容性检查、沙箱

---

## 设计原则

### 1. 约定优于配置（Convention Over Configuration）

- 标准目录结构（`.specify/extensions/{name}/`）
- 声明式清单（`extension.yml`）
- 可预测的命令命名（`speckit.{extension}.{command}`）

### 2. 故障安全的默认行为（Fail-Safe Defaults）

- 缺失的扩展优雅降级（跳过钩子）
- 无效的扩展只产生警告，不破坏核心功能
- 扩展故障与核心操作相互隔离

### 3. 向后兼容

- 核心命令保持不变
- 扩展只做加法（不修改核心）
- 旧项目不装扩展也能正常工作

### 4. 开发者体验

- 安装简单：`specify extension add jira`
- 兼容性问题有清晰的错误信息
- 支持本地开发模式来测试扩展

### 5. 安全优先

- 扩展与 AI 智能体运行在同一上下文中（信任边界）
- 清单校验用于防范恶意代码
- 官方扩展的签名验证（未来）

---

## 架构概览

### 目录结构

```text
project/
├── .specify/
│   ├── scripts/                 # 核心脚本（不变）
│   ├── templates/               # 核心模板（不变）
│   ├── memory/                  # 会话记忆
│   ├── extensions/              # 扩展目录（新增）
│   │   ├── .registry            # 已安装扩展的元数据（新增）
│   │   ├── jira/                # Jira 扩展
│   │   │   ├── extension.yml    # 清单
│   │   │   ├── jira-config.yml  # 扩展配置
│   │   │   ├── commands/        # 命令文件
│   │   │   ├── scripts/         # 辅助脚本
│   │   │   └── docs/            # 文档
│   │   └── linear/              # Linear 扩展（示例）
│   └── extensions.yml           # 项目级扩展配置（新增）
└── .gitignore                   # 忽略本地扩展配置
```

### 组件图

```text
┌─────────────────────────────────────────────────────────┐
│                    Spec Kit Core                        │
│  ┌──────────────────────────────────────────────────┐   │
│  │  CLI (specify)                                   │   │
│  │  - init, check                                   │   │
│  │  - extension add/remove/list/update  ← NEW       │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Extension Manager  ← NEW                        │   │
│  │  - Discovery, Installation, Validation           │   │
│  │  - Command Registration, Hook Execution          │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Core Commands                                   │   │
│  │  - /speckit.specify                              │   │
│  │  - /speckit.tasks                                │   │
│  │  - /speckit.implement                            │   │
│  └─────────┬────────────────────────────────────────┘   │
└────────────┼────────────────────────────────────────────┘
             │ Hook Points (after_tasks, after_implement)
             ↓
┌─────────────────────────────────────────────────────────┐
│                    Extensions                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Jira Extension                                  │   │
│  │  - /speckit.jira.specstoissues                   │   │
│  │  - /speckit.jira.discover-fields                 │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Linear Extension                                │   │
│  │  - /speckit.linear.sync                          │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
             │ Calls external tools
             ↓
┌─────────────────────────────────────────────────────────┐
│                    External Tools                       │
│  - Jira MCP Server                                      │
│  - Linear API                                           │
│  - GitHub API                                           │
└─────────────────────────────────────────────────────────┘
```

---

## 扩展清单规范

### Schema：`extension.yml`

```yaml
# 扩展清单 Schema v1.0
# 所有扩展必须在根目录包含此文件

# 用于兼容性判断的 schema 版本
schema_version: "1.0"

# 扩展元数据（必填）
extension:
  id: "jira"                    # 唯一标识符（小写字母、数字、连字符）
  name: "Jira Integration"      # 人类可读的名称
  version: "1.0.0"              # 语义化版本
  description: "Create Jira Epics, Stories, and Issues from spec-kit artifacts"
  author: "Stats Perform"       # 作者/组织
  repository: "https://github.com/statsperform/spec-kit-jira"
  license: "MIT"                # SPDX 许可证标识符
  homepage: "https://github.com/statsperform/spec-kit-jira/blob/main/README.md"

# 兼容性要求（必填）
requires:
  # Spec-kit 版本（语义化版本范围）
  speckit_version: ">=0.1.0,<2.0.0"

  # 扩展所需的外部工具
  tools:
    - name: "jira-mcp-server"
      required: true
      version: ">=1.0.0"          # 可选：版本约束
      description: "Jira MCP server for API access"
      install_url: "https://github.com/your-org/jira-mcp-server"
      check_command: "jira --version"  # 可选：用于验证的 CLI 命令

  # 该扩展依赖的核心 spec-kit 命令
  commands:
    - "speckit.tasks"             # 扩展需要 tasks 命令

  # 所需的核心脚本
  scripts:
    - "check-prerequisites.sh"

# 该扩展提供的内容（必填）
provides:
  # 添加到 AI 智能体的命令
  commands:
    - name: "speckit.jira.specstoissues"
      file: "commands/specstoissues.md"
      description: "Create Jira hierarchy from spec and tasks"
      aliases: ["speckit.jira.sync"]  # 备用名称

    - name: "speckit.jira.discover-fields"
      file: "commands/discover-fields.md"
      description: "Discover Jira custom fields for configuration"

    - name: "speckit.jira.sync-status"
      file: "commands/sync-status.md"
      description: "Sync task completion status to Jira"

  # 配置文件
  config:
    - name: "jira-config.yml"
      template: "jira-config.template.yml"
      description: "Jira integration configuration"
      required: true              # 使用前用户必须完成配置

  # 辅助脚本
  scripts:
    - name: "parse-jira-config.sh"
      file: "scripts/parse-jira-config.sh"
      description: "Parse jira-config.yml to JSON"
      executable: true            # 安装时赋予可执行权限

# 扩展配置默认值（可选）
defaults:
  project:
    key: null                     # 无默认值，用户必须配置
  hierarchy:
    issue_type: "subtask"
  update_behavior:
    mode: "update"
    sync_completion: true

# 用于校验的配置 schema（可选）
config_schema:
  type: "object"
  required: ["project"]
  properties:
    project:
      type: "object"
      required: ["key"]
      properties:
        key:
          type: "string"
          pattern: "^[A-Z]{2,10}$"
          description: "Jira project key (e.g., MSATS)"

# 集成钩子（可选）
hooks:
  # 在 /speckit.tasks 完成后触发的钩子
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    prompt: "Create Jira issues from tasks?"
    description: "Automatically create Jira hierarchy after task generation"

  # 在 /speckit.implement 完成后触发的钩子
  after_implement:
    command: "speckit.jira.sync-status"
    optional: true
    prompt: "Sync completion status to Jira?"

# 用于发现的标签（可选）
tags:
  - "issue-tracking"
  - "jira"
  - "atlassian"
  - "project-management"

# 变更日志 URL（可选）
changelog: "https://github.com/statsperform/spec-kit-jira/blob/main/CHANGELOG.md"

# 支持信息（可选）
support:
  documentation: "https://github.com/statsperform/spec-kit-jira/blob/main/docs/"
  issues: "https://github.com/statsperform/spec-kit-jira/issues"
  discussions: "https://github.com/statsperform/spec-kit-jira/discussions"
  email: "support@statsperform.com"
```

### 校验规则

1. **必须**包含 `schema_version`、`extension`、`requires`、`provides`
2. `version` **必须**遵循语义化版本
3. `id` **必须**唯一（不与其他扩展冲突）
4. **必须**声明所有外部工具依赖
5. 如果扩展使用配置，**应当**包含 `config_schema`
6. **应当**包含 `support` 信息
7. 命令的 `file` 路径**必须**相对于扩展根目录
8. 钩子的 `command` 名称**必须**与 `provides.commands` 中的某个命令匹配

---

## 扩展生命周期

### 1. 发现

```bash
specify extension search jira
# 在目录源中搜索匹配 "jira" 的扩展
```

**流程：**

1. 从 GitHub 拉取扩展目录源
2. 按搜索词过滤（名称、标签、描述）
3. 展示结果及其元数据

### 2. 安装

```bash
specify extension add jira
```

**流程：**

1. **解析**：在目录源中查找该扩展
2. **下载**：获取扩展包（来自 GitHub release 的 ZIP）
3. **校验**：检查清单 schema 与兼容性
4. **解压**：解包到 `.specify/extensions/jira/`
5. **配置**：复制配置模板
6. **注册**：把命令添加进 AI 智能体配置
7. **记录**：更新 `.specify/extensions/.registry`

**注册表格式**（`.specify/extensions/.registry`）：

```json
{
  "schema_version": "1.0",
  "extensions": {
    "jira": {
      "version": "1.0.0",
      "installed_at": "2026-01-28T14:30:00Z",
      "source": "catalog",
      "manifest_hash": "sha256:abc123...",
      "enabled": true,
      "priority": 10
    }
  }
}
```

**优先级字段**：扩展按 `priority` 排序（数字越小优先级越高）。默认值为 10。当多个扩展提供同名模板时，用于模板解析。

### 3. 配置

```bash
# 用户编辑扩展配置
vim .specify/extensions/jira/jira-config.yml
```

**配置发现顺序：**

1. 扩展默认值（`extension.yml` → `defaults`）
2. 项目配置（`jira-config.yml`）
3. 本地覆盖（`jira-config.local.yml`——被 gitignore 忽略）
4. 环境变量（`SPECKIT_JIRA_*`）

### 4. 使用

```bash
claude
> /speckit.jira.specstoissues
```

**命令解析：**

1. AI 智能体在 `.claude/commands/speckit.jira.specstoissues.md` 中找到命令
2. 命令文件引用扩展的脚本/配置
3. 扩展带着完整上下文执行

### 5. 更新

```bash
specify extension update jira
```

**流程：**

1. 检查目录源中是否有更新版本
2. 下载新版本
3. 校验兼容性
4. 备份当前配置
5. 解压新版本（保留配置）
6. 重新注册命令
7. 更新注册表

### 6. 移除

```bash
specify extension remove jira
```

**流程：**

1. 与用户确认（展示将被移除的内容）
2. 从 AI 智能体注销命令
3. 从 `.specify/extensions/jira/` 移除
4. 更新注册表
5. 可选：保留配置以便重装

---

## 命令注册

### 按智能体注册

扩展提供**通用命令格式**（基于 Markdown），CLI 在注册时将其转换为各智能体专属的格式。

#### 通用命令格式

**位置**：扩展的 `commands/specstoissues.md`

```markdown
---
# 通用元数据（所有智能体都会解析）
description: "Create Jira hierarchy from spec and tasks"
tools:
  - 'jira-mcp-server/epic_create'
  - 'jira-mcp-server/story_create'
scripts:
  sh: ../../scripts/bash/check-prerequisites.sh --json
  ps: ../../scripts/powershell/check-prerequisites.ps1 -Json
---

# Command implementation
## User Input
$ARGUMENTS

## Steps
1. Load jira-config.yml
2. Parse spec.md and tasks.md
3. Create Jira items
```

#### Claude Code 注册

**输出**：`.claude/commands/speckit.jira.specstoissues.md`

```markdown
---
description: "Create Jira hierarchy from spec and tasks"
tools:
  - 'jira-mcp-server/epic_create'
  - 'jira-mcp-server/story_create'
scripts:
  sh: .specify/scripts/bash/check-prerequisites.sh --json
  ps: .specify/scripts/powershell/check-prerequisites.ps1 -Json
---

# Command implementation (copied from extension)
## User Input
$ARGUMENTS

## Steps
1. Load jira-config.yml from .specify/extensions/jira/
2. Parse spec.md and tasks.md
3. Create Jira items
```

**转换：**

- 复制并调整 front matter
- 重写脚本路径（相对仓库根目录）
- 注入扩展上下文（配置位置）

#### Gemini CLI 注册

**输出**：`.gemini/commands/speckit.jira.specstoissues.toml`

```toml
[command]
name = "speckit.jira.specstoissues"
description = "Create Jira hierarchy from spec and tasks"

[command.tools]
tools = [
  "jira-mcp-server/epic_create",
  "jira-mcp-server/story_create"
]

[command.script]
sh = ".specify/scripts/bash/check-prerequisites.sh --json"
ps = ".specify/scripts/powershell/check-prerequisites.ps1 -Json"

[command.template]
content = """
# Command implementation
## User Input
{{args}}

## Steps
1. Load jira-config.yml from .specify/extensions/jira/
2. Parse spec.md and tasks.md
3. Create Jira items
"""
```

**转换：**

- 把 Markdown front matter 转换为 TOML
- 把 `$ARGUMENTS` 转换为 `{{args}}`
- 重写脚本路径

### 注册代码

**位置**：`src/specify_cli/extensions.py`

```python
def register_extension_commands(
    project_path: Path,
    ai_assistant: str,
    manifest: dict
) -> None:
    """把扩展命令注册到 AI 智能体。"""

    agent_config = AGENT_CONFIG.get(ai_assistant)
    if not agent_config:
        console.print(f"[yellow]Unknown agent: {ai_assistant}[/yellow]")
        return

    ext_id = manifest['extension']['id']
    ext_dir = project_path / ".specify" / "extensions" / ext_id
    agent_commands_dir = project_path / agent_config['folder'].rstrip('/') / "commands"
    agent_commands_dir.mkdir(parents=True, exist_ok=True)

    for cmd_info in manifest['provides']['commands']:
        cmd_name = cmd_info['name']
        source_file = ext_dir / cmd_info['file']

        if not source_file.exists():
            console.print(f"[red]Command file not found:[/red] {cmd_info['file']}")
            continue

        # 转换为智能体专属格式
        if ai_assistant == "claude":
            dest_file = agent_commands_dir / f"{cmd_name}.md"
            convert_to_claude(source_file, dest_file, ext_dir)
        elif ai_assistant == "gemini":
            dest_file = agent_commands_dir / f"{cmd_name}.toml"
            convert_to_gemini(source_file, dest_file, ext_dir)
        elif ai_assistant == "copilot":
            dest_file = agent_commands_dir / f"{cmd_name}.md"
            convert_to_copilot(source_file, dest_file, ext_dir)
        # ……其他智能体

        console.print(f"  ✓ Registered: {cmd_name}")

def convert_to_claude(
    source: Path,
    dest: Path,
    ext_dir: Path
) -> None:
    """把通用命令转换为 Claude 格式。"""

    # 解析通用命令
    content = source.read_text()
    frontmatter, body = parse_frontmatter(content)

    # 调整脚本路径（相对仓库根目录）
    if 'scripts' in frontmatter:
        for key in frontmatter['scripts']:
            frontmatter['scripts'][key] = adjust_path_for_repo_root(
                frontmatter['scripts'][key]
            )

    # 注入扩展上下文
    body = inject_extension_context(body, ext_dir)

    # 写入 Claude 命令
    dest.write_text(render_frontmatter(frontmatter) + "\n" + body)
```

---

## 配置管理

### 配置文件层级

```yaml
# .specify/extensions/jira/jira-config.yml（项目配置）
project:
  key: "MSATS"

hierarchy:
  issue_type: "subtask"

defaults:
  epic:
    labels: ["spec-driven", "typescript"]
```

```yaml
# .specify/extensions/jira/jira-config.local.yml（本地覆盖——被 gitignore 忽略）
project:
  key: "MYTEST"  # 本地测试用的覆盖值
```

```bash
# 环境变量（最高优先级）
export SPECKIT_JIRA_PROJECT_KEY="DEVTEST"
```

### 配置加载函数

**位置**：扩展命令（例如 `commands/specstoissues.md`）

````markdown
## 加载配置

1. 运行辅助脚本加载并合并配置：

```bash
config_json=$(bash .specify/extensions/jira/scripts/parse-jira-config.sh)
echo "$config_json"
```

1. 解析 JSON 并在后续步骤中使用
````

**脚本**：`.specify/extensions/jira/scripts/parse-jira-config.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

EXT_DIR=".specify/extensions/jira"
CONFIG_FILE="$EXT_DIR/jira-config.yml"
LOCAL_CONFIG="$EXT_DIR/jira-config.local.yml"

# 从 extension.yml 的默认值开始
defaults=$(yq eval '.defaults' "$EXT_DIR/extension.yml" -o=json)

# 合并项目配置
if [ -f "$CONFIG_FILE" ]; then
  project_config=$(yq eval '.' "$CONFIG_FILE" -o=json)
  defaults=$(echo "$defaults $project_config" | jq -s '.[0] * .[1]')
fi

# 合并本地配置
if [ -f "$LOCAL_CONFIG" ]; then
  local_config=$(yq eval '.' "$LOCAL_CONFIG" -o=json)
  defaults=$(echo "$defaults $local_config" | jq -s '.[0] * .[1]')
fi

# 应用环境变量覆盖
if [ -n "${SPECKIT_JIRA_PROJECT_KEY:-}" ]; then
  defaults=$(echo "$defaults" | jq ".project.key = \"$SPECKIT_JIRA_PROJECT_KEY\"")
fi

# 以 JSON 输出合并后的配置
echo "$defaults"
```

### 配置校验

**在命令文件中**：

````markdown
## 校验配置

1. 加载配置（来自上一步）
2. 按 extension.yml 中的 schema 校验：

```python
import jsonschema

schema = load_yaml(".specify/extensions/jira/extension.yml")['config_schema']
config = json.loads(config_json)

try:
    jsonschema.validate(config, schema)
except jsonschema.ValidationError as e:
    print(f"❌ Invalid jira-config.yml: {e.message}")
    print(f"   Path: {'.'.join(str(p) for p in e.path)}")
    exit(1)
```

1. 使用校验通过的配置继续
````

---

## 钩子系统

### 钩子定义

**在 extension.yml 中：**

```yaml
hooks:
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    prompt: "Create Jira issues from tasks?"
    description: "Automatically create Jira hierarchy"
    condition: "config.project.key is set"
```

### 钩子注册

**在扩展安装期间**，把钩子记录到项目配置中：

**文件**：`.specify/extensions.yml`（项目级扩展配置）

```yaml
# 本项目已安装的扩展
installed:
  - jira
  - linear

# 全局扩展设置
settings:
  auto_execute_hooks: true  # 命令结束后对可选钩子进行询问

# 钩子配置
hooks:
  after_tasks:
    - extension: jira
      command: speckit.jira.specstoissues
      enabled: true
      optional: true
      prompt: "Create Jira issues from tasks?"

  after_implement:
    - extension: jira
      command: speckit.jira.sync-status
      enabled: true
      optional: true
      prompt: "Sync completion status to Jira?"
```

### 钩子执行

**在核心命令中**（例如 `templates/commands/tasks.md`）：

添加在命令末尾：

````markdown
## 扩展钩子

任务生成完成后，检查已注册的钩子：

```bash
# 检查 extensions.yml 是否存在且包含 after_tasks 钩子
if [ -f ".specify/extensions.yml" ]; then
  # 解析 after_tasks 的钩子
  hooks=$(yq eval '.hooks.after_tasks[] | select(.enabled == true)' .specify/extensions.yml -o=json)

  if [ -n "$hooks" ]; then
    echo ""
    echo "📦 Extension hooks available:"

    # 逐个遍历钩子
    echo "$hooks" | jq -c '.' | while read -r hook; do
      extension=$(echo "$hook" | jq -r '.extension')
      command=$(echo "$hook" | jq -r '.command')
      optional=$(echo "$hook" | jq -r '.optional')
      prompt_text=$(echo "$hook" | jq -r '.prompt')

      if [ "$optional" = "true" ]; then
        # 询问用户
        echo ""
        read -p "$prompt_text (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          echo "▶ Executing: $command"
          # 让 AI 智能体执行该命令
          #（AI 智能体看到后就会执行）
          echo "EXECUTE_COMMAND: $command"
        fi
      else
        # 自动执行强制钩子
        echo "▶ Executing: $command (required)"
        echo "EXECUTE_COMMAND: $command"
      fi
    done
  fi
fi
```
````

**AI 智能体的处理：**

AI 智能体在输出中看到 `EXECUTE_COMMAND: speckit.jira.specstoissues`，就会自动调用该命令。

**替代方案**：在智能体上下文中直接调用（如果智能体支持）：

```python
# 在 AI 智能体的命令执行引擎中
def execute_command_with_hooks(command_name: str, args: str):
    # 执行主命令
    result = execute_command(command_name, args)

    # 检查钩子
    hooks = load_hooks_for_phase(f"after_{command_name}")
    for hook in hooks:
        if hook.optional:
            if confirm(hook.prompt):
                execute_command(hook.command, args)
        else:
            execute_command(hook.command, args)

    return result
```

### 钩子条件

扩展可以为钩子指定**条件**：

```yaml
hooks:
  after_tasks:
    command: "speckit.jira.specstoissues"
    optional: true
    condition: "config.project.key is set and config.enabled == true"
```

**条件求值**（在钩子执行器中）：

```python
def should_execute_hook(hook: dict, config: dict) -> bool:
    """求值钩子条件。"""
    condition = hook.get('condition')
    if not condition:
        return True  # 无条件 = 始终可执行

    # 简单表达式求值器
    # "config.project.key is set" → 检查 config['project']['key'] 是否存在
    # "config.enabled == true" → 检查 config['enabled'] 是否为 True

    return eval_condition(condition, config)
```

---

## 扩展发现与目录源

### 双目录源体系

Spec Kit 使用两个用途不同的目录源文件：

#### 用户目录源（`catalog.json`）

**URL**：`https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json`

- **用途**：组织自行策展、已批准扩展的目录源
- **默认状态**：有意留空——由用户填入自己信任的扩展
- **用法**：默认栈中的主目录源（优先级 1，`install_allowed: true`）
- **控制权**：各组织为自己的团队维护自己的 fork/版本

#### 社区参考目录源（`catalog.community.json`）

**URL**：`https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json`

- **用途**：社区贡献扩展的参考目录源
- **验证**：社区扩展最初可能是 `verified: false`
- **状态**：活跃——开放社区贡献
- **提交方式**：按照扩展发布指南通过 Pull Request 提交
- **用法**：默认栈中的次级目录源（优先级 2，`install_allowed: false`）——仅用于发现

**工作方式（默认栈）：**

1. **发现**：`specify extension search` 同时搜索两个目录源——社区扩展自动出现
2. **审查**：从安全性、质量和组织契合度评估社区扩展
3. **策展**：把批准的条目从社区目录源复制到你的 `catalog.json`，或以 `install_allowed: true` 添加进 `.specify/extension-catalogs.yml`
4. **安装**：使用 `specify extension add <name>`——只允许安装来自 `install_allowed: true` 目录源的扩展

这种方式让组织能完全掌控哪些扩展可以安装，同时开箱即用地提供社区可发现性。

### 目录源格式

**格式**（两个目录源相同）：

```json
{
  "schema_version": "1.0",
  "updated_at": "2026-01-28T14:30:00Z",
  "extensions": {
    "jira": {
      "name": "Jira Integration",
      "id": "jira",
      "description": "Create Jira Epics, Stories, and Issues from spec-kit artifacts",
      "author": "Stats Perform",
      "version": "1.0.0",
      "download_url": "https://github.com/statsperform/spec-kit-jira/releases/download/v1.0.0/spec-kit-jira-1.0.0.zip",
      "repository": "https://github.com/statsperform/spec-kit-jira",
      "homepage": "https://github.com/statsperform/spec-kit-jira/blob/main/README.md",
      "documentation": "https://github.com/statsperform/spec-kit-jira/blob/main/docs/",
      "changelog": "https://github.com/statsperform/spec-kit-jira/blob/main/CHANGELOG.md",
      "license": "MIT",
      "requires": {
        "speckit_version": ">=0.1.0,<2.0.0",
        "tools": [
          {
            "name": "jira-mcp-server",
            "version": ">=1.0.0"
          }
        ]
      },
      "tags": ["issue-tracking", "jira", "atlassian", "project-management"],
      "verified": true,
      "downloads": 1250,
      "stars": 45
    },
    "linear": {
      "name": "Linear Integration",
      "id": "linear",
      "description": "Sync spec-kit tasks with Linear issues",
      "author": "Community",
      "version": "0.9.0",
      "download_url": "https://github.com/example/spec-kit-linear/releases/download/v0.9.0/spec-kit-linear-0.9.0.zip",
      "repository": "https://github.com/example/spec-kit-linear",
      "requires": {
        "speckit_version": ">=0.1.0"
      },
      "tags": ["issue-tracking", "linear"],
      "verified": false
    }
  }
}
```

### 目录源发现命令

```bash
# 列出所有可用扩展
specify extension search

# 按关键词搜索
specify extension search jira

# 按标签搜索
specify extension search --tag issue-tracking

# 显示扩展详情
specify extension info jira
```

### 自定义目录源

Spec Kit 支持**目录源栈**——一个按顺序排列的目录源列表，CLI 会合并并跨源搜索。这让组织可以同时维护自己批准的扩展、内部目录源和社区发现渠道。

#### 目录源栈解析

生效的目录源栈按以下顺序解析（第一个匹配者胜出）：

1. **`SPECKIT_CATALOG_URL` 环境变量**——单一目录源，替换所有默认值（向后兼容）
2. **项目级 `.specify/extension-catalogs.yml`**——项目完全接管
3. **用户级 `~/.specify/extension-catalogs.yml`**——个人默认值
4. **内置默认栈**——`catalog.json`（install_allowed: true）+ `catalog.community.json`（install_allowed: false）

#### 默认内置栈

当没有配置文件时，CLI 使用：

| 优先级 | 目录源 | install_allowed | 用途 |
|----------|---------|-----------------|---------|
| 1 | `catalog.json`（默认） | `true` | 可供安装的策展扩展 |
| 2 | `catalog.community.json`（社区） | `false` | 仅用于发现——可浏览但不可安装 |

这意味着 `specify extension search` 开箱即可呈现社区扩展，而 `specify extension add` 仍然仅限安装来自 `install_allowed: true` 目录源的条目。

#### `.specify/extension-catalogs.yml` 配置文件

```yaml
catalogs:
  - name: "default"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.json"
    priority: 1          # 最高优先级——只有已批准的条目可以安装
    install_allowed: true
    description: "Built-in catalog of installable extensions"

  - name: "internal"
    url: "https://internal.company.com/spec-kit/catalog.json"
    priority: 2
    install_allowed: true
    description: "Internal company extensions"

  - name: "community"
    url: "https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json"
    priority: 3          # 最低优先级——仅用于发现，不可安装
    install_allowed: false
    description: "Community-contributed extensions (discovery only)"
```

用户级的等价文件位于 `~/.specify/extension-catalogs.yml`。当项目级配置存在且包含一个或多个目录源条目时，它将完全接管，内置默认值不再生效。空的 `catalogs: []` 列表与没有配置文件等同，会回退到默认值。

#### 目录源 CLI 命令

```bash
# 列出生效的目录源及其名称、URL、优先级和 install_allowed
specify extension catalog list

# 添加目录源（项目级）
specify extension catalog add --name "internal" --install-allowed \
  https://internal.company.com/spec-kit/catalog.json

# 添加仅发现的目录源
specify extension catalog add --name "community" \
  https://raw.githubusercontent.com/github/spec-kit/main/extensions/catalog.community.json

# 移除目录源
specify extension catalog remove internal

# 查看扩展来自哪个目录源
specify extension info jira
# → Source catalog: default
```

#### 合并冲突解决

当同一扩展 `id` 出现在多个目录源中时，优先级更高（priority 数字更小）的目录源胜出。较低优先级目录源中相同 `id` 的扩展会被忽略。

#### `install_allowed: false` 的行为

来自仅发现（discovery-only）目录源的扩展会显示在 `specify extension search` 结果中，但不能直接安装：

```
⚠  'linear' is available in the 'community' catalog but installation is not allowed from that catalog.

To enable installation, add 'linear' to an approved catalog (install_allowed: true) in .specify/extension-catalogs.yml.
```

#### `SPECKIT_CATALOG_URL`（向后兼容）

`SPECKIT_CATALOG_URL` 环境变量仍然有效——它被视为单个 `install_allowed: true` 的目录源，**替换两个默认目录源**，以保证完全向后兼容：

```bash
# 指向你组织的目录源
export SPECKIT_CATALOG_URL="https://internal.company.com/spec-kit/catalog.json"

# 所有扩展命令现在都使用你的自定义目录源
specify extension search       # 使用自定义目录源
specify extension add jira     # 从自定义目录源安装
```

**要求：**
- URL 必须使用 HTTPS（HTTP 仅允许用于 localhost 测试）
- 目录源必须遵循标准的 catalog.json schema
- 必须可公开访问，或在你的网络内可访问

**测试示例：**
```bash
# 开发期间用 localhost 测试
export SPECKIT_CATALOG_URL="http://localhost:8000/catalog.json"
specify extension search
```

---

## CLI 命令

### `specify extension` 子命令

#### `specify extension list`

列出当前项目中已安装的扩展。

```bash
$ specify extension list

Installed Extensions:
  ✓ Jira Integration (v1.0.0)
     jira
     Create Jira issues from spec-kit artifacts
     Commands: 3 | Hooks: 2 | Priority: 10 | Status: Enabled

  ✓ Linear Integration (v0.9.0)
     linear
     Create Linear issues from spec-kit artifacts
     Commands: 1 | Hooks: 1 | Priority: 10 | Status: Enabled
```

**选项：**

- `--available`：显示目录源中可用（未安装）的扩展
- `--all`：同时显示已安装和可用的扩展

#### `specify extension search [QUERY]`

搜索扩展目录源。

```bash
$ specify extension search jira

Found 1 extension:

┌─────────────────────────────────────────────────────────┐
│ jira (v1.0.0) ✓ Verified                                │
│ Jira Integration                                        │
│                                                         │
│ Create Jira Epics, Stories, and Issues from spec-kit   │
│ artifacts                                               │
│                                                         │
│ Author: Stats Perform                                   │
│ Tags: issue-tracking, jira, atlassian                   │
│ Downloads: 1,250                                        │
│                                                         │
│ Repository: github.com/statsperform/spec-kit-jira       │
│ Documentation: github.com/.../docs                      │
└─────────────────────────────────────────────────────────┘

Install: specify extension add jira
```

**选项：**

- `--tag TAG`：按标签过滤
- `--author AUTHOR`：按作者过滤
- `--verified`：只显示已验证（verified）的扩展

#### `specify extension info NAME`

显示某个扩展的详细信息。

```bash
$ specify extension info jira

Jira Integration (jira) v1.0.0

Description:
  Create Jira Epics, Stories, and Issues from spec-kit artifacts

Author: Stats Perform
License: MIT
Repository: https://github.com/statsperform/spec-kit-jira
Documentation: https://github.com/statsperform/spec-kit-jira/blob/main/docs/

Requirements:
  • Spec Kit: >=0.1.0,<2.0.0
  • Tools: jira-mcp-server (>=1.0.0)

Provides:
  Commands:
    • speckit.jira.specstoissues - Create Jira hierarchy from spec and tasks
    • speckit.jira.discover-fields - Discover Jira custom fields
    • speckit.jira.sync-status - Sync task completion status

  Hooks:
    • after_tasks - Prompt to create Jira issues
    • after_implement - Prompt to sync status

Tags: issue-tracking, jira, atlassian, project-management

Downloads: 1,250 | Stars: 45 | Verified: ✓

Install: specify extension add jira
```

#### `specify extension add NAME`

安装扩展。

```bash
$ specify extension add jira

Installing extension: Jira Integration

✓ Downloaded spec-kit-jira-1.0.0.zip (245 KB)
✓ Validated manifest
✓ Checked compatibility (spec-kit 0.1.0 ≥ 0.1.0)
✓ Extracted to .specify/extensions/jira/
✓ Registered 3 commands with claude
✓ Installed config template (jira-config.yml)

⚠  Configuration required:
   Edit .specify/extensions/jira/jira-config.yml to set your Jira project key

Extension installed successfully!

Next steps:
  1. Configure: vim .specify/extensions/jira/jira-config.yml
  2. Discover fields: /speckit.jira.discover-fields
  3. Use commands: /speckit.jira.specstoissues
```

**选项：**

- `--from URL`：从远程 URL（归档文件）安装。不直接接受 Git 仓库。
- `--dev`：以开发模式从本地路径安装（该路径就是位置参数 `extension` 本身）。
- `--priority NUMBER`：设置解析优先级（数字越小优先级越高，默认 10）

#### `specify extension remove NAME`

卸载扩展。

```bash
$ specify extension remove jira

⚠  This will remove:
   • 3 commands from AI agent
   • Extension directory: .specify/extensions/jira/
   • Config file: jira-config.yml (will be backed up)

Continue? (yes/no): yes

✓ Unregistered commands
✓ Backed up config to .specify/extensions/.backup/jira-config.yml
✓ Removed extension directory
✓ Updated registry

Extension removed successfully.

To reinstall: specify extension add jira
```

**选项：**

- `--keep-config`：不删除配置文件
- `--force`：跳过确认

#### `specify extension update [NAME]`

把扩展更新到最新版本。

```bash
$ specify extension update jira

Checking for updates...

jira: 1.0.0 → 1.1.0 available

Changes in v1.1.0:
  • Added support for custom workflows
  • Fixed issue with parallel tasks
  • Improved error messages

Update? (yes/no): yes

✓ Downloaded spec-kit-jira-1.1.0.zip
✓ Validated manifest
✓ Backed up current version
✓ Extracted new version
✓ Preserved config file
✓ Re-registered commands

Extension updated successfully!

Changelog: https://github.com/statsperform/spec-kit-jira/blob/main/CHANGELOG.md#v110
```

**选项：**

- `--all`：更新所有扩展
- `--check`：只检查更新，不安装
- `--force`：即使已是最新版本也强制更新

#### `specify extension enable/disable NAME`

启用或禁用扩展而不移除它。

```bash
$ specify extension disable jira

✓ Disabled extension: jira
  • Commands unregistered (but files preserved)
  • Hooks will not execute

To re-enable: specify extension enable jira
```

#### `specify extension set-priority NAME PRIORITY`

修改已安装扩展的解析优先级。

```bash
$ specify extension set-priority jira 5

✓ Extension 'Jira Integration' priority changed: 10 → 5

Lower priority = higher precedence in template resolution
```

**优先级取值：**

- 数字越小优先级越高（解析时先被检查）
- 默认优先级为 10
- 必须是正整数（1 或更大）

**适用场景：**

- 确保关键扩展的模板优先生效
- 当多个扩展提供相似模板时，覆盖默认的解析顺序

---

## 兼容性与版本管理

### 语义化版本

扩展遵循 [SemVer 2.0.0](https://semver.org/)：

- **MAJOR**：破坏性变更（命令 API 变更、配置 schema 变更）
- **MINOR**：新功能（新命令、新配置项）
- **PATCH**：缺陷修复（无 API 变更）

### 兼容性检查

**安装时：**

```python
def check_compatibility(extension_manifest: dict) -> bool:
    """检查扩展是否与当前环境兼容。"""

    requires = extension_manifest['requires']

    # 1. 检查 spec-kit 版本
    current_speckit = get_speckit_version()  # 例如 "0.1.5"
    required_speckit = requires['speckit_version']  # 例如 ">=0.1.0,<2.0.0"

    if not version_satisfies(current_speckit, required_speckit):
        raise IncompatibleVersionError(
            f"Extension requires spec-kit {required_speckit}, "
            f"but {current_speckit} is installed. "
            f"Upgrade spec-kit with: uv tool install specify-cli --force"
        )

    # 2. 检查所需工具
    for tool in requires.get('tools', []):
        tool_name = tool['name']
        tool_version = tool.get('version')

        if tool.get('required', True):
            if not check_tool(tool_name):
                raise MissingToolError(
                    f"Extension requires tool: {tool_name}\n"
                    f"Install from: {tool.get('install_url', 'N/A')}"
                )

            if tool_version:
                installed = get_tool_version(tool_name, tool.get('check_command'))
                if not version_satisfies(installed, tool_version):
                    raise IncompatibleToolVersionError(
                        f"Extension requires {tool_name} {tool_version}, "
                        f"but {installed} is installed"
                    )

    # 3. 检查所需命令
    for cmd in requires.get('commands', []):
        if not command_exists(cmd):
            raise MissingCommandError(
                f"Extension requires core command: {cmd}\n"
                f"Update spec-kit to latest version"
            )

    return True
```

### 弃用策略

**扩展清单可以把特性标记为已弃用：**

```yaml
provides:
  commands:
    - name: "speckit.jira.old-command"
      file: "commands/old-command.md"
      deprecated: true
      deprecated_message: "Use speckit.jira.new-command instead"
      removal_version: "2.0.0"
```

**运行时显示警告：**

```text
⚠️  Warning: /speckit.jira.old-command is deprecated
   Use /speckit.jira.new-command instead
   This command will be removed in v2.0.0
```

---

## 安全考量

### 信任模型

扩展以**与 AI 智能体相同的权限**运行：

- 可以执行 shell 命令
- 可以读写项目中的文件
- 可以发起网络请求

**信任边界**：用户必须信任扩展的作者。

### 验证

**已验证扩展**（目录源中标注）：

- 由知名组织发布（GitHub、Stats Perform 等）
- 代码经过 spec-kit 维护者审查
- 在目录源中带有 ✓ 徽章

**社区扩展**：

- 未经验证，使用风险自负
- 安装时显示警告：

  ```text
  ⚠️  This extension is not verified.
     Review code before installing: https://github.com/...

     Continue? (yes/no):
  ```

### 沙箱（未来）

**Phase 2**（不在首个发布中）：

- 扩展在清单中声明所需权限
- CLI 强制执行权限边界
- 权限示例：`filesystem:read`、`network:external`、`env:read`

```yaml
# 未来的 extension.yml
permissions:
  - "filesystem:read:.specify/extensions/jira/"  # 只能读取自己的配置
  - "filesystem:write:.specify/memory/"          # 可以写入 memory 目录
  - "network:external:*.atlassian.net"           # 可以调用 Jira API
  - "env:read:SPECKIT_JIRA_*"                    # 可以读取自己的环境变量
```

### 软件包完整性

**未来**：用 GPG/Sigstore 为扩展包签名

```yaml
# catalog.json
"jira": {
  "download_url": "...",
  "checksum": "sha256:abc123...",
  "signature": "https://github.com/.../spec-kit-jira-1.0.0.sig",
  "signing_key": "https://github.com/statsperform.gpg"
}
```

CLI 在解压前验证签名。

---

## 迁移策略

### 向后兼容

**目标**：现有 spec-kit 项目无需任何改动即可继续工作。

**策略**：

1. **核心命令不变**：`/speckit.tasks`、`/speckit.implement` 等继续留在核心中

2. **扩展可选**：用户按需启用扩展

3. **渐进迁移**：现有的 `taskstoissues` 保留在核心中，Jira 扩展作为替代方案

4. **弃用时间表**：
   - **v0.2.0**：引入扩展系统，保留核心 `taskstoissues`
   - **v0.3.0**：把核心 `taskstoissues` 标记为 "legacy"（仍然可用）
   - **v1.0.0**：考虑移除核心 `taskstoissues`，改用扩展

### 用户迁移路径

**场景 1**：用户从未使用 `taskstoissues`

- 无需迁移，扩展本就是按需启用

**场景 2**：用户使用核心 `taskstoissues`（GitHub Issues）

- 照常工作
- 可选：迁移到 `github-projects` 扩展以获得更多功能

**场景 3**：用户需要 Jira（新需求）

- `specify extension add jira`
- 配置后即可使用

**场景 4**：用户有调用 `taskstoissues` 的自定义脚本

- 脚本仍然可用（核心命令保留）
- 迁移指南会说明如何改为调用扩展命令

### 扩展迁移指南

**面向扩展作者**（当核心命令转为扩展时）：

```bash
# 旧（核心命令）
/speckit.taskstoissues

# 新（扩展命令）
specify extension add github-projects
/speckit.github.taskstoissues
```

**迁移别名**（如有需要）：

```yaml
# extension.yml
provides:
  commands:
    - name: "speckit.github.taskstoissues"
      file: "commands/taskstoissues.md"
      aliases: ["speckit.github.sync-taskstoissues"]  # 备用的带命名空间入口
```

AI 智能体会同时注册两个名称，因此调用方可以迁移到备用别名，而不必依赖 `/speckit.taskstoissues` 这类已弃用的全局快捷方式。

---

## 实现阶段

### Phase 1：核心扩展系统 ✅ 已完成

**目标**：基础的扩展设施

**交付物**：

- [x] 扩展清单 schema（`extension.yml`）
- [x] 扩展目录结构
- [x] CLI 命令：
  - [x] `specify extension list`
  - [x] `specify extension add`（从 URL 与本地 `--dev`）
  - [x] `specify extension remove`
- [x] 扩展注册表（`.specify/extensions/.registry`）
- [x] 命令注册（Claude 及 15+ 其他智能体）
- [x] 基础校验（清单 schema、兼容性）
- [x] 文档（扩展开发指南）

**测试**：

- [x] 清单解析的单元测试
- [x] 集成测试：安装虚拟扩展
- [x] 集成测试：向 Claude 注册命令

### Phase 2：Jira 扩展 ✅ 已完成

**目标**：第一个生产级扩展

**交付物**：

- [x] 创建 `spec-kit-jira` 仓库
- [x] 把 Jira 功能移植为扩展
- [x] 创建 `jira-config.yml` 模板
- [x] 命令：
  - [x] `specstoissues.md`
  - [x] `discover-fields.md`
  - [x] `sync-status.md`
- [x] 辅助脚本
- [x] 文档（README、配置指南、示例）
- [x] 发布 v3.0.0

**测试**：

- [x] 在 `eng-msa-ts` 项目上测试
- [x] 验证 spec→Epic、phase→Story、task→Issue 的映射
- [x] 测试配置加载与校验
- [x] 测试自定义字段的应用

### Phase 3：扩展目录源 ✅ 已完成

**目标**：发现与分发

**交付物**：

- [x] 中央目录源（spec-kit 仓库中的 `extensions/catalog.json`）
- [x] 社区目录源（`extensions/catalog.community.json`）
- [x] 支持多目录源的拉取与解析
- [x] CLI 命令：
  - [x] `specify extension search`
  - [x] `specify extension info`
  - [x] `specify extension catalog list`
  - [x] `specify extension catalog add`
  - [x] `specify extension catalog remove`
- [x] 文档（如何发布扩展）

**测试**：

- [x] 测试目录源拉取
- [x] 测试扩展搜索/过滤
- [x] 测试目录源缓存
- [x] 测试多目录源按优先级合并

### Phase 4：高级特性 ✅ 已完成

**目标**：钩子、更新、多智能体支持

**交付物**：

- [x] 钩子系统（extension.yml 中的 `hooks`）
- [x] 钩子注册与执行
- [x] 项目扩展配置（`.specify/extensions.yml`）
- [x] CLI 命令：
  - [x] `specify extension update`（带原子备份/恢复）
  - [x] `specify extension enable/disable`
- [x] 面向多智能体的命令注册（15+ 智能体，包括 Claude、Copilot、Gemini、Cursor 等）
- [x] 扩展更新通知（版本比较）
- [x] 配置层级解析（项目、本地、环境变量）

**超出原 RFC 额外实现的特性**：

- [x] **显示名称解析**：所有命令除 ID 外还接受扩展的显示名称
- [x] **歧义名称处理**：多个扩展匹配同一名称时给出用户友好的表格
- [x] **原子更新与回滚**：完整备份扩展目录、命令、钩子和注册表，失败时自动回滚
- [x] **安装前 ID 校验**：安装前校验 ZIP 中的扩展 ID（安全性）
- [x] **启用状态保留**：被禁用的扩展在更新后保持禁用
- [x] **注册表更新/恢复方法**：为启用/禁用与回滚操作提供整洁的 API
- [x] **目录源错误兜底**：目录源不可用时 `extension info` 回退到本地信息
- [x] **`_install_allowed` 标志**：仅发现的目录源不能用于安装
- [x] **缓存失效**：`SPECKIT_CATALOG_URL` 变化时缓存自动失效

**测试**：

- [x] 测试核心命令中的钩子
- [x] 测试扩展更新（保留配置）
- [x] 测试多智能体注册
- [x] 测试更新失败时的原子回滚
- [x] 测试启用状态保留
- [x] 测试显示名称解析

### Phase 5：打磨与文档 ✅ 已完成

**目标**：生产可用

**交付物**：

- [x] 全面的文档：
  - [x] 用户指南（EXTENSION-USER-GUIDE.md）
  - [x] 扩展开发指南（EXTENSION-DEV-GUIDE.md）
  - [x] 扩展 API 参考（EXTENSION-API-REFERENCE.md）
- [x] 错误消息与校验改进
- [x] CLI 帮助文本更新

**测试**：

- [x] 在多个项目上的端到端测试
- [x] 163 个单元测试通过

---

## 已解决的问题

原 RFC 中的以下问题已在实现过程中解决：

### 1. 扩展命名空间 ✅ 已解决

**问题**：扩展命令是否应使用命名空间前缀？

**决定**：**方案 C**——同时支持前缀命名与别名。命令使用 `speckit.{extension}.{command}` 作为规范名称，并可在清单中定义可选别名。

**实现**：`extension.yml` 中的 `aliases` 字段允许扩展注册额外的命令名称。

---

### 2. 配置文件位置 ✅ 已解决

**问题**：扩展配置应放在哪里？

**决定**：**方案 A**——扩展目录（`.specify/extensions/{ext-id}/{ext-id}-config.yml`）。这让扩展保持自包含、更易管理。

**实现**：每个扩展在自己的目录中拥有自己的配置文件，并采用分层解析（默认值 → 项目 → 本地 → 环境变量）。

---

### 3. 命令文件格式 ✅ 已解决

**问题**：扩展应使用通用格式还是智能体专属格式？

**决定**：**方案 A**——通用 Markdown 格式。扩展只写一次命令，CLI 在注册时转换为各智能体专属格式。

**实现**：`CommandRegistrar` 类负责转换为 15+ 种智能体格式（Claude、Copilot、Gemini、Cursor 等）。

---

### 4. 钩子执行模型 ✅ 已解决

**问题**：钩子应如何执行？

**决定**：**方案 A**——钩子注册在 `.specify/extensions.yml` 中，当 AI 智能体看到钩子触发标记时由其执行。钩子状态（启用/禁用）按扩展管理。

**实现**：`HookExecutor` 类管理 extensions.yml 中的钩子注册与状态。

---

### 5. 扩展分发 ✅ 已解决

**问题**：扩展应如何打包？

**决定**：**方案 A**——从 GitHub release 下载的 ZIP 归档（通过目录源的 `download_url`）。本地开发使用 `--dev` 标志加目录路径。

**实现**：`ExtensionManager.install_from_zip()` 处理 ZIP 解压与校验。

---

### 6. 多版本支持 ✅ 已解决

**问题**：同一扩展的多个版本能否共存？

**决定**：**方案 A**——仅支持单一版本。更新会替换现有版本，失败时原子回滚。

**实现**：`extension update` 执行原子备份/恢复，确保更新安全。

---

## 未决问题（遗留）

### 1. 沙箱/权限（未来）

**问题**：扩展是否应声明所需权限？

**选项**：

- A) 无沙箱（现状）：扩展以与 AI 智能体相同的权限运行
- B) 权限声明：扩展声明 `filesystem:read`、`network:external` 等
- C) 可选沙箱：组织可以启用权限强制执行

**状态**：推迟到未来版本。目前采用基于信任的模型，由用户信任扩展作者。

---

### 2. 软件包签名（未来）

**问题**：扩展是否应进行加密签名？

**选项**：

- A) 无签名（现状）：信任基于目录源来源
- B) GPG/Sigstore 签名：验证软件包完整性
- C) 目录源级验证：由目录源维护者验证软件包

**状态**：推迟到未来版本。目录源 schema 中已有 `checksum` 字段，但未强制执行。

---

## 附录

### 附录 A：示例扩展结构

**`spec-kit-jira` 扩展的完整结构：**

```text
spec-kit-jira/
├── README.md                        # 概览、特性、安装
├── LICENSE                          # MIT 许可证
├── CHANGELOG.md                     # 版本历史
├── .gitignore                       # 忽略本地配置
│
├── extension.yml                    # 扩展清单（必需）
├── jira-config.template.yml         # 配置模板
│
├── commands/                        # 命令文件
│   ├── specstoissues.md            # 主命令
│   ├── discover-fields.md          # 辅助命令：发现自定义字段
│   └── sync-status.md              # 辅助命令：同步完成状态
│
├── scripts/                         # 辅助脚本
│   ├── parse-jira-config.sh        # 配置加载器（bash）
│   ├── parse-jira-config.ps1       # 配置加载器（PowerShell）
│   └── validate-jira-connection.sh # 连接测试
│
├── docs/                            # 文档
│   ├── installation.md             # 安装指南
│   ├── configuration.md            # 配置参考
│   ├── usage.md                    # 用法示例
│   ├── troubleshooting.md          # 常见问题
│   └── examples/
│       ├── eng-msa-ts-config.yml   # 真实项目配置示例
│       └── simple-project.yml      # 最小配置示例
│
├── tests/                           # 测试（可选）
│   ├── test-extension.sh           # 扩展校验
│   └── test-commands.sh            # 命令执行测试
│
└── .github/                         # GitHub 集成
    └── workflows/
        └── release.yml              # 自动化发布
```

### 附录 B：扩展开发指南（大纲）

**创建新扩展的文档：**

1. **入门**
   - 前置条件（所需工具）
   - 扩展模板（cookiecutter）
   - 目录结构

2. **扩展清单**
   - Schema 参考
   - 必填与可选字段
   - 版本管理准则

3. **命令开发**
   - 通用命令格式
   - front matter 规范
   - 模板变量
   - 脚本引用

4. **配置**
   - 配置文件结构
   - Schema 校验
   - 分层配置解析
   - 环境变量覆盖

5. **钩子**
   - 可用的钩子挂载点
   - 钩子注册
   - 条件执行
   - 最佳实践

6. **测试**
   - 本地开发环境
   - 用 `--dev` 标志测试
   - 校验检查清单
   - 集成测试

7. **发布**
   - 打包（ZIP 格式）
   - GitHub release
   - 目录源提交
   - 版本管理策略

8. **示例**
   - 最小扩展
   - 带钩子的扩展
   - 带配置的扩展
   - 多命令扩展

### 附录 C：兼容性矩阵

**计划的支持矩阵：**

| 扩展特性 | Spec Kit 版本 | AI 智能体支持 |
|-------------------|------------------|------------------|
| 基础命令 | 0.2.0+ | Claude、Gemini、Copilot |
| 钩子（after_tasks） | 0.3.0+ | Claude、Gemini |
| 配置校验 | 0.2.0+ | 全部 |
| 多目录源 | 0.4.0+ | 全部 |
| 权限（沙箱） | 1.0.0+ | 待定 |

### 附录 D：扩展目录源 Schema

**`catalog.json` 的完整 schema：**

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["schema_version", "updated_at", "extensions"],
  "properties": {
    "schema_version": {
      "type": "string",
      "pattern": "^\\d+\\.\\d+$"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    },
    "extensions": {
      "type": "object",
      "patternProperties": {
        "^[a-z0-9-]+$": {
          "type": "object",
          "required": ["name", "id", "version", "download_url", "repository"],
          "properties": {
            "name": { "type": "string" },
            "id": { "type": "string", "pattern": "^[a-z0-9-]+$" },
            "description": { "type": "string" },
            "author": { "type": "string" },
            "version": { "type": "string", "pattern": "^\\d+\\.\\d+\\.\\d+$" },
            "download_url": { "type": "string", "format": "uri" },
            "repository": { "type": "string", "format": "uri" },
            "homepage": { "type": "string", "format": "uri" },
            "documentation": { "type": "string", "format": "uri" },
            "changelog": { "type": "string", "format": "uri" },
            "license": { "type": "string" },
            "requires": {
              "type": "object",
              "properties": {
                "speckit_version": { "type": "string" },
                "tools": {
                  "type": "array",
                  "items": {
                    "type": "object",
                    "required": ["name"],
                    "properties": {
                      "name": { "type": "string" },
                      "version": { "type": "string" }
                    }
                  }
                }
              }
            },
            "tags": {
              "type": "array",
              "items": { "type": "string" }
            },
            "verified": { "type": "boolean" },
            "downloads": { "type": "integer" },
            "stars": { "type": "integer" },
            "checksum": { "type": "string" }
          }
        }
      }
    }
  }
}
```

---

## 总结与后续步骤

本 RFC 为 Spec Kit 提出了一套完整的扩展系统，它：

1. **保持核心精简**，同时支持不设上限的集成
2. **支持多种智能体**（Claude、Gemini、Copilot 等）
3. **为社区贡献提供清晰的扩展 API**
4. **支持扩展与核心的独立版本管理**
5. **包含安全机制**（校验、兼容性检查）

### 近期后续步骤

1. 与利益相关方**评审本 RFC**
2. 就未决问题**收集反馈**
3. 根据反馈**完善设计**
4. **进入 Phase A**：实现核心扩展系统
5. **然后 Phase B**：构建 Jira 扩展作为概念验证

---

## 讨论问题

1. 扩展架构是否满足你对 Jira 集成的需求？
2. 是否还有其他应该考虑的钩子挂载点？
3. 我们是否应支持扩展间依赖（扩展 A 依赖扩展 B）？
4. 应如何处理扩展的弃用或从目录源中移除？
5. v1.0 需要什么级别的沙箱/权限？
