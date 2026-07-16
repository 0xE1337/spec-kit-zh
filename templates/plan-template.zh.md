<!-- zh-source: templates/plan-template.md -->
<!-- zh-base: 87a9690 -->

# 实现计划：[FEATURE]

**分支**：`[###-feature-name]` | **日期**：[DATE] | **规范**：[链接]

**输入**：来自 `/specs/[###-feature-name]/spec.md` 的功能规范

**说明**：本模板由 `__SPECKIT_COMMAND_PLAN__` 命令填写；执行工作流见该命令的定义。

## 摘要

[从功能规范中提取：核心需求 + 来自研究的技术方案]

## 技术上下文

<!--
  必须填写：把本节内容替换为该项目的具体技术细节。
  这里的结构仅供参考，用于引导迭代过程。
-->

**语言/版本**：[例如 Python 3.11、Swift 5.9、Rust 1.75，或 NEEDS CLARIFICATION]

**主要依赖**：[例如 FastAPI、UIKit、LLVM，或 NEEDS CLARIFICATION]

**存储**：[如适用，例如 PostgreSQL、CoreData、文件，或 N/A]

**测试**：[例如 pytest、XCTest、cargo test，或 NEEDS CLARIFICATION]

**目标平台**：[例如 Linux 服务器、iOS 15+、WASM，或 NEEDS CLARIFICATION]

**项目类型**：[例如 库/CLI/Web 服务/移动应用/编译器/桌面应用，或 NEEDS CLARIFICATION]

**性能目标**：[领域相关，例如 1000 req/s、每秒 1 万行、60 fps，或 NEEDS CLARIFICATION]

**约束**：[领域相关，例如 <200ms p95、<100MB 内存、可离线运行，或 NEEDS CLARIFICATION]

**规模/范围**：[领域相关，例如 1 万用户、100 万行代码、50 个界面，或 NEEDS CLARIFICATION]

## 宪章检查

*关卡：必须在阶段 0 研究之前通过。阶段 1 设计完成后需复查。*

[关卡依据宪章文件确定]

## 项目结构

### 文档（本功能）

```text
specs/[###-feature]/
├── plan.md              # 本文件（__SPECKIT_COMMAND_PLAN__ 命令的输出）
├── research.md          # 阶段 0 的输出（__SPECKIT_COMMAND_PLAN__ 命令）
├── data-model.md        # 阶段 1 的输出（__SPECKIT_COMMAND_PLAN__ 命令）
├── quickstart.md        # 阶段 1 的输出（__SPECKIT_COMMAND_PLAN__ 命令）
├── contracts/           # 阶段 1 的输出（__SPECKIT_COMMAND_PLAN__ 命令）
└── tasks.md             # 阶段 2 的输出（__SPECKIT_COMMAND_TASKS__ 命令——不由 __SPECKIT_COMMAND_PLAN__ 创建）
```

### 源码（仓库根目录）
<!--
  必须填写：把下面的占位目录树替换为本功能的实际布局。删除
  未用到的选项，并用真实路径展开所选结构（例如 apps/admin、
  packages/something）。最终交付的计划不得再包含"选项"标签。
-->

```text
# [REMOVE IF UNUSED] 选项 1：单一项目（默认）
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] 选项 2：Web 应用（当检测到"frontend"+"backend"时）
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] 选项 3：移动端 + API（当检测到"iOS/Android"时）
api/
└── [同上面的 backend]

ios/ 或 android/
└── [平台特定结构：功能模块、UI 流程、平台测试]
```

**结构决策**：[记录所选结构，并引用上面写明的真实目录]

## 复杂度跟踪

> **仅当宪章检查存在必须说明理由的违例时才填写**

| 违例 | 为什么需要 | 更简单的替代方案被否决的原因 |
|-----------|------------|-------------------------------------|
| [例如第 4 个项目] | [当前需求] | [为什么 3 个项目不够] |
| [例如仓储模式] | [具体问题] | [为什么直接访问数据库不够] |
