---
description: "初始化 Git 仓库并创建初始提交"
---

<!-- zh-source: extensions/git/commands/speckit.git.initialize.md -->
<!-- zh-base: c7e0cac -->

# 初始化 Git 仓库

如果当前项目目录还不存在 Git 仓库，则初始化一个。

## 执行

从项目根目录运行对应的脚本：

- **Bash**：`.specify/extensions/git/scripts/bash/initialize-repo.sh`
- **PowerShell**：`.specify/extensions/git/scripts/powershell/initialize-repo.ps1`

如果找不到扩展脚本，回退为：
- **Bash**：`git init && git add . && git commit -m "Initial commit from Specify template"`
- **PowerShell**：`git init; git add .; git commit -m "Initial commit from Specify template"`

脚本内部会处理所有检查：
- 如果 Git 不可用则跳过
- 如果已在 Git 仓库内则跳过
- 运行 `git init`、`git add .` 和 `git commit`，并写入初始提交消息

## 定制

替换脚本即可加入项目专属的 Git 初始化步骤：
- 自定义 `.gitignore` 模板
- 默认分支命名（`git config init.defaultBranch`）
- Git LFS 设置
- 安装 Git 钩子
- 提交签名配置
- Git Flow 初始化

## 输出

成功时：
- `[OK] Git repository initialized`

## 优雅降级

如果 Git 未安装：
- 警告用户
- 跳过仓库初始化
- 项目在没有 Git 的情况下继续可用（规范仍可创建在 `specs/` 下）

如果 Git 已安装但 `git init`、`git add .` 或 `git commit` 失败：
- 把错误呈现给用户
- 停止本命令，而不是带着初始化了一半的仓库继续
