<!-- zh-source: extensions/template/README.md -->
<!-- zh-base: f14a47e -->

# 扩展模板

用于创建 Spec Kit 扩展的起步模板。

## 快速上手

1. **复制此模板**：

   ```bash
   cp -r extensions/template my-extension
   cd my-extension
   ```

2. **定制 `extension.yml`**：
   - 修改扩展 ID、名称、描述
   - 更新作者和仓库信息
   - 定义你的命令

3. **创建命令**：
   - 在 `commands/` 目录中添加命令文件
   - 使用带 YAML front matter 的 Markdown 格式

4. **创建配置模板**：
   - 定义配置选项
   - 为所有设置写文档

5. **编写文档**：
   - 更新 README.md，写清使用说明
   - 添加示例

6. **本地测试**：

   ```bash
   cd /path/to/spec-kit-project
   specify extension add --dev /path/to/my-extension
   ```

7. **发布**（可选）：
   - 创建 GitHub 仓库
   - 创建 release
   - 提交到目录源（见 EXTENSION-PUBLISHING-GUIDE.md）

## 此模板中的文件

- `extension.yml`——扩展清单（请定制）
- `config-template.yml`——配置模板（请定制）
- `commands/example.md`——示例命令（请替换）
- `README.md`——扩展文档（请替换）
- `LICENSE`——MIT 许可证（请审阅）
- `CHANGELOG.md`——版本历史（请更新）
- `.gitignore`——Git 忽略规则

## 定制检查清单

- [ ] 用你的扩展信息更新 `extension.yml`
- [ ] 把扩展 ID 改为你的扩展名
- [ ] 更新作者信息
- [ ] 定义你的命令
- [ ] 在 `commands/` 中创建命令文件
- [ ] 更新配置模板
- [ ] 编写包含使用说明的 README
- [ ] 添加示例
- [ ] 如有需要更新 LICENSE
- [ ] 本地测试扩展
- [ ] 创建 git 仓库
- [ ] 创建第一个 release

## 需要帮助？

- **开发指南**：见 EXTENSION-DEVELOPMENT-GUIDE.md
- **API 参考**：见 EXTENSION-API-REFERENCE.md
- **发布指南**：见 EXTENSION-PUBLISHING-GUIDE.md
- **用户指南**：见 EXTENSION-USER-GUIDE.md

## 模板版本

- 版本：1.0.0
- 最后更新：2026-01-28
- 兼容的 Spec Kit 版本：>=0.1.0
