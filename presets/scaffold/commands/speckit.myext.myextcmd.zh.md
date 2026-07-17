---
description: "覆盖 myext 扩展的 myextcmd 命令"
---

<!-- zh-source: presets/scaffold/commands/speckit.myext.myextcmd.md -->
<!-- zh-base: 69ee7a8 -->

<!-- Preset override for speckit.myext.myextcmd -->

你正在遵循 myext 扩展的 myextcmd 命令的一个定制版本。

执行本命令时：

1. 从 $ARGUMENTS 读取用户输入
2. 遵循标准的 myextcmd 工作流
3. 另外，应用本预设的以下定制项：
   - 在继续之前先做合规检查
   - 在输出中加入审计追踪条目

> CUSTOMIZE：把上面的指令替换成你自己的。
> 本文件覆盖的是 "myext" 扩展提供的命令。
> 安装本预设后，所有智能体（Claude、Gemini、Copilot 等）
> 都会使用这个版本，而不是扩展原来的版本。
