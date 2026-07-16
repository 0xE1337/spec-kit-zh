---
description: 通过处理并执行 tasks.md 中定义的所有任务来执行实现计划
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
  py: scripts/python/check_prerequisites.py --json --require-tasks --include-tasks
---

<!-- zh-source: templates/commands/implement.md -->
<!-- zh-base: c8ce488 -->

## 用户输入

```text
$ARGUMENTS
```

在继续之前，你**必须**考虑上述用户输入（如果不为空）。

## 执行前检查

**检查扩展钩子（实现之前）**：
- 检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果存在，读取它并查找 `hooks.before_implement` 键下的条目
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

2. **核对检查清单状态**（如果 FEATURE_DIR/checklists/ 存在）：
   - 扫描 checklists/ 目录中的所有检查清单文件
   - 对每个检查清单，统计：
     - 总项数：所有匹配 `- [ ]`、`- [X]` 或 `- [x]` 的行
     - 已完成项：匹配 `- [X]` 或 `- [x]` 的行
     - 未完成项：匹配 `- [ ]` 的行
   - 创建状态表：

     ```text
     | 检查清单 | 总数 | 已完成 | 未完成 | 状态 |
     |-----------|-------|-----------|------------|--------|
     | ux.md     | 12    | 12        | 0          | ✓ PASS |
     | test.md   | 8     | 5         | 3          | ✗ FAIL |
     | security.md | 6   | 6         | 0          | ✓ PASS |
     ```

   - 计算整体状态：
     - **PASS**：所有检查清单的未完成项均为 0
     - **FAIL**：一个或多个检查清单存在未完成项

   - **如果任何检查清单未完成**：
     - 显示包含未完成项数量的表格
     - **停止**并询问："部分检查清单尚未完成。是否仍要继续执行实现？（yes/no）"
     - 等待用户回复后再继续
     - 如果用户回答 "no"、"wait" 或 "stop"，停止执行
     - 如果用户回答 "yes"、"proceed" 或 "continue"，进入第 3 步

   - **如果所有检查清单都已完成**：
     - 显示表格，展示所有检查清单均已通过
     - 自动进入第 3 步

3. 加载并分析实现上下文：
   - **必需**：读取 tasks.md，获取完整的任务列表和执行计划
   - **必需**：读取 plan.md，获取技术栈、架构和文件结构
   - **如果存在**：读取 data-model.md，获取实体和关系
   - **如果存在**：读取 contracts/，获取 API 规范和测试要求
   - **如果存在**：读取 research.md，获取技术决策和约束
   - **如果存在**：读取 /memory/constitution.md，获取治理约束
   - **如果存在**：读取 quickstart.md，获取集成场景

4. **项目设置验证**：
   - **必需**：根据项目的实际设置创建/核验 ignore 文件：

   **检测与创建逻辑**：
   - 检查以下命令是否执行成功，以判断该仓库是否为 git 仓库（如果是，创建/核验 .gitignore）：

     ```sh
     git rev-parse --git-dir 2>/dev/null
     ```

   - 检查 Dockerfile* 是否存在，或 plan.md 中是否使用 Docker → 创建/核验 .dockerignore
   - 检查 .eslintrc* 是否存在 → 创建/核验 .eslintignore
   - 检查 eslint.config.* 是否存在 → 确保配置的 `ignores` 条目覆盖所需模式
   - 检查 .prettierrc* 是否存在 → 创建/核验 .prettierignore
   - 检查 .npmrc 或 package.json 是否存在 → 创建/核验 .npmignore（如需发布）
   - 检查是否存在 terraform 文件（*.tf）→ 创建/核验 .terraformignore
   - 检查是否需要 .helmignore（存在 helm chart）→ 创建/核验 .helmignore

   **如果 ignore 文件已存在**：核验其包含必要模式，只追加缺失的关键模式
   **如果 ignore 文件缺失**：按检测到的技术创建完整的模式集

   **按技术分类的常用模式**（依据 plan.md 的技术栈）：
   - **Node.js/JavaScript/TypeScript**：`node_modules/`、`dist/`、`build/`、`*.log`、`.env*`
   - **Python**：`__pycache__/`、`*.pyc`、`.venv/`、`venv/`、`dist/`、`*.egg-info/`
   - **Java**：`target/`、`*.class`、`*.jar`、`.gradle/`、`build/`
   - **C#/.NET**：`bin/`、`obj/`、`*.user`、`*.suo`、`packages/`
   - **Go**：`*.exe`、`*.test`、`vendor/`、`*.out`
   - **Ruby**：`.bundle/`、`log/`、`tmp/`、`*.gem`、`vendor/bundle/`
   - **PHP**：`vendor/`、`*.log`、`*.cache`、`*.env`
   - **Rust**：`target/`、`debug/`、`release/`、`*.rs.bk`、`*.rlib`、`*.prof*`、`.idea/`、`*.log`、`.env*`
   - **Kotlin**：`build/`、`out/`、`.gradle/`、`.idea/`、`*.class`、`*.jar`、`*.iml`、`*.log`、`.env*`
   - **C++**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.so`、`*.a`、`*.exe`、`*.dll`、`.idea/`、`*.log`、`.env*`
   - **C**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.a`、`*.so`、`*.exe`、`*.dll`、`autom4te.cache/`、`config.status`、`config.log`、`.idea/`、`*.log`、`.env*`
   - **Swift**：`.build/`、`DerivedData/`、`*.swiftpm/`、`Packages/`
   - **R**：`.Rproj.user/`、`.Rhistory`、`.RData`、`.Ruserdata`、`*.Rproj`、`packrat/`、`renv/`
   - **通用**：`.DS_Store`、`Thumbs.db`、`*.tmp`、`*.swp`、`.vscode/`、`.idea/`

   **工具专属模式**：
   - **Docker**：`node_modules/`、`.git/`、`Dockerfile*`、`.dockerignore`、`*.log*`、`.env*`、`coverage/`
   - **ESLint**：`node_modules/`、`dist/`、`build/`、`coverage/`、`*.min.js`
   - **Prettier**：`node_modules/`、`dist/`、`build/`、`coverage/`、`package-lock.json`、`yarn.lock`、`pnpm-lock.yaml`
   - **Terraform**：`.terraform/`、`*.tfstate*`、`*.tfvars`、`.terraform.lock.hcl`
   - **Kubernetes/k8s**：`*.secret.yaml`、`secrets/`、`.kube/`、`kubeconfig*`、`*.key`、`*.crt`

