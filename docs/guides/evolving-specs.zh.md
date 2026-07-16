<!-- zh-source: docs/guides/evolving-specs.md -->
<!-- zh-base: 3e97b10 -->

# 在现有项目中演进规范

现有项目需要两条相互独立的维护循环：

- **Spec Kit 项目文件更新**：刷新受管的命令、脚本、模板和共享记忆文件。
- **功能产物演进**：让仓库自有的 `specs/` 产物与你打算交付的代码和产品行为保持一致。

需要更新的 Spec Kit 项目文件时，使用[升级工作流](../upgrade.md)。当需求或实现中的洞察改变了现有项目时，使用下面的某种产物持久化模型。

概念层面的模型定义见[规范持久化模型](../concepts/spec-persistence.md)。

## 前推式规范（Flow-Forward Spec）

当每个功能目录都应保留为历史记录时，使用前推式。

当你添加新功能或进行大幅度的后续修改时，通过已安装的 `/speckit.specify` 命令创建新的功能规范，并沿标准流程继续：

1. 运行 `/speckit.specify`，在 `specs/` 下创建新的功能目录。
2. 运行 `/speckit.plan`，定义实现方式。
3. 运行 `/speckit.tasks`，推导出工作拆解。
4. 运行 `/speckit.implement`，然后审查产出的代码和产物差异。
5. 运行 `/speckit.converge`，验证完整性并为剩余缺口生成任务。如果追加了任务，就重复 `/speckit.implement` 和 `/speckit.converge`，直到功能完全完成。

先前的功能目录保持原样，可用于审计、对比，或解释项目如何走到当前状态。当新目录取代或扩展了早期工作时，请使用清晰的功能命名或交叉链接。

## 活规范（Living Spec）

当 `spec.md` 是契约、`plan.md` 和 `tasks.md` 由它派生时，使用活规范。

当预期行为发生变化时，先修订现有的 `spec.md`，再重新生成或手动修订下游产物，使它们与更新后的规范一致：

1. 从干净的工作树或专门的分支开始，让每个生成的变更都可以被审查。
2. 用 `/speckit.clarify` 或显式编辑来更新 `spec.md`。
3. 重新运行 `/speckit.plan` 或修订 `plan.md`，让技术方案与修订后的规范一致。
4. 重新运行 `/speckit.tasks` 或修订 `tasks.md`，让实现工作与修订后的计划一致。
5. 在恢复实现之前运行 `/speckit.analyze`，捕捉规范、计划和任务之间的缺口。
6. 运行 `/speckit.implement`，然后把代码和产物的差异放在一起审查。
7. 运行 `/speckit.converge` 评估完成度，并把剩余工作追加到 `tasks.md`。如果追加了任务，就重复 `/speckit.implement` 和 `/speckit.converge`，直到功能完全完成。

在替换派生产物之前，先保留重要的实现理由。如果计划或任务清单中包含仍然重要的决策，请显式地把它们带到新版本中。

## 回流式规范（Flow-Back Spec）

当允许实现中的发现反过来重塑产物集时，使用回流式。

在这个模型中，第一处有效的修改可以发生在洞察落地的任何位置：`spec.md`、`plan.md`、`tasks.md` 或实现本身。修改之后，再让整个产物集重新对齐：

1. 把发现记录在离当前工作最近的产物里。
2. 判断它改变的是预期行为、实现策略、任务拆解，还是只涉及代码。
3. 更新其他与已确认方向不一致的产物。
4. 运行 `/speckit.analyze`，检查 `spec.md`、`plan.md` 和 `tasks.md` 之间的缺口。
5. 只有当产物集准确描述了你希望未来贡献者信赖的行为和方案之后，才继续实现。

回流式很灵活，但需要纪律。如果 `spec.md` 仍然写着不同的内容、而规范又应当保持可信，就不要把一个较低层级的修改留在 `tasks.md` 或代码里不管。

## 更新 Spec Kit 项目文件之前

在用终端命令 `specify init --here --force --integration <your-agent>` 刷新 Spec Kit 项目文件之前，先保护好位于 `specs/` 之外的项目专属内容，尤其是 `.specify/memory/constitution.md`，以及 `.specify/templates/` 或 `.specify/scripts/` 下的自定义文件。`<your-agent>` 填目标项目所使用的 AI 编码智能体集成。

你的 `specs/` 目录不属于模板包，但共享的项目文件可能会被强制刷新覆盖。
