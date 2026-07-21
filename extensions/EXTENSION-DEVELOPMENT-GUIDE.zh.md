<!-- zh-source: extensions/EXTENSION-DEVELOPMENT-GUIDE.md -->
<!-- zh-base: 309166e -->

# 扩展开发指南

创建 Spec Kit 扩展的指南。

---

## 快速上手

### 1. 创建扩展目录

```bash
mkdir my-extension
cd my-extension
```

### 2. 创建 `extension.yml` 清单（manifest）

```yaml
schema_version: "1.0"

extension:
  id: "my-ext"                          # 只能用小写字母、数字和连字符
  name: "My Extension"
  version: "1.0.0"                      # 语义化版本
  description: "My custom extension"
  author: "Your Name"
  repository: "https://github.com/you/spec-kit-my-ext"
  license: "MIT"

requires:
  speckit_version: ">=0.1.0"            # 最低 spec-kit 版本
  tools:                                # 可选：所需的外部工具
    - name: "my-tool"
      required: true
      version: ">=1.0.0"
  commands:                             # 可选：需要的核心命令
    - "speckit.tasks"

provides:
  commands:
    - name: "speckit.my-ext.hello"      # 必须符合模式：speckit.{ext-id}.{cmd}
      file: "commands/hello.md"
      description: "Say hello"
      aliases: ["speckit.my-ext.hi"]    # 可选别名，模式相同

  config:                               # 可选：配置文件
    - name: "my-ext-config.yml"
      template: "my-ext-config.template.yml"
      description: "Extension configuration"
      required: false

hooks:                                  # 可选：集成钩子
  after_tasks:
    command: "speckit.my-ext.hello"
    optional: true
    prompt: "Run hello command?"

tags:                                   # 可选：用于目录源搜索
  - "example"
  - "utility"
```

### 3. 创建 commands 目录

```bash
mkdir commands
```

### 4. 创建命令文件

**文件**：`commands/hello.md`

```markdown
---
description: "Say hello command"
tools:                              # 可选：此命令使用的 AI 工具
  - 'some-tool/function'
scripts:                            # 可选：辅助脚本
  sh: ../../scripts/bash/helper.sh
  ps: ../../scripts/powershell/helper.ps1
---

# Hello 命令

这个命令用来打招呼！

## 用户输入

$ARGUMENTS

## 步骤

1. 向用户问好
2. 展示扩展正常工作

```bash
echo "Hello from my extension!"
echo "Arguments: $ARGUMENTS"
```

## 扩展配置

从 `.specify/extensions/my-ext/my-ext-config.yml` 加载扩展配置。

### 5. 本地测试

```bash
cd /path/to/spec-kit-project
specify extension add --dev /path/to/my-extension
```

### 6. 验证安装

```bash
specify extension list

# 应显示：
#  ✓ My Extension (v1.0.0)
#     My custom extension
#     Commands: 1 | Hooks: 1 | Status: Enabled
```

### 7. 测试命令

如果使用 Claude：

```bash
claude
> /speckit.my-ext.hello world
```

该命令会出现在 `.claude/commands/speckit.my-ext.hello.md`。

---

## 清单 Schema 参考

### 必填字段

#### `schema_version`

扩展清单的 schema 版本。当前为：`"1.0"`

#### `extension`

扩展元数据块。

**必填子字段**：

- `id`：扩展标识符（小写字母、数字、连字符）
- `name`：人类可读的名称
- `version`：语义化版本（如 "1.0.0"）
- `description`：简短描述

**可选子字段**：

- `author`：扩展作者
- `repository`：源码 URL
- `license`：SPDX 许可证标识符
- `homepage`：扩展主页 URL

#### `requires`

兼容性要求。

**必填子字段**：

- `speckit_version`：语义化版本说明符（如 ">=0.1.0,<2.0.0"）

**可选子字段**：

- `tools`：所需的外部工具（工具对象数组）
- `commands`：需要的 spec-kit 核心命令（命令名数组）
- `scripts`：需要的核心脚本（脚本名数组）

#### `provides`

扩展提供的内容。

**可选子字段**：

- `commands`：命令对象数组（至少需要一个命令或钩子）

**命令对象**：

- `name`：命令名（必须符合 `speckit.{ext-id}.{command}`）
- `file`：命令文件路径（相对于扩展根目录）
- `description`：命令描述（可选）
- `aliases`：备用命令名（可选，数组；每一项都必须符合 `speckit.{ext-id}.{command}`）

### 可选字段

#### `hooks`

用于自动执行的集成钩子。

可用的钩子挂载点：

- `before_specify` / `after_specify`：规范生成之前/之后
- `before_plan` / `after_plan`：实现规划之前/之后
- `before_tasks` / `after_tasks`：任务生成之前/之后
- `before_implement` / `after_implement`：实现之前/之后
- `before_analyze` / `after_analyze`：跨产物分析之前/之后
- `before_checklist` / `after_checklist`：检查清单生成之前/之后
- `before_clarify` / `after_clarify`：规范澄清之前/之后
- `before_constitution` / `after_constitution`：宪章更新之前/之后
- `before_taskstoissues` / `after_taskstoissues`：任务转 issue 之前/之后

每个事件接受单个钩子对象，或钩子对象列表（在同一事件上挂多个命令）。

钩子对象：

- `command`：要执行的命令（通常来自 `provides.commands`，但也可以引用任何已注册的命令）
- `priority`：事件内的运行顺序（整数 ≥ 1，默认 10；数字越小越先运行；优先级相同时保持书写顺序）
- `optional`：为 true 时，执行前询问用户
- `prompt`：可选钩子的提示文本
- `description`：钩子描述
- `condition`：执行条件（未来功能）

#### `tags`

用于目录源发现的标签数组。

#### `defaults`

扩展配置的默认值。

#### `config_schema`

用于校验扩展配置的 JSON Schema。

---

## 命令文件格式

### Front matter（YAML）

```yaml
---
description: "Command description"          # 必填
tools:                                      # 可选
  - 'tool-name/function'
