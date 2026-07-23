<!-- zh-source: docs/reference/extensions.md -->
<!-- zh-base: b6b3ec4 -->

# 扩展

扩展为 Spec Kit 增加新能力——领域专属命令、外部工具集成、质量关卡等等。它们引入超出内置规范驱动开发工作流的新命令和模板。

## 搜索可用扩展

```bash
specify extension search [query]
```

| 选项 | 说明 |
| ------------ | ------------------------------------ |
| `--tag`      | 按标签过滤 |
| `--author`   | 按作者过滤 |
| `--verified` | 只显示已验证（verified）的扩展 |

在所有生效的目录源中搜索匹配查询的扩展。不带查询时，列出所有可用扩展。

## 安装扩展

```bash
specify extension add <name>
```

| 选项 | 说明 |
| --------------- | -------------------------------------------------------- |
| `--dev`         | 从本地目录安装（用于开发） |
| `--from <url>`  | 从自定义 URL 安装，而不是目录源 |
| `--force`       | 扩展已安装时覆盖安装 |
| `--priority <N>`| 解析优先级（默认 10；数字越小优先级越高） |

从目录源、URL 或本地目录安装扩展。扩展的命令会自动注册到当前安装的 AI 编码智能体集成。

> **注意：** 所有扩展命令都要求项目已经用 `specify init` 初始化过。

## 移除扩展

```bash
specify extension remove <name>
```

| 选项 | 说明 |
| --------------- | ---------------------------------------------- |
| `--keep-config` | 移除时保留配置文件 |
| `--force`       | 跳过确认提示 |

移除一个已安装的扩展。配置文件默认会被备份；使用 `--keep-config` 原地保留配置，或用 `--force` 跳过确认。

## 列出已安装的扩展

```bash
specify extension list
```

| 选项 | 说明 |
| ------------- | -------------------------------------------------- |
| `--available` | 显示可用（未安装）的扩展 |
| `--all`       | 同时显示已安装和可用的扩展 |

列出已安装的扩展及其状态、版本和命令数量。

## 扩展详情

```bash
specify extension info <name>
```

显示某个已安装或可用扩展的详细信息，包括描述、版本、命令和配置。

## 更新扩展

```bash
specify extension update [<name>]
```

更新指定扩展；不给名称时，更新所有已安装的扩展。

## 启用 / 禁用扩展

```bash
specify extension enable <name>
specify extension disable <name>
```

禁用扩展而不移除它。被禁用的扩展不会被加载，其命令也不可用。用 `enable` 重新启用。

## 设置扩展优先级

```bash
specify extension set-priority <name> <priority>
```

修改扩展的解析优先级。当多个扩展提供同名命令时，优先级数字最小的扩展胜出。

## 目录源管理

扩展目录源决定 `search` 和 `add` 从哪里查找扩展。目录源按优先级顺序检查（数字越小优先级越高）。

### 列出目录源

```bash
specify extension catalog list
```

显示栈中所有生效的目录源及其优先级和安装权限。

### 添加目录源

```bash
specify extension catalog add <url>
```

| 选项 | 说明 |
| ------------------------------------ | -------------------------------------------------- |
| `--name <name>`                      | 必填。目录源的唯一名称 |
| `--priority <N>`                     | 优先级（默认 10；数字越小优先级越高） |
| `--install-allowed / --no-install-allowed` | 是否允许从这个目录源安装扩展 |
| `--description <text>`               | 可选描述 |

把目录源添加到项目的 `.specify/extension-catalogs.yml`。

### 移除目录源

```bash
specify extension catalog remove <name>
```

从项目配置中移除一个目录源。

### 目录源解析顺序

目录源按以下顺序解析（第一个匹配者胜出）：

1. **环境变量** —— `SPECKIT_CATALOG_URL` 覆盖所有目录源
2. **项目配置** —— `.specify/extension-catalogs.yml`
3. **用户配置** —— `~/.specify/extension-catalogs.yml`
4. **内置默认值** —— 官方目录源 + 社区目录源

`.specify/extension-catalogs.yml` 示例：

```yaml
catalogs:
  - name: "my-org-catalog"
    url: "https://example.com/catalog.json"
    priority: 5
    install_allowed: true
    description: "Our approved extensions"
```

## 扩展配置

大多数扩展在其安装目录中包含配置文件：

```text
.specify/extensions/<ext>/
├── <ext>-config.yml           # 项目配置（纳入版本控制）
├── <ext>-config.local.yml     # 本地覆盖（被 gitignore 忽略）
└── <ext>-config.template.yml  # 模板参考
```

配置按以下顺序合并（越靠后优先级越高）：