5. 解析 tasks.md 的结构并提取：
   - **任务阶段**：准备（Setup）、测试（Tests）、核心（Core）、集成（Integration）、打磨（Polish）
   - **任务依赖**：顺序执行与并行执行规则
   - **任务细节**：ID、描述、文件路径、并行标记 [P]
   - **执行流程**：顺序和依赖要求

6. 按照任务计划执行实现：
   - **逐阶段执行**：完成一个阶段后再进入下一个
   - **遵守依赖**：顺序任务按序运行，并行任务 [P] 可以一起运行
   - **遵循 TDD 方式**：先执行测试任务，再执行对应的实现任务
   - **基于文件的协调**：影响相同文件的任务必须顺序运行
   - **验证检查点**：进入下一阶段前核验当前阶段已完成

7. 实现执行规则：
   - **先准备**：初始化项目结构、依赖、配置
   - **先测试后编码**：如果需要为契约、实体和集成场景编写测试
   - **核心开发**：实现模型、服务、CLI 命令、接口端点
   - **集成工作**：数据库连接、中间件、日志、外部服务
   - **打磨与验证**：单元测试、性能优化、文档

8. 进度跟踪与错误处理：
   - 每完成一个任务后报告进度
   - 任何非并行任务失败时，停止执行
   - 对于并行任务 [P]，继续执行成功的任务，报告失败的任务
   - 提供带上下文的清晰错误信息，便于调试
   - 如果实现无法继续，给出后续步骤建议
   - **重要**：对已完成的任务，务必在任务文件中将其标记为 [X]。

9. 完成验证：
   - 核验所有必需的任务均已完成
   - 检查实现的功能与原始规范一致
   - 验证测试通过且覆盖率满足要求
   - 确认实现遵循技术计划

注意：本命令假定 tasks.md 中已存在完整的任务拆解。如果任务不完整或缺失，建议先运行 `__SPECKIT_COMMAND_TASKS__` 重新生成任务列表。

## 强制性执行后钩子

**你必须先完成本节内容，然后才能向用户报告完成。**

检查项目根目录是否存在 `.specify/extensions.yml`。
- 如果它不存在，或 `hooks.after_implement` 下没有注册任何钩子，直接跳到"完成报告"。
- 如果存在，读取它并查找 `hooks.after_implement` 键下的条目。
- 如果 YAML 无法解析或格式无效，静默跳过钩子检查并继续进入"完成报告"。
- 过滤掉 `enabled` 显式为 `false` 的钩子。没有 `enabled` 字段的钩子默认视为启用。
- 对于剩余的每个钩子，**不要**尝试解释或求值钩子的 `condition` 表达式：
  - 如果钩子没有 `condition` 字段，或该字段为 null/空，将钩子视为可执行
  - 如果钩子定义了非空的 `condition`，跳过该钩子，把条件求值留给 HookExecutor 实现
- 对于每个可执行的钩子，根据其 `optional` 标志输出以下内容：
  - **强制钩子**（`optional: false`）——**你必须为每个强制钩子输出 `EXECUTE_COMMAND:`**：
    ```
    ## 扩展钩子

    **自动钩子**：{extension}
    正在执行：`/{command}`
    EXECUTE_COMMAND: {command}
    ```
    输出上面的块之后，你**必须**实际调用该钩子，并等待其完成后再继续。以你在当前智能体/会话中自己运行该命令的方式来运行它（实际调用形式可能与上面显示的字面 `{command}` id 不同，例如技能模式的智能体会以 `/skill:speckit-...` 或 `$speckit-...` 的形式运行它）。仅输出该块并不等于运行了钩子。
  - **可选钩子**（`optional: true`）：
    ```
    ## 扩展钩子

    **可选钩子**：{extension}
    命令：`/{command}`
    说明：{description}

    提示词：{prompt}
    执行方式：`/{command}`
    ```

## 完成报告

报告最终状态，附已完成工作的摘要。

## 完成标准

- [ ] tasks.md 中的所有任务均已完成并标记为 `[X]`
- [ ] 实现已对照规范、计划和测试覆盖率完成验证
- [ ] 已按上文"强制性执行后钩子"中的规则分发或跳过扩展钩子
- [ ] 已向用户报告完成情况，并附已完成工作的摘要
