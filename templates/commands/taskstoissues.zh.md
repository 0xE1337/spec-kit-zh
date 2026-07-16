---
description: 基于现有的设计产物，把已有任务转换为可执行、按依赖排序的 GitHub issue。
tools: ['github/github-mcp-server/list_issues', 'github/github-mcp-server/issue_write']
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
  py: scripts/python/check_prerequisites.py --json --require-tasks --include-tasks
---

<!-- zh-source: templates/commands/taskstoissues.md -->
<!-- zh-base: 55da30c -->

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑上述用户输入（如果不为空）。

## 执行前检查

**检查扩展钩子（任务转 issue 之前）**：
- 检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.before_taskstoissues` 键下的条目
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并正常继续
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选前置钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```
  - **强制钩子**（`optional: false`）：
    ```
    ## 扩展钩子

    **自动前置钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}

    等待钩子命令的结果返回后，再继续进入"概要"。
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。
- 如果没有注册任何钩子，或 `.specify/extensions.yml` 不存在，则静默跳过

## 概要

1. 在仓库根目录运行 `{SCRIPT}`，解析 FEATURE_DIR 和 AVAILABLE_DOCS 列表。所有路径必须是绝对路径。参数中包含单引号时（如 "I'm Groot"），使用转义语法：例如 'I'\''m Groot'（或在可能时改用双引号："I'm Groot"）。
1. **如果存在**：加载 `/memory/constitution.md`，获取项目原则与治理约束。
1. 从已执行脚本的输出中提取 **tasks** 的路径。
1. 运行以下命令获取 Git 远程地址：

```bash
git config --get remote.origin.url
```

> [!CAUTION]
> 只有当远程地址是 GitHub URL 时，才能继续执行后续步骤

1. **获取现有 issue 用于去重**：在创建任何内容之前，先从 `tasks.md` 构建你即将处理的任务 ID 集合（每个 ID 是 `T` 后跟三位数字，例如 `T001`）。然后使用 GitHub MCP 服务器的 `list_issues` 工具查找已经覆盖这些 ID 的 issue。不要传入 `state` 值，因为省略它会让工具同时返回打开和已关闭的 issue。请求 `perPage: 100` 以减少调用次数；由于该工具使用基于游标的分页，用 `after` 参数（取上一个响应中的 `endCursor`）请求后续页。对每个 issue 标题，按任务 ID 模式 `\bT\d{3}\b` 进行匹配（带词边界，避免把 `ST001` 或 `T0010` 这类 token 误匹配；这同样能识别写成 `T001 ...`、`T001: ...` 或 `[T001] ...` 的标题）；当它匹配到你的某个任务 ID 时，把该 ID 标记为已有 issue。一旦所有任务 ID 都已匹配，或没有更多分页，就立即停止分页，避免在所有任务 ID 都已确认后继续拉取整个仓库的 issue 历史。这样既限制了在 issue 历史庞大的仓库上的调用次数，又能在 `tasks.md` 重新生成或技能被重新调用后再次运行本命令时防止重复创建。
1. 对列表中的每个任务，使用 GitHub MCP 服务器在与 Git 远程地址对应的仓库中创建一个新 issue。`tasks.md` 中的任务行以 markdown 复选框开头，因此先去掉行首的 `- [ ]`（以及任何 `[P]` / `[US#]` 标记），还原出任务 ID 及其描述。用 `T001: <description>` 形式的单一规范标题创建 issue——ID 只写一次，后跟任务描述（例如，`- [ ] T001 创建项目结构` 这一行会生成标题 `T001: 创建项目结构`）。
   - **跳过**其 ID 已存在于上一步现有 issue 集合中的任务，并进行报告（例如 `T001 已有对应 issue，跳过`）。
   - 只为尚无匹配 issue 的任务创建 issue。

> [!CAUTION]
> 任何情况下都绝对不要在与远程 URL 不匹配的仓库中创建 issue

## 执行后检查

**检查扩展钩子（任务转 issue 之后）**：
检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.after_taskstoissues` 键下的条目
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并正常继续
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```
  - **强制钩子**（`optional: false`）：
    ```
    ## 扩展钩子

    **自动钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。
- 如果没有注册任何钩子，或 `.specify/extensions.yml` 不存在，则静默跳过
