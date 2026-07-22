<!-- zh-source: docs/community/bundles.md -->
<!-- zh-base: 5760061 -->

# 社区套装

> [!NOTE]
> 社区套装由各自的作者独立创建和维护。维护者只验证提交的元数据完整且格式正确——他们**不会审查、审计、背书或支持套装代码及其安装的组件**。安装前请审查套装清单、组件目录源和源码仓库，使用风险自行判断。

套装把现有的 Spec Kit 组件——扩展、预设、工作流和步骤——组合成一套面向角色或团队的完整配置。当你希望用户能一次性装好一组经过测试的组件，而不必依次执行多条安装命令时，套装就派上用场了。

通过审核的社区套装条目发布在 [`bundles/catalog.community.json`](https://github.com/github/spec-kit/blob/main/bundles/catalog.community.json) 中，并列在下方。内置的社区来源是仅发现（discovery-only）的：`specify bundle search` 和 `specify bundle info` 可以查看条目，但按 ID 安装需要显式添加一个 install-allowed 的目录源。显式目录源的默认优先级高于内置社区来源。要提交套装供审查，请创建一个 [Bundle Submission](https://github.com/github/spec-kit/issues/new?template=bundle_submission.yml) issue。

| 套装 | 用途 | 角色或团队 | 提供内容 | 所需目录源 | URL |
|--------|---------|--------------|----------|-------------------|-----|

## 提交内容

一份套装提交应包含：

- 一个包含有效 `bundle.yml` 清单的公开仓库。
- 一个带版本的 GitHub release，附带由 `specify bundle build` 生成的套装构建产物。
- 说明目标角色、所安装组件、所需目录源和预期工作流的文档。
- 一条建议的目录源条目，包含套装元数据和组件数量。
- 在干净的 Spec Kit 项目中得到的测试证据。

## 组件解析

套装的目录源条目描述了去哪里下载套装构建产物，但用户安装时，套装引用的组件仍需要能够解析。组件引用可以从以下来源解析：打包在套装内的组件、已安装的组件，或当前生效的扩展、预设、工作流和步骤目录源。

如果你的套装依赖默认 Spec Kit 目录源中没有的组件，请在提交内容和你的 README 中写明所需的目录源 URL。提交前，请在添加了这些目录源的干净项目中测试完整的安装路径。

例如：

```bash
specify preset catalog add https://example.com/presets.json --name example-bundle --install-allowed
specify extension catalog add https://example.com/extensions.json --name example-bundle --install-allowed
curl -L -o example-bundle-1.0.0.zip https://example.com/example-bundle-1.0.0.zip
specify bundle install ./example-bundle-1.0.0.zip

# 或从某个允许安装（install-allowed）的套装目录源按 id 安装。
specify bundle catalog add https://example.com/bundles.json --id example-bundle-catalog --policy install-allowed
specify bundle install example-bundle
```

## 审查范围

维护者会检查：

- 提交字段完整且格式正确。
- release 构建产物和文档的 URL 可以访问。
- 仓库包含 `bundle.yml` 清单。
- 提交内容明确标出了所需的组件目录源。
- 建议的目录源条目符合套装目录源条目的预期结构。

维护者不会审计所安装的扩展、预设、工作流、步骤或脚本的行为。用户在安装社区套装前应自行审查这些组件。

## 更新套装

要更新已提交的套装，请再创建一个 [Bundle Submission](https://github.com/github/spec-kit/issues/new?template=bundle_submission.yml) issue，附上新版本号、下载 URL、变更的组件列表和更新后的测试证据，并注明该 issue 是对现有套装条目的更新。
