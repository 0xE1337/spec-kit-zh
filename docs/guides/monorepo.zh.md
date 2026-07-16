<!-- zh-source: docs/guides/monorepo.md -->
<!-- zh-base: 4905668 -->

# 在 Monorepo 中使用 Spec Kit

Spec Kit 项目以**目录为作用域**：哪个目录包含 `.specify/`，哪个目录就是项目。一个 monorepo（单仓多项目）可以在同一个仓库根目录下容纳多个相互独立的 Spec Kit 项目，每个项目都有自己的 `.specify/`、`specs/`、宪章和功能编号。

根目录解析本来就优先选择**最近的** `.specify/`，而不是 Git 顶层目录，因此在成员项目内部运行的命令会解析到该项目，而不是仓库根目录。

## 布局

```text
my-monorepo/
├── .git/                     # 根目录只有一个 Git 仓库
├── apps/
│   ├── web/
│   │   └── .specify/         # Spec Kit 项目 "web"
│   │       └── memory/constitution.md
│   └── api/
│       └── .specify/         # Spec Kit 项目 "api"
│           └── memory/constitution.md
└── packages/
    └── ui/
        └── .specify/         # Spec Kit 项目 "ui"
```

独立初始化每个成员项目：

```bash
specify init apps/web --integration claude
specify init apps/api --integration claude
```

每个项目维护自己的 `specs/` 目录，并独立进行功能编号（`apps/web/specs/001-…`、`apps/api/specs/001-…`）。

## 在成员项目内部工作

默认工作流不变：进入项目目录，然后运行斜杠命令。根目录解析会找到最近的 `.specify/`。

```bash
cd apps/web
# 然后在你的智能体里运行 /speckit.specify、/speckit.plan 等命令
```

## 从仓库根目录指向某个成员项目

对于不方便 `cd` 的非交互式或 CI 运行，把 **`SPECIFY_INIT_DIR`** 设置为成员项目的根目录（即*包含* `.specify/` 的那个目录）。相对路径基于当前目录解析。

```bash
# 从 monorepo 根目录操作 apps/web（无需 cd）
export SPECIFY_INIT_DIR=apps/web
```

该路径必须存在且包含 `.specify/`。否则命令会**直接报错，不会回退**到当前目录或 Git 顶层目录。这是有意为之：一个笔误永远不会把规范写进错误的项目。不存在的路径按你输入的原样报告；存在但不是 Spec Kit 项目的路径按解析后的绝对路径报告：

```text
# SPECIFY_INIT_DIR=apps/wbe  （笔误：目录不存在）
ERROR: SPECIFY_INIT_DIR does not point to an existing directory: apps/wbe

# SPECIFY_INIT_DIR=apps  （目录存在，但自身没有 .specify/）
ERROR: SPECIFY_INIT_DIR is not a Spec Kit project (no .specify/ directory): /home/you/my-monorepo/apps
```

`SPECIFY_INIT_DIR` 选择**项目**；`SPECIFY_FEATURE_DIRECTORY` 选择项目内的**功能**。两者可以组合：同时设置即可非交互式地选定项目和功能。完整契约和双轴模型见 [`SPECIFY_INIT_DIR` 参考](../reference/core.md#environment-variables)。

`specify` CLI 的项目作用域子命令同样遵守这个变量，因此它们也能从根目录指向成员项目而无需 `cd`：

```bash
export SPECIFY_INIT_DIR=apps/web
specify workflow list          # 列出 apps/web 的工作流
specify integration status     # 报告 apps/web 的集成情况
```

校验规则相同：路径必须存在且包含 `.specify/`，不会回退到当前目录。

## `SPECIFY_INIT_DIR` 如何传递给你的智能体

`SPECIFY_INIT_DIR` 由斜杠命令调用的 shell 脚本读取（Bash 中是 `get_repo_root`，PowerShell 中是 `Get-RepoRoot`）。只有当它存在于运行这些脚本的 shell 环境中时才会生效。

- **脚本 / CI 运行：** 在驱动这些命令的同一个 shell 中 export 它；这种场景下它是可靠的。
- **交互式智能体：** export 的变量能否传递到智能体使用的 shell 工具，取决于具体的智能体。请在启动智能体*之前* export `SPECIFY_INIT_DIR`，并验证一次（例如运行 `/speckit.specify`，确认新功能落在了预期项目的 `specs/` 下）。

## Monorepo 中的 Git

> [!NOTE]
> Spec Kit 项目文件的作用域是**解析出的项目根目录**，但 Git 操作仍然在所属的 Git 工作树中执行。在根目录只有一个 Git 仓库、项目位于子目录的 monorepo 中，创建功能分支会在共享的根仓库中创建或切换分支。规范目录仍位于所选成员项目之下，而 Git 分支命名空间由整个 monorepo 共享。请在仓库根目录管理分支和 commit；如果想要按项目隔离的分支命名空间，可以为每个成员项目单独初始化 Git。

## 宪章

每个成员项目都有自己的 `.specify/memory/constitution.md`，`/speckit.constitution` 编辑的是本地项目的文件。Spec Kit 不提供内置的基础宪章/继承机制；如果你想让某个宪章引用 monorepo 中其他位置的共享规则，需要自己维护这层关联。否则，请按项目复制或同步共享的工程规则。
