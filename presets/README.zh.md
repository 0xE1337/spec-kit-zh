<!-- zh-source: presets/README.md -->
<!-- zh-base: 0f26551 -->

# 预设

预设是可叠加、按优先级排序的模板与命令覆盖集合，用于定制 Spec Kit。它既能定制规范驱动开发工作流产出的产物（规范、计划、任务清单、检查清单、宪章），也能定制引导 LLM 生成这些产物的命令——而无需 fork 或修改核心文件。

## 工作原理

当 Spec Kit 需要某个模板（例如 `spec-template`）时，它会遍历一个解析栈：

1. `.specify/templates/overrides/` —— 项目本地的一次性覆盖
2. `.specify/presets/<preset-id>/templates/` —— 已安装的预设（按优先级排序）
3. `.specify/extensions/<ext-id>/templates/` —— 扩展提供的模板
4. `.specify/templates/` —— Spec Kit 自带的核心模板

如果没有安装任何预设，就使用核心模板——行为与预设功能出现之前完全一致。

模板解析发生在**运行时**——虽然安装时预设文件会被复制到 `.specify/presets/<id>/`，但 Spec Kit 在每次查找模板时都会遍历解析栈，而不是把模板合并到同一个位置。

详细的解析与命令注册流程见 [ARCHITECTURE.md](ARCHITECTURE.md)。

## 命令覆盖

预设还可以覆盖引导 SDD 工作流的命令。模板定义产出的是*什么*（规范、计划、宪章）；命令定义 LLM *如何*产出它们（分步指令）。

与模板不同，命令覆盖在**安装时**生效。当预设包含 `type: "command"` 条目时，这些命令会以正确的格式（Markdown 或 TOML，带相应的参数占位符）注册到所有检测到的智能体目录（`.claude/commands/`、`.gemini/commands/` 等）。移除预设时，已注册的命令会被清理。

## 快速上手

```bash
# 搜索可用预设
specify preset search

# 从目录源安装预设
specify preset add healthcare-compliance

# 从本地目录安装（用于开发）
specify preset add --dev ./my-preset

# 以指定优先级安装（数字越小优先级越高）
specify preset add healthcare-compliance --priority 5

# 列出已安装的预设
specify preset list

# 查看某个名称会解析到哪个模板
specify preset resolve spec-template

# 查看某个预设的详细信息
specify preset info healthcare-compliance

# 移除预设
specify preset remove healthcare-compliance
```

## 叠加预设

可以同时安装多个预设。当两个预设提供同一个模板时，`--priority` 标志决定谁胜出（数字越小优先级越高）：

```bash
specify preset add enterprise-safe --priority 10      # 基础层
specify preset add healthcare-compliance --priority 5  # 覆盖 enterprise-safe
specify preset add pm-workflow --priority 1            # 覆盖以上所有
```

预设**默认是覆盖**，不做合并。如果两个预设都以默认的 `replace` 策略提供 `spec-template`，优先级数字最小的那个整体胜出。不过，预设也可以使用**组合策略**来增强而不是替换内容。

### 组合策略

预设可以为每个模板声明一个 `strategy`，控制内容的组合方式。`name` 字段标识在优先级栈中与哪个模板组合，`file` 字段指向实际的内容文件（可以不同于约定路径 `templates/<name>.md`）：

```yaml
provides:
  templates:
    - type: "template"
      name: "spec-template"
      file: "templates/spec-addendum.md"
      strategy: "append"        # 在核心模板之后追加内容
```

| 策略 | 说明 |
|----------|-------------|
| `replace`（默认） | 完全替换低优先级模板 |
| `prepend` | 把内容放在解析出的低优先级模板**之前**，用空行分隔 |
| `append` | 把内容放在解析出的低优先级模板**之后**，用空行分隔 |
| `wrap` | 内容中包含 `{CORE_TEMPLATE}` 占位符（脚本用 `$CORE_SCRIPT`），占位符会被低优先级内容替换 |

**支持的组合：**

| 类型 | `replace` | `prepend` | `append` | `wrap` |
|------|-----------|-----------|----------|--------|
| **template** | ✓（默认） | ✓ | ✓ | ✓ |
| **command** | ✓（默认） | ✓ | ✓ | ✓ |
| **script** | ✓（默认） | — | — | ✓ |

多个使用组合策略的预设会递归串联。例如，一个使用 `prepend` 的安全预设加一个使用 `append` 的合规预设，最终产出：安全头部 + 核心内容 + 合规尾部。

## 目录源管理

预设通过目录源来发现。默认情况下，Spec Kit 使用官方目录源和社区目录源：

> [!NOTE]
> 社区预设由各自的作者独立创建和维护。维护者只验证目录源条目完整且格式正确——他们**不会审查、审计、背书或支持预设代码本身**。安装前请审查预设的源码，使用风险自行判断。

```bash
# 列出生效的目录源
specify preset catalog list

# 添加自定义目录源
specify preset catalog add https://example.com/catalog.json --name my-org --install-allowed

# 移除目录源
specify preset catalog remove my-org
```

## 创建预设

[scaffold/](scaffold/) 提供了一个可以复制的脚手架，用来创建你自己的预设。

1. 把 `scaffold/` 复制到新目录
2. 编辑 `preset.yml`，填入你的预设元数据
3. 在 `templates/` 中添加或替换模板
4. 用 `specify preset add --dev .` 本地测试
5. 用 `specify preset resolve spec-template` 验证

## 环境变量

| 变量 | 说明 | 默认值 |
|----------|-------------|---------|
| `SPECKIT_PRESET_CATALOG_URL` | 用单个 URL 覆盖整个目录源栈（替换所有默认值） | 内置默认栈 |
| `GH_TOKEN` / `GITHUB_TOKEN` | 用于向 GitHub 托管的 URL（`raw.githubusercontent.com`、`github.com`、`api.github.com`、`codeload.github.com`）发起认证请求的 GitHub 令牌。当你的目录源 JSON 或预设 ZIP 托管在私有 GitHub 仓库时必需。 | 无 |

#### 示例：使用私有 GitHub 托管的目录源

```bash
# 用令牌认证（gh CLI、PAT 或 CI 中的 GITHUB_TOKEN）
export GITHUB_TOKEN=$(gh auth token)

# 在通过 `specify preset catalog add` 添加的私有目录源中搜索
specify preset search my-template

# 从私有目录源安装
specify preset add my-template
```

令牌会自动附加到指向 GitHub 域名的请求上。非 GitHub 的目录源 URL 始终以无凭据方式获取。

## 配置文件

| 文件 | 作用域 | 说明 |
|------|-------|-------------|
| `.specify/preset-catalogs.yml` | 项目 | 当前项目的自定义目录源栈 |
| `~/.specify/preset-catalogs.yml` | 用户 | 所有项目的自定义目录源栈 |

## 未来考虑

以下增强正在考虑加入未来版本：

- **结构化合并策略** —— 解析 Markdown 章节，实现按章节粒度的组合（例如"只替换 ## Security"）。
- **冲突检测** —— 用 `specify preset lint` / `specify preset doctor` 检测组合冲突。
