<!-- zh-source: docs/reference/authentication.md -->
<!-- zh-base: 1add203 -->

# 认证

Specify CLI 对目录源、扩展下载和发布版本检查的 HTTP 请求采用**按需启用（opt-in）**的认证。除非你显式配置，否则不会发送任何凭据。

## 配置

创建 `~/.specify/auth.json` 以启用认证：

```json
{
  "providers": [
    {
      "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    }
  ]
}
```

> **安全提示：** 把文件权限限制为仅所有者可访问：
> ```bash
> chmod 600 ~/.specify/auth.json
> ```

没有这个文件时，所有 HTTP 请求都不带认证。

## 字段

`providers` 数组中的每个条目包含以下字段：

| 字段 | 必填 | 说明 |
|---|---|---|
| `hosts` | 是 | 此条目适用的主机名数组。支持精确主机名，或以 `*.` 开头、仅匹配子域名的通配符（例如 `*.visualstudio.com`）。`*.visualstudio.com` 匹配 `foo.visualstudio.com`，但不匹配 `visualstudio.com`。不支持 `*github.com` 或 `gith?b.com` 这类其他 glob 模式。 |
| `provider` | 是 | 内置提供方标识：`github` 或 `azure-devops`。 |
| `auth` | 是 | 认证方案（见下文）。 |
| `token` | 否 | 令牌值（内联写入）。尽可能改用 `token_env`。 |
| `token_env` | 否 | 读取令牌的环境变量名。 |

对于 `azure-ad` 认证，还需要以下字段：

| 字段 | 必填 | 说明 |
|---|---|---|
| `tenant_id` | 是 | Azure AD 租户 ID。 |
| `client_id` | 是 | 服务主体（service principal）的客户端 ID。 |
| `client_secret_env` | 是 | 存放客户端密钥的环境变量。 |

`bearer` 和 `basic-pat` 方案必须设置 `token` 或 `token_env` 之一。

## 提供方与认证方案

### GitHub（`github`）

| 方案 | 请求头 | 适用于 |
|---|---|---|
| `bearer` | `Authorization: Bearer <token>` | PAT（个人访问令牌）、细粒度 PAT、OAuth 令牌、GitHub App 令牌 |

**示例——通过环境变量提供 PAT：**

```json
{
  "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
  "provider": "github",
  "auth": "bearer",
  "token_env": "GH_TOKEN"
}
```

### GitHub Enterprise Server（GHES）

要使用托管在 GitHub Enterprise Server 实例上的私有目录源或扩展，添加一个 `github` 条目并列出你的 GHES 主机。同一个条目既为目录源 JSON 抓取认证，**也**为私有 release 资产下载认证——Specify 会把列出的主机识别为 GitHub Enterprise，并通过 GHES REST API（`/api/v3`）解析 release 下载。

```json
{
  "providers": [
    {
      "hosts": ["ghes.example.com", "raw.ghes.example.com", "codeload.ghes.example.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_ENTERPRISE_TOKEN"
    }
  ]
}
```

请列出**裸**主机名（例如 `ghes.example.com`）——release 下载 URL 就在那里。如果你的实例启用了子域名隔离，还要列出你的目录源/扩展 URL 使用的 `raw.` 和 `codeload.` 子域名。`*.ghes.example.com` 通配符匹配子域名，但**不**匹配裸主机名，所以务必显式包含裸主机名。

### Azure DevOps（`azure-devops`）

| 方案 | 请求头 | 适用于 |
|---|---|---|
| `basic-pat` | `Authorization: Basic base64(:<PAT>)` | 个人访问令牌（PAT） |
| `bearer` | `Authorization: Bearer <token>` | 预先获取的 OAuth / Azure AD 令牌 |
| `azure-cli` | `Authorization: Bearer <token>` | 通过 `az account get-access-token` 获取的令牌 |
| `azure-ad` | `Authorization: Bearer <token>` | 通过 OAuth2 客户端凭据流获取的令牌 |

**示例——通过环境变量提供 PAT：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "basic-pat",
  "token_env": "AZURE_DEVOPS_PAT"
}
```

**示例——Azure CLI（交互式登录）：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "azure-cli"
}
```

要求事先运行过 `az login`。

**示例——Azure AD 服务主体（CI/自动化）：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "azure-ad",
  "tenant_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "client_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "client_secret_env": "AZURE_CLIENT_SECRET"
}
```

## 多个条目

可以为不同的主机或组织配置多个条目：

```json
{
  "providers": [
    {
      "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    },
    {
      "hosts": ["dev.azure.com"],
      "provider": "azure-devops",
      "auth": "basic-pat",
      "token_env": "AZURE_DEVOPS_PAT"
    }
  ]
}
```

## 工作机制

1. 每个对外的 HTTP 请求，其 URL 主机名会与 `auth.json` 中的 `hosts` 模式进行匹配。
2. 找到匹配时，对应的提供方解析出令牌，并附加相应的 `Authorization` 请求头。
3. 如果请求收到 401 或 403，尝试下一个匹配的条目。
4. 所有匹配条目都尝试完后，最后回退为一次不带认证的请求。
5. 发生重定向时，如果重定向目标离开了该条目声明的主机范围，`Authorization` 请求头会被剥除——防止凭据泄漏给 CDN 或第三方服务。

## 模板

一份预配置好 GitHub 的参考 `auth.json`：

```json
{
  "providers": [
    {
      "hosts": [
        "github.com",
        "api.github.com",
        "raw.githubusercontent.com",
        "codeload.github.com"
      ],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    }
  ]
}
```

使用方法：

```bash
mkdir -p ~/.specify
# 把上面的 JSON 复制到 ~/.specify/auth.json
chmod 600 ~/.specify/auth.json
```