scripts:                                    # 可选
  sh: ../../scripts/bash/helper.sh
  ps: ../../scripts/powershell/helper.ps1
---
```

### 正文（Markdown）

使用标准 Markdown，配合特殊占位符：

- `$ARGUMENTS`：用户提供的参数
- `{SCRIPT}`：注册时会被替换为脚本路径

**示例**：

````markdown
## 步骤

1. 解析参数
2. 执行逻辑

```bash
args="$ARGUMENTS"
echo "Running with args: $args"
```
````

### 脚本路径重写

扩展命令使用相对路径，注册时会被重写：

**扩展中**：

```yaml
scripts:
  sh: ../../scripts/bash/helper.sh
```

**注册后**：

```yaml
scripts:
  sh: .specify/scripts/bash/helper.sh
```

这样脚本就能引用 spec-kit 的核心脚本。

---

## 配置文件

### 配置模板

**文件**：`my-ext-config.template.yml`

```yaml
# 我的扩展配置
# 把本文件复制为 my-ext-config.yml 并按需修改

# 示例配置
api:
  endpoint: "https://api.example.com"
  timeout: 30

features:
  feature_a: true
  feature_b: false

credentials:
  # 不要提交凭据！
  # 请改用环境变量
  api_key: "${MY_EXT_API_KEY}"
```

### 配置加载

在命令中按分层优先级加载配置：

1. 扩展默认值（`extension.yml` → `defaults`）
2. 项目配置（`.specify/extensions/my-ext/my-ext-config.yml`）
3. 本地覆盖（`.specify/extensions/my-ext/my-ext-config.local.yml`——被 gitignore 忽略）
4. 环境变量（`SPECKIT_MY_EXT_*`）

**加载脚本示例**：

```bash
#!/usr/bin/env bash
EXT_DIR=".specify/extensions/my-ext"

# 加载并合并配置
config=$(yq eval '.' "$EXT_DIR/my-ext-config.yml" -o=json)

# 应用环境变量覆盖
if [ -n "${SPECKIT_MY_EXT_API_KEY:-}" ]; then
  config=$(echo "$config" | jq ".api.api_key = \"$SPECKIT_MY_EXT_API_KEY\"")
fi

echo "$config"
```

---

## 用 `.extensionignore` 排除文件

扩展作者可以在扩展根目录创建 `.extensionignore` 文件，在用户通过 `specify extension add` 安装扩展时，把某些文件和文件夹排除在复制范围之外。这对于把仅开发用的文件（测试、CI 配置、文档源码等）挡在安装副本之外很有用。

### 格式

该文件使用与 `.gitignore` 兼容的模式（每行一条），由 [`pathspec`](https://pypi.org/project/pathspec/) 库驱动：

- 空行会被忽略
- 以 `#` 开头的行是注释
- `*` 匹配除 `/` 以外的任意内容（不跨目录边界）
- `**` 匹配零个或多个目录（例如 `docs/**/*.draft.md`）
- `?` 匹配除 `/` 以外的任意单个字符
- 末尾的 `/` 把模式限定为只匹配目录
- 包含 `/`（末尾斜杠除外）的模式锚定到扩展根目录
- 不含 `/` 的模式可在目录树的任意深度匹配
- `!` 反转先前排除的模式（重新纳入某个文件）
- 模式中的反斜杠会被规范化为正斜杠，以保证跨平台兼容
- `.extensionignore` 文件本身始终会被自动排除

### 示例

