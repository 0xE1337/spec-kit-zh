<!-- zh-source: docs/community/walkthroughs.md -->
<!-- zh-base: d402a39 -->

# 社区实战演练

> [!NOTE]
> 社区实战演练由各自的作者独立创建和维护。它们**未经 GitHub 审查、背书或支持**。跟随操作前请先审阅其内容，使用风险自行判断。

通过这些社区贡献的实战演练，看看规范驱动开发在不同场景下的实际效果：

- **[从零开发 .NET CLI 工具（greenfield）](https://github.com/mnriem/spec-kit-dotnet-cli-demo)**——从一个空目录开始，把一个时区实用工具构建成 .NET 单二进制 CLI 工具，覆盖完整的 spec-kit 工作流：constitution、specify、plan、tasks，以及使用 GitHub Copilot 智能体的多轮 implement。

- **[从零开发 Spring Boot + React 平台（greenfield）](https://github.com/mnriem/spec-kit-spring-react-demo)**——使用 Spring Boot、内嵌 React、PostgreSQL 和 Docker Compose 从零构建一个 LLM 性能分析平台（REST API、图表、迭代跟踪），流程中包含一个澄清步骤和一轮跨产物一致性分析。

- **[存量 ASP.NET CMS 扩展（brownfield）](https://github.com/mnriem/spec-kit-aspnet-brownfield-demo)**——为一个现有的开源 .NET CMS（CarrotCakeCMS-Core，约 307,000 行 C#、Razor、SQL、JavaScript 和配置文件）添加两个新功能——跨平台的 Docker Compose 基础设施和一个基于令牌认证的无头 REST API——演示 spec-kit 如何融入没有既有规范或宪章的存量代码库。

- **[存量 Java 运行时扩展（brownfield）](https://github.com/mnriem/spec-kit-java-brownfield-demo)**——为一个现有的开源 Jakarta EE 运行时（Piranha，约 420,000 行 Java、XML、JSP、HTML 和配置文件，横跨 180 个 Maven 模块）添加带密码保护的服务器管理控制台，演示 spec-kit 在没有既有规范和宪章的大型多模块 Java 项目上的运用。

- **[存量 Go / React 仪表盘演示（brownfield）](https://github.com/mnriem/spec-kit-go-brownfield-demo)**——演示完全**在终端中使用 GitHub Copilot CLI** 驱动 spec-kit。为 NASA 开源的 Hermes 地面支持系统（Go）添加一个轻量的、基于 React 的 Web 遥测仪表盘，证明完整的 constitution → specify → plan → tasks → implement 工作流在终端里同样行得通。

- **[从零开发 Spring Boot MVC 并使用自定义预设（greenfield）](https://github.com/mnriem/spec-kit-pirate-speak-preset-demo)**——使用自定义的海盗腔预设从零构建一个 Spring Boot MVC 应用，演示预设如何重塑整个 spec-kit 体验：规范变成"航海清单"（Voyage Manifests），计划变成"作战计划"（Battle Plans），任务变成"船员分工"（Crew Assignments）——全部以纯正的海盗口吻生成，且不改动任何工具。

- **[从零开发 Spring Boot + React 并使用自定义扩展（greenfield）](https://github.com/mnriem/spec-kit-aide-extension-demo)**——完整演示 **AIDE 扩展**：一个社区扩展，为 spec-kit 添加另一种规范驱动工作流，用高层规范（愿景）和低层规范（工作项）组织成 7 步迭代生命周期：愿景 → 路线图 → 进度跟踪 → 工作队列 → 工作项 → 执行 → 反馈循环。以一个家庭交易平台（Spring Boot 4、React 19、PostgreSQL、Docker Compose）为场景，说明扩展机制如何让你在不改动任何核心工具的前提下，接入一种不同风格的规范驱动开发——真正用足了 Spec Kit 里的"Kit"。
