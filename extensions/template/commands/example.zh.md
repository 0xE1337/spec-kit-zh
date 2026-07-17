---
description: "演示扩展功能的示例命令"
# CUSTOMIZE: 列出本命令使用的 MCP 工具
tools:
  - 'example-mcp-server/example_tool'
---

<!-- zh-source: extensions/template/commands/example.md -->
<!-- zh-base: f14a47e -->

# 示例命令

<!-- CUSTOMIZE: 用你的命令文档替换整个文件 -->

这是一个示例命令，演示如何为 Spec Kit 扩展创建命令。

## 目的

说明这个命令做什么、何时使用。

## 前置条件

列出使用本命令前的要求：

1. 前置条件 1（例如 "已配置 MCP 服务器"）
2. 前置条件 2（例如 "配置文件已存在"）
3. 前置条件 3（例如 "有效的 API 凭据"）

## 用户输入

$ARGUMENTS

## 步骤

### 第 1 步：加载配置

<!-- CUSTOMIZE: 替换为你的实际步骤 -->

从项目中加载扩展配置：

``bash
config_file=".specify/extensions/my-extension/my-extension-config.yml"

if [ ! -f "$config_file" ]; then
  echo "❌ Error: Configuration not found at $config_file"
  echo "Run 'specify extension add my-extension' to install and configure"
  exit 1
fi

# 读取配置值

setting_value=$(yq eval '.settings.key' "$config_file")

# 应用环境变量覆盖

setting_value="${SPECKIT_MY_EXTENSION_KEY:-$setting_value}"

# 校验配置

if [ -z "$setting_value" ]; then
  echo "❌ Error: Configuration value not set"
  echo "Edit $config_file and set 'settings.key'"
  exit 1
fi

echo "📋 Configuration loaded: $setting_value"
``

### 第 2 步：执行主要操作

<!-- CUSTOMIZE: 替换为你的命令逻辑 -->

说明这一步做什么：

``markdown
使用 MCP 工具执行主要操作：

- 工具：example-mcp-server example_tool
- 参数：{ "key": "$setting_value" }

这会调用 MCP 服务器工具来执行该操作。
``

### 第 3 步：处理结果

<!-- CUSTOMIZE: 按需添加更多步骤 -->

处理结果并给出输出：

`` bash
echo ""
echo "✅ Command completed successfully!"
echo ""
echo "Results:"
echo "  • Item 1: Value"
echo "  • Item 2: Value"
echo ""
``

### 第 4 步：保存输出（可选）

如有需要，把结果保存到文件：

``bash
output_file=".specify/my-extension-output.json"

cat > "$output_file" <<EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "setting": "$setting_value",
  "results": []
}
EOF

echo "💾 Output saved to $output_file"
``

## 配置参考

<!-- CUSTOMIZE: 为配置选项写文档 -->

本命令使用 `my-extension-config.yml` 中的以下配置：

- **settings.key**：说明这个设置的作用
  - 类型：string
  - 必填：是
  - 示例：`"example-value"`

- **settings.another_key**：另一个设置的说明
  - 类型：boolean
  - 必填：否
  - 默认值：`false`
  - 示例：`true`

## 环境变量

<!-- CUSTOMIZE: 为环境变量覆盖写文档 -->

配置可以用环境变量覆盖：

- `SPECKIT_MY_EXTENSION_KEY`——覆盖 `settings.key`
- `SPECKIT_MY_EXTENSION_ANOTHER_KEY`——覆盖 `settings.another_key`

示例：
``bash
export SPECKIT_MY_EXTENSION_KEY="override-value"
``

## 故障排查

<!-- CUSTOMIZE: 添加常见问题与解决方法 -->

### 出现 "Configuration not found" 错误

**解决方法**：安装扩展并创建配置：
``bash
specify extension add my-extension
cp .specify/extensions/my-extension/config-template.yml \
   .specify/extensions/my-extension/my-extension-config.yml
``

### 出现 "MCP tool not available" 错误

**解决方法**：确保在你的 AI 智能体设置中配置了 MCP 服务器。

### 出现 "Permission denied" 错误

**解决方法**：检查外部服务中的凭据和权限。

## 备注

<!-- CUSTOMIZE: 添加有用的说明与提示 -->

- 本命令需要与外部服务保持活跃连接
- 结果会被缓存以提升性能
- 重新运行命令可刷新数据

## 示例

<!-- CUSTOMIZE: 添加用法示例 -->

### 示例 1：基本用法

``bash

# 使用默认配置运行
>
> /speckit.my-extension.example
``

### 示例 2：使用环境变量覆盖

``bash

# 用环境变量覆盖配置

export SPECKIT_MY_EXTENSION_KEY="custom-value"
> /speckit.my-extension.example
``

### 示例 3：在核心命令之后

``bash

# 作为工作流的一部分使用
>
> /speckit.tasks
> /speckit.my-extension.example
``

---

*更多信息见扩展 README，或运行 `specify extension info my-extension`*
