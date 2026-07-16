<!-- zh-source: docs/README.md -->
<!-- zh-base: 33a0796 -->

# 文档

本文件夹包含 Spec Kit 的文档源文件，使用 [DocFX](https://dotnet.github.io/docfx/) 构建。

## 本地构建

在本地构建文档：

1. 安装 DocFX：

   ```bash
   dotnet tool install -g docfx
   ```

2. 构建文档：

   ```bash
   cd docs
   docfx docfx.json --serve
   ```

3. 在浏览器中打开 `http://localhost:8080` 查看文档。

## 结构

- `docfx.json` - DocFX 配置文件
- `index.md` - 文档主页
- `toc.yml` - 目录（TOC）配置文件
- `installation.md` - 安装指南
- `quickstart.md` - 快速上手指南
- `_site/` - 生成的文档输出（已被 git 忽略）

## 部署

当变更推送到 `main` 分支时，文档会自动构建并部署到 GitHub Pages。工作流定义在 `.github/workflows/docs.yml` 中。
