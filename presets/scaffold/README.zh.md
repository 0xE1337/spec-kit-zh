<!-- zh-source: presets/scaffold/README.md -->
<!-- zh-base: 69ee7a8 -->

# My Preset

一个 Spec Kit 自定义预设。复制这个目录并按需定制，就能创建你自己的预设。

## 包含的模板

| 模板 | 类型 | 说明 |
|----------|------|-------------|
| `spec-template` | template | 自定义的功能规范模板（覆盖核心与扩展） |
| `myext-template` | template | 覆盖 myext 扩展的报告模板 |
| `speckit.specify` | command | 自定义的规范命令（覆盖核心） |
| `speckit.myext.myextcmd` | command | 覆盖 myext 扩展的 myextcmd 命令 |

## 开发

1. 复制这个目录：`cp -r presets/scaffold my-preset`
2. 编辑 `preset.yml` —— 设置你的预设的 ID、名称、描述和模板
3. 在 `templates/` 中添加或修改模板
4. 本地测试：`specify preset add --dev ./my-preset`
5. 验证解析：`specify preset resolve spec-template`
6. 测试完成后移除：`specify preset remove my-preset`

## 清单参考（`preset.yml`）

必填字段：

- `schema_version` —— 固定为 `"1.0"`
- `preset.id` —— 小写字母数字加连字符
- `preset.name` —— 人类可读的名称
- `preset.version` —— 语义化版本（例如 `1.0.0`）
- `preset.description` —— 简短描述
- `requires.speckit_version` —— 版本约束（例如 `>=0.1.0`）
- `provides.templates` —— 模板列表，每项含 `type`、`name` 和 `file`

## 模板类型

- **template** —— 文档脚手架（spec-template.md、plan-template.md、tasks-template.md 等）
- **command** —— AI 智能体工作流提示词（例如 speckit.specify、speckit.plan）
- **script** —— 自定义脚本（预留给未来使用）

## 发布

向目录源提交预设的详细步骤见[预设发布指南](../PUBLISHING.md)。

## 许可证

MIT