1. **扩展默认值**（来自 `extension.yml`）
2. **项目配置**（`<ext>-config.yml`）
3. **本地覆盖**（`<ext>-config.local.yml`）
4. **环境变量**（`SPECKIT_<EXT>_*`）

要为新安装的扩展建立配置，复制模板即可：

```bash
cp .specify/extensions/<ext>/<ext>-config.template.yml \
   .specify/extensions/<ext>/<ext>-config.yml
```
## 项目级扩展与钩子配置

Spec Kit 把项目级的扩展注册与钩子配置存储在：

```text
.specify/extensions.yml
```
该文件包含已安装的扩展、全局设置，以及在 Spec Kit 命令之前或之后展示的钩子。

```yaml
installed:
  - git
  - my-extension

settings:
  auto_execute_hooks: true

hooks:
  before_implement:
    - extension: git
      command: speckit.git.commit
      enabled: true
      optional: true
      priority: 10
      prompt: "Commit outstanding changes before implementation?"
      description: "Auto-commit before implementation"

  after_implement:
    - extension: my-extension
      command: speckit.my-extension.verify
      enabled: true
      optional: false
      priority: 5
      description: "Run verification after implementation"
```

### 配置字段

顶层的 `installed` 列表记录项目中已安装的扩展。`settings` 映射存储项目级的扩展设置，`hooks` 按事件分组钩子注册。

`auto_execute_hooks` 默认为 `true`，但目前是保留字段，展示或调用钩子时并不会读取它。

每个钩子条目支持以下字段：

| 字段 | 说明 |
| --- | --- |
| `extension` | 注册该钩子的扩展 ID。 |
| `command` | 与钩子关联的扩展命令。 |
| `enabled` | 钩子是否激活。`enabled: false` 的钩子会被跳过。 |
| `optional` | 钩子是否可选。为 `true` 时，钩子会连同其 `prompt` 一起展示且可以跳过；为 `false` 时，钩子作为自动钩子输出（带 `EXECUTE_COMMAND` 标记）。 |
| `priority` | 钩子的优先级元数据。已注册的钩子条目使用 >= 1 的整数值；从清单（manifest）安装的条目在未声明优先级时默认为 `10`。当前的命令模板按 YAML 中的配置顺序展示钩子，不会按 `priority` 排序。 |
| `prompt` | 询问是否运行可选钩子时显示的消息。 |
| `description` | 钩子作用的人类可读说明。 |
| `condition` | 可选表达式，由 `HookExecutor` 求值（使用 `config.<path>` 或 `env.<VAR>`，配合 `is set`、`==` 或 `!=`）。当前的命令模板不求值条件，会跳过带非空条件的钩子。 |
钩子事件名标识钩子的触发时机。一般使用 `before_<command>` 或 `after_<command>` 形式，例如 `before_implement`、`after_implement`、`before_tasks` 和 `after_tasks`。

扩展清单在安装期间会拒绝无效的钩子优先级。对于已存在的 `.specify/extensions.yml` 条目，`HookExecutor.get_hooks_for_event()` 借助 `normalize_priority()` 排序：缺失值、布尔值、被 `int()` 拒绝的非数字值，以及小于 `1` 的值都回退到 `10`；数字字符串和有限浮点数会经 `int()` 强制转换，而非有限浮点数（non-finite float）不受支持，可能直接失败而非回退。

`HookExecutor.get_hooks_for_event()` 返回按 `priority` 排序的钩子，数值小的在前。不过，当前的命令模板直接读取钩子列表，按 YAML 中的配置顺序展示，而不使用优先级排序。

## 常见问题

### 为什么用 `search` 找不到某个扩展？

检查扩展名称的拼写。该扩展可能还没发布，也可能在你尚未添加的目录源中。用 `specify extension catalog list` 查看当前生效的目录源。

### 为什么扩展命令没有出现在我的 AI 编码智能体里？

用 `specify extension list` 确认扩展已安装并启用。如果显示为已安装，重启你的 AI 编码智能体——它可能需要重新加载才能生效。

### 如何建立扩展配置？

复制扩展自带的配置模板：

```bash
cp .specify/extensions/<ext>/<ext>-config.template.yml \
   .specify/extensions/<ext>/<ext>-config.yml
```

配置层级与覆盖细节见[扩展配置](#扩展配置)。

### 如何解决版本不兼容错误？

把 Spec Kit 更新到扩展要求的版本。

### 扩展由谁维护？

大多数扩展由各自的作者独立创建和维护。Spec Kit 维护者不会审查、审计、背书或支持扩展代码。安装前请审查扩展的源码，使用风险自行判断。特定扩展的问题请联系其作者，或在该扩展的仓库中提交 issue。