```gitignore
# .extensionignore

# 开发文件
tests/
.github/
.gitignore

# 构建产物
__pycache__/
*.pyc
dist/

# 文档源码（只保留构建好的 README）
docs/
CONTRIBUTING.md
```

### 模式匹配

| 模式 | 匹配 | 不匹配 |
|---------|---------|----------------|
| `*.pyc` | 任意目录下的任意 `.pyc` 文件 | — |
| `tests/` | `tests` 目录（及其全部内容） | 名为 `tests` 的文件 |
| `docs/*.draft.md` | `docs/api.draft.md`（直接位于 `docs/` 下） | `docs/sub/api.draft.md`（嵌套） |
| `.env` | 任意层级的 `.env` 文件 | — |
| `!README.md` | 重新纳入 `README.md`，即使它被更早的模式匹配过 | — |
| `docs/**/*.draft.md` | `docs/api.draft.md`、`docs/sub/api.draft.md` | — |

### 不支持的特性

以下 `.gitignore` 特性在此场景中**不适用**：

- **多个 `.extensionignore` 文件**：只支持扩展根目录下的单个文件（`.gitignore` 支持子目录中的文件）
- **`$GIT_DIR/info/exclude` 与 `core.excludesFile`**：这些是 Git 专有机制，这里没有对应物
- **在已排除目录内使用反选**：由于文件复制使用 `shutil.copytree`，排除一个目录会完全阻止递归进入该目录。反选模式无法重新纳入位于已排除目录内的文件。例如，先写 `tests/` 再写 `!tests/important.py` 的组合**不会**保留 `tests/important.py`——`tests/` 目录在根层级就被跳过，其内容根本不会被评估。绕过办法是逐项排除目录内容而不是目录本身（例如用 `tests/*.pyc` 和 `tests/.cache/` 代替 `tests/`）。

---

## 校验规则

### 扩展 ID

- **模式**：`^[a-z0-9-]+$`
- **有效**：`my-ext`、`tool-123`、`awesome-plugin`
- **无效**：`MyExt`（大写）、`my_ext`（下划线）、`my ext`（空格）

### 扩展版本

- **格式**：语义化版本（MAJOR.MINOR.PATCH）
- **有效**：`1.0.0`、`0.1.0`、`2.5.3`
- **无效**：`1.0`、`v1.0.0`、`1.0.0-beta`

### 命令名

- **模式**：`^speckit\.[a-z0-9-]+\.[a-z0-9-]+$`
- **有效**：`speckit.my-ext.hello`、`speckit.tool.cmd`
- **无效**：`my-ext.hello`（缺少前缀）、`speckit.hello`（没有扩展命名空间）

### 命令文件路径

- **必须**相对于扩展根目录
- **有效**：`commands/hello.md`、`commands/subdir/cmd.md`
- **无效**：`/absolute/path.md`、`../outside.md`

---

## 测试扩展

### 手动测试

1. **创建测试扩展**
2. **本地安装**：

   ```bash
   specify extension add --dev /path/to/extension
   ```

3. **验证安装**：

   ```bash
   specify extension list
   ```

4. 用你的 AI 智能体**测试命令**
5. **检查命令注册**：

   ```bash
   ls .claude/commands/speckit.my-ext.*
   ```

6. **移除扩展**：

   ```bash
   specify extension remove my-ext
   ```

### 自动化测试

为你的扩展编写测试：

```python
# tests/test_my_extension.py
import pytest
from pathlib import Path
from specify_cli.extensions import ExtensionManifest

def test_manifest_valid():
    """测试扩展清单有效。"""
    manifest = ExtensionManifest(Path("extension.yml"))
    assert manifest.id == "my-ext"
    assert len(manifest.commands) >= 1

def test_command_files_exist():
    """测试所有命令文件都存在。"""
    manifest = ExtensionManifest(Path("extension.yml"))
    for cmd in manifest.commands:
        cmd_file = Path(cmd["file"])
        assert cmd_file.exists(), f"Command file not found: {cmd_file}"
```

---

## 分发

### 方式 1：GitHub 仓库

1. **创建仓库**：`spec-kit-my-ext`
2. **添加文件**：

   ```text
   spec-kit-my-ext/
   ├── extension.yml
   ├── commands/
   ├── scripts/
   ├── docs/
   ├── README.md
   ├── LICENSE
   └── CHANGELOG.md
   ```

3. **创建 release**：打上版本 tag（如 `v1.0.0`）
4. **从仓库安装**：

   ```bash
   git clone https://github.com/you/spec-kit-my-ext
   specify extension add --dev spec-kit-my-ext/
   ```

### 方式 2：ZIP 压缩包（未来）

创建 ZIP 压缩包并托管在 GitHub Releases 上：

```bash
zip -r spec-kit-my-ext-1.0.0.zip extension.yml commands/ scripts/ docs/
```

