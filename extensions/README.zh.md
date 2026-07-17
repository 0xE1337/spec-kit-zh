<!-- zh-source: extensions/README.md -->
<!-- zh-base: ad62357 -->

# Spec Kit 扩展

[Spec Kit](https://github.com/github/spec-kit) 的扩展系统——在不让核心框架臃肿的前提下添加新功能。

## 扩展目录源

Spec Kit 提供两个用途不同的目录源文件：

### 你的目录源（`catalog.json`）

- **用途**：Spec Kit CLI 默认使用的上游扩展目录源
- **默认状态**：上游项目中有意留空——你或你的组织在 fork/副本中填入自己信任的扩展
- **位置（上游）**：GitHub 托管的 spec-kit 仓库中的 `extensions/catalog.json`
- **CLI 默认值**：除非被覆盖，`specify extension` 命令默认使用上游目录源 URL
- **组织目录源**：把 `SPECKIT_CATALOG_URL` 指向你组织的 fork 或托管的目录源 JSON，以替代上游默认值
- **定制**：把社区目录源中的条目复制到你的组织目录源，或直接添加你自己的扩展

**覆盖示例：**
```bash
# 用你组织的目录源覆盖默认的上游目录源
export SPECKIT_CATALOG_URL="https://your-org.com/spec-kit/catalog.json"
specify extension search  # 现在使用你组织的目录源，而不是上游默认值
```

### 社区参考目录源（`catalog.community.json`）

> [!NOTE]
> 社区扩展由各自的作者独立创建和维护。维护者只验证目录源条目是否完整、格式是否正确——他们**不会审查、审计、背书或支持扩展代码本身**。安装前请审查扩展的源码，使用风险自行判断。

- **用途**：浏览可用的社区贡献扩展
- **状态**：活跃——包含社区提交的扩展
- **位置**：`extensions/catalog.community.json`
- **用法**：用于发现可用扩展的参考目录源
- **提交**：通过 [issue 模板](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml)开放社区贡献

**工作方式：**

## 让扩展可用

由你控制团队能发现和安装哪些扩展：

### 方式 1：策展目录源（推荐组织使用）

把批准的扩展填入你的 `catalog.json`：

1. 从多种来源**发现**扩展：
   - 浏览 `catalog.community.json` 中的社区扩展
   - 在你组织的仓库中寻找私有/内部扩展
   - 从可信第三方发现扩展
2. **审查**扩展，选出你想开放使用的
3. 把这些扩展条目**添加**到你自己的 `catalog.json`
4. **团队成员**现在就能发现并安装它们：
   - `specify extension search` 展示你的策展目录源
   - `specify extension add <name>` 从你的目录源安装

**好处**：完全掌控可用扩展、团队一致性、组织级审批流程

**示例**：把 `catalog.community.json` 中的一个条目复制到你的 `catalog.json`，你的团队就能按名称发现并安装它。

### 方式 2：直接 URL（临时使用）

跳过目录源策展，团队成员直接用 URL 安装：

```bash
specify extension add <extension-name> --from https://github.com/org/spec-kit-ext/archive/refs/tags/v1.0.0.zip
```

**好处**：适合一次性测试或私有扩展

**代价**：这样安装的扩展不会出现在其他团队成员的 `specify extension search` 结果中，除非你同时把它们加进你的 `catalog.json`。

## 可用的社区扩展

> [!NOTE]
> 社区扩展由各自的作者独立创建和维护。维护者只验证目录源条目是否完整、格式是否正确——他们**不会审查、审计、背书或支持扩展代码本身**。社区扩展网站同样是第三方资源。安装前请审查扩展的源码，使用风险自行判断。

🔍 **在[社区扩展网站](https://speckit-community.github.io/extensions/)浏览和搜索社区扩展。**

完整的社区贡献扩展列表见[社区扩展](https://github.github.io/spec-kit/community/extensions.html)页面。

原始目录源数据见 [`catalog.community.json`](catalog.community.json)。


## 添加你的扩展

### 提交流程

要把你的扩展加入社区目录源：

1. 按照[扩展开发指南](EXTENSION-DEVELOPMENT-GUIDE.md)**准备好你的扩展**
2. 为你的扩展**创建 GitHub release**
3. 使用[扩展提交](https://github.com/github/spec-kit/issues/new?template=extension_submission.yml)模板**提交 issue**，附上所有必需的元数据
4. **等待审查**——维护者会审查提交、更新目录源并关闭 issue

详细的分步说明见[扩展发布指南](EXTENSION-PUBLISHING-GUIDE.md)。

### 提交检查清单

提交前请确认：

- ✅ 有效的 `extension.yml` 清单
- ✅ 完整的 README，包含安装和使用说明
- ✅ 包含 LICENSE 文件
- ✅ 已创建带语义化版本号的 GitHub release（例如 v1.0.0）
- ✅ 扩展已在真实项目上测试过
- ✅ 所有命令都能按文档描述正常工作

## 安装扩展
扩展就绪后（在你的目录源中，或通过直接 URL），即可安装：

```bash
# 从你的策展目录源安装（按名称）
specify extension search                  # 查看你的目录源里有什么
specify extension add <extension-name>    # 按名称安装

# 直接从 URL 安装（绕过目录源）
specify extension add <extension-name> --from https://github.com/<org>/<repo>/archive/refs/tags/<version>.zip

# 列出已安装的扩展
specify extension list
```

更多信息见[扩展用户指南](EXTENSION-USER-GUIDE.md)。
