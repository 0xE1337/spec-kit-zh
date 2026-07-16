<!-- zh-source: templates/constitution-template.md -->
<!-- zh-base: 4afbd87 -->

# [PROJECT_NAME] 宪章
<!-- 示例：Spec 宪章、TaskFlow 宪章等 -->

## 核心原则

### [PRINCIPLE_1_NAME]
<!-- 示例：I. 库优先 -->
[PRINCIPLE_1_DESCRIPTION]
<!-- 示例：每个功能都从独立库开始；库必须自包含、可独立测试、有文档；必须有明确目的——不允许仅为组织代码而存在的库 -->

### [PRINCIPLE_2_NAME]
<!-- 示例：II. CLI 接口 -->
[PRINCIPLE_2_DESCRIPTION]
<!-- 示例：每个库都通过 CLI 暴露功能；文本输入/输出协议：stdin/参数 → stdout，错误 → stderr；同时支持 JSON 和人类可读格式 -->

### [PRINCIPLE_3_NAME]
<!-- 示例：III. 测试先行（不可妥协） -->
[PRINCIPLE_3_DESCRIPTION]
<!-- 示例：强制 TDD：先写测试 → 用户确认 → 测试失败 → 再实现；严格执行红-绿-重构循环 -->

### [PRINCIPLE_4_NAME]
<!-- 示例：IV. 集成测试 -->
[PRINCIPLE_4_DESCRIPTION]
<!-- 示例：需要集成测试的重点领域：新库的契约测试、契约变更、服务间通信、共享 schema -->

### [PRINCIPLE_5_NAME]
<!-- 示例：V. 可观测性；VI. 版本管理与破坏性变更；VII. 简单性 -->
[PRINCIPLE_5_DESCRIPTION]
<!-- 示例：文本输入/输出保证可调试性；要求结构化日志；或：MAJOR.MINOR.BUILD 版本格式；或：从简单开始，遵循 YAGNI 原则 -->

## [SECTION_2_NAME]
<!-- 示例：附加约束、安全要求、性能标准等 -->

[SECTION_2_CONTENT]
<!-- 示例：技术栈要求、合规标准、部署政策等 -->

## [SECTION_3_NAME]
<!-- 示例：开发工作流、评审流程、质量关卡等 -->

[SECTION_3_CONTENT]
<!-- 示例：代码评审要求、测试关卡、部署审批流程等 -->

## 治理
<!-- 示例：宪章高于所有其他实践；修订需要文档记录、审批和迁移计划 -->

[GOVERNANCE_RULES]
<!-- 示例：所有 PR/评审必须验证合规性；复杂度必须说明理由；运行期开发指引使用 [GUIDANCE_FILE] -->

**版本**：[CONSTITUTION_VERSION] | **批准日期**：[RATIFICATION_DATE] | **最后修订**：[LAST_AMENDED_DATE]
<!-- 示例：版本：2.1.1 | 批准日期：2025-06-13 | 最后修订：2025-07-16 -->