用户这样安装：

```bash
specify extension add <extension-name> --from https://github.com/.../spec-kit-my-ext-1.0.0.zip
```

### 方式 3：社区参考目录源

提交到社区目录源，供公开发现：

1. 为你的扩展**创建一个 GitHub release**
2. 使用 [Extension Submission](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml) 模板**提交一个 issue**
3. **审核通过后**，维护者会更新目录源，你的扩展即可被使用：
   - 用户可以浏览 `catalog.community.json` 发现你的扩展
   - 用户把条目复制到自己的 `catalog.json`
   - 用户用 `specify extension add my-ext` 安装（从他们自己的目录源）

详细的提交说明见[扩展发布指南](EXTENSION-PUBLISHING-GUIDE.md)。

---

## 最佳实践

### 命名约定

- **扩展 ID**：使用描述性的连字符名称（用 `jira-integration`，不用 `ji`）
- **命令**：使用动词-名词模式（`create-issue`、`sync-status`）
- **配置文件**：与扩展 ID 保持一致（`jira-config.yml`）

### 文档

- **README.md**：概述、安装、用法
- **CHANGELOG.md**：版本历史
- **docs/**：详细指南
- **命令描述**：清晰、简洁

### 版本管理

- **遵循 SemVer**：`MAJOR.MINOR.PATCH`
- **MAJOR**：破坏性变更
- **MINOR**：新功能
- **PATCH**：bug 修复

### 安全

- **永不提交密钥**：使用环境变量
- **校验输入**：净化用户参数
- **说明权限**：写明会访问哪些文件/API

### 兼容性

- **指定版本范围**：不要要求精确版本
- **多版本测试**：确保兼容性
- **优雅降级**：处理缺失的功能

---

## 示例扩展

### 最小扩展

最小可行的扩展：

```yaml
# extension.yml
schema_version: "1.0"
extension:
  id: "minimal"
  name: "Minimal Extension"
  version: "1.0.0"
  description: "Minimal example"
requires:
  speckit_version: ">=0.1.0"
provides:
  commands:
    - name: "speckit.minimal.hello"
      file: "commands/hello.md"
```

````markdown
<!-- commands/hello.md -->
---
description: "Hello command"
---

# Hello World

```bash
echo "Hello, $ARGUMENTS!"
```
````

### 带配置的扩展

使用配置的扩展：

```yaml
# extension.yml
# ……元数据……
provides:
  config:
    - name: "tool-config.yml"
      template: "tool-config.template.yml"
      required: true
```

```yaml
# tool-config.template.yml
api_endpoint: "https://api.example.com"
timeout: 30
```

````markdown
<!-- commands/use-config.md -->
# 使用配置

加载配置：
```bash
config_file=".specify/extensions/tool/tool-config.yml"
endpoint=$(yq eval '.api_endpoint' "$config_file")
echo "Using endpoint: $endpoint"
```
````

### 带钩子的扩展

自动运行的扩展：

```yaml
# extension.yml
hooks:
  after_tasks:
    command: "speckit.auto.analyze"
    optional: false  # 总是运行
    description: "Analyze tasks after generation"
```

同一事件上的多个命令，按 `priority` 排序（数字越小越先运行）：

```yaml
# extension.yml
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

---

## 故障排查

### 扩展装不上

**错误**：`Invalid extension ID`

- **修复**：只使用小写字母、数字和连字符

**错误**：`Extension requires spec-kit >=0.2.0`

- **修复**：参照[升级指南](../docs/upgrade.md)升级 Spec Kit。`uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git` 仍可作为源码安装的备用方式。如果你从 PyPI 安装并希望继续沿用该方式，请参照 [PyPI 升级指引](../docs/install/pypi.md#upgrade)。

**错误**：`Command file not found`

- **修复**：确保命令文件位于清单中指定的路径

### 命令未注册

**症状**：命令没有出现在 AI 智能体中

**检查**：

1. `.claude/commands/` 目录存在
2. 扩展安装成功
3. 命令已写入注册表：

   ```bash
   cat .specify/extensions/.registry
   ```

**修复**：重新安装扩展以触发注册

### 配置加载不了

**检查**：

1. 配置文件存在：`.specify/extensions/{ext-id}/{ext-id}-config.yml`
2. YAML 语法有效：`yq eval '.' config.yml`
3. 环境变量设置正确

---

## 获取帮助

- **Issue**：在 GitHub 仓库报告 bug
- **讨论**：在 GitHub Discussions 提问
- **示例**：完整功能示例见 `spec-kit-jira`（Phase B）

---

## 下一步

1. 按照本指南**创建你的扩展**
2. 用 `--dev` 标志**本地测试**
3. **与社区分享**（GitHub、目录源）
4. 根据反馈**迭代**

祝扩展愉快！🚀
