<!-- zh-source: extensions/template/EXAMPLE-README.md -->
<!-- zh-base: f14a47e -->

# 示例：扩展 README

这是定制完成后你的扩展 README 应有的样子。
**删除本文件，并把 README.md 替换为类似下面这样的内容。**

---

# My Extension

<!-- CUSTOMIZE: 替换为你的扩展描述 -->

简要说明你的扩展做什么、为什么有用。

## 功能特性

<!-- CUSTOMIZE: 列出关键特性 -->

- 特性 1：描述
- 特性 2：描述
- 特性 3：描述

## 安装

```bash
# 从目录源安装
specify extension add my-extension

# 或从本地开发目录安装
specify extension add --dev /path/to/my-extension
```

## 配置

1. 创建配置文件：

   ```bash
   cp .specify/extensions/my-extension/config-template.yml \
      .specify/extensions/my-extension/my-extension-config.yml
   ```

2. 编辑配置：

   ```bash
   vim .specify/extensions/my-extension/my-extension-config.yml
   ```

3. 设置必填值：
   <!-- CUSTOMIZE: 列出必需的配置 -->
   ```yaml
   connection:
     url: "https://api.example.com"
     api_key: "your-api-key"

   project:
     id: "your-project-id"
   ```

## 用法

<!-- CUSTOMIZE: 添加用法示例 -->

### 命令：example

说明这个命令做什么。

```bash
# 在 Claude Code 中
> /speckit.my-extension.example
```

**前置条件**：

- 前置条件 1
- 前置条件 2

**输出**：

- 这个命令产出什么
- 结果保存在哪里

## 配置参考

<!-- CUSTOMIZE: 为所有配置选项写文档 -->

### 连接设置

| 设置项 | 类型 | 必填 | 说明 |
|---------|------|----------|-------------|
| `connection.url` | string | 是 | API 端点 URL |
| `connection.api_key` | string | 是 | API 认证密钥 |

### 项目设置

| 设置项 | 类型 | 必填 | 说明 |
|---------|------|----------|-------------|
| `project.id` | string | 是 | 项目标识符 |
| `project.workspace` | string | 否 | 工作区或组织 |

## 环境变量

用环境变量覆盖配置：

```bash
# 覆盖连接设置
export SPECKIT_MY_EXTENSION_CONNECTION_URL="https://custom-api.com"
export SPECKIT_MY_EXTENSION_CONNECTION_API_KEY="custom-key"
```

## 示例

<!-- CUSTOMIZE: 添加真实场景的示例 -->

### 示例 1：基础工作流

```bash
# 第 1 步：创建规范
> /speckit.spec

# 第 2 步：生成任务
> /speckit.tasks

# 第 3 步：使用扩展
> /speckit.my-extension.example
```

## 故障排查

<!-- CUSTOMIZE: 添加常见问题 -->

### 问题：找不到配置

**解决方法**：从模板创建配置（见"配置"一节）

### 问题：命令不可用

**解决方法**：

1. 检查扩展是否已安装：`specify extension list`
2. 重启 AI 智能体
3. 重新安装扩展

## 许可证

MIT 许可证——见 LICENSE 文件

## 支持

- **Issues**：<https://github.com/your-org/spec-kit-my-extension/issues>
- **Spec Kit 文档**：<https://github.com/statsperform/spec-kit>

## 变更日志

版本历史见 [CHANGELOG.md](CHANGELOG.md)。

---

*扩展版本：1.0.0*
*Spec Kit：>=0.1.0*
