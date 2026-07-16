#!/usr/bin/env bash
# 用 Claude 将英文 markdown 初翻为同级 .zh.md 文件（初翻后必须人工审校）
# 用法: tools/zh/translate.sh docs/installation.md [更多文件...]
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
GLOSSARY="$ROOT/GLOSSARY.zh.md"

if [[ $# -eq 0 ]]; then
  echo "用法: tools/zh/translate.sh <file.md> [更多文件...]" >&2
  exit 1
fi

for SRC in "$@"; do
  SRC="${SRC#./}"
  if [[ "$SRC" == *.zh.md ]]; then
    echo "跳过（已是译文）: $SRC"
    continue
  fi
  if [[ ! -f "$ROOT/$SRC" ]]; then
    echo "找不到文件: $SRC" >&2
    exit 1
  fi

  DST="$ROOT/${SRC%.md}.zh.md"
  BASE="$(git -C "$ROOT" log -1 --format=%h -- "$SRC")"

  echo "翻译中: $SRC (基准 $BASE) ..."

  claude -p "$(cat <<EOF
你是 GitHub spec-kit 官方文档的专业译者。把下面的英文 markdown 完整翻译为简体中文。

规则：
- 严格遵守术语表（见下），术语必须全文一致
- 代码块中的命令、路径、标志保持原样，仅翻译注释
- 示例提示词（用户输入给 AI 的自然语言）要翻译
- 链接 URL 不变，链接文字翻译；badge 和 HTML 结构保持不变
- 专有名词（GitHub Copilot、Claude Code、uv 等）不翻译
- 中英文之间加半角空格；语气自然，不要翻译腔
- 只输出翻译后的 markdown，不要任何解释或代码围栏包裹

===== 术语表 =====
$(cat "$GLOSSARY")

===== 待翻译原文（$SRC）=====
$(cat "$ROOT/$SRC")
EOF
)" > "$DST.tmp"

  {
    echo "<!-- zh-source: $SRC -->"
    echo "<!-- zh-base: $BASE -->"
    echo
    cat "$DST.tmp"
  } > "$DST"
  rm -f "$DST.tmp"

  echo "已生成: ${DST#"$ROOT"/}"
done

echo
echo "⚠️  以上为 AI 初翻，请人工审校后再提交。"
