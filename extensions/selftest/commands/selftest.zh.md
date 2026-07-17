---
description: "验证目录源中某个扩展的完整生命周期。"
---

<!-- zh-source: extensions/selftest/commands/selftest.md -->
<!-- zh-base: c8ce488 -->

# 扩展自测：`$ARGUMENTS`

本命令驱动一次自测，模拟开发者使用 `$ARGUMENTS` 扩展的体验。

## 目标

验证扩展 `$ARGUMENTS` 的端到端生命周期（发现、安装、注册）。
如果 `$ARGUMENTS` 为空，你必须告诉用户提供一个扩展名，例如：`/speckit.selftest.extension linear`。

## 步骤

### 第 1 步：目录源发现验证

检查该扩展是否存在于 Spec Kit 目录源中。
执行这条命令，验证它成功完成且返回的扩展 ID 与 `$ARGUMENTS` 完全一致。如果命令失败或 ID 与 `$ARGUMENTS` 不一致，判定测试失败。

```bash
specify extension info "$ARGUMENTS"
```

### 第 2 步：模拟安装

首先，尝试把该扩展直接添加到当前工作区配置。如果目录源把该扩展标记为 `install_allowed: false`（仅可发现，discovery-only），这一步*预期*会失败。

```bash
specify extension add "$ARGUMENTS"
```

然后，通过从该扩展在目录源中的下载 URL 安装来模拟添加，这应当可以绕过上述限制。
从目录源元数据中获取该扩展的 `download_url`（例如通过目录源的 info 命令或 UI），然后运行：

```bash
specify extension add "$ARGUMENTS" --from "<download_url>"
```

### 第 3 步：注册验证

`add` 命令完成后，通过检查项目配置来验证安装。
使用终端工具（如 `cat`）验证以下文件包含 `$ARGUMENTS` 的记录。

```bash
cat .specify/extensions/.registry/$ARGUMENTS.json
```

### 第 4 步：验证报告

分析上述三个步骤的标准输出。
生成终端风格的测试输出格式，详细说明发现、安装和注册的结果。直接返回给用户。

示例输出格式：
```text
============================= test session starts ==============================
collected 3 items

test_selftest_discovery.py::test_catalog_search [PASS/FAIL]
  Details: [填入 specify extension search 的执行结果]

test_selftest_installation.py::test_extension_add [PASS/FAIL]
  Details: [填入 specify extension add 的执行结果]

test_selftest_registration.py::test_config_verification [PASS/FAIL]
  Details: [填入注册表记录验证的结果]

============================== [X] passed in ... ==============================
```
