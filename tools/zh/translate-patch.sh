#!/usr/bin/env bash
# 增量更新一个过期译文：只把源文件的 diff 反映到已存在的 .zh.md，保留其余已定稿内容。
# 用法: tools/zh/translate-patch.sh docs/reference/foo.md
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
GLOSSARY="$ROOT/GLOSSARY.zh.md"
SRC="${1#./}"
DST="$ROOT/${SRC%.md}.zh.md"

[[ -f "$ROOT/$SRC" ]] || { echo "找不到源文件: $SRC" >&2; exit 1; }
[[ -f "$DST" ]] || { echo "译文不存在，应改用 translate.sh 全量翻译: $SRC" >&2; exit 1; }

OLD="$(sed -n 's/^<!-- zh-base: \([0-9a-f]*\) -->$/\1/p' "$DST" | head -1)"
NEW="$(git -C "$ROOT" log -1 --format=%h -- "$SRC")"
[[ -n "$OLD" ]] || { echo "译文缺 zh-base 头: $DST" >&2; exit 1; }

DIFF="$(git -C "$ROOT" diff "$OLD..$NEW" -- "$SRC")"
if [[ -z "$DIFF" ]]; then
  # 无实质改动（如合并 commit 哈希变化），仅校正基准
  sed -i '' "s/^<!-- zh-base: .* -->$/<!-- zh-base: $NEW -->/" "$DST"
  echo "仅校正基准: ${DST#"$ROOT"/} ($OLD → $NEW)"
  exit 0
fi

claude -p "$(cat <<EOF
你在增量更新 spec-kit 官方文档的中文译文。下面给你：术语表、源文件的 git diff、以及当前的完整中文译文。

任务：只把 diff 里的改动对应地反映到中文译文——新增段落译出、删除段落删掉、修改段落更新译文，其余内容一字不动。把头部 <!-- zh-base: $OLD --> 改成 <!-- zh-base: $NEW -->。

严格遵守术语表；程序占位符/机器标记/CLI 输出保留英文；代码块命令不翻、注释翻译。只输出更新后的完整中文译文，不要任何解释或代码围栏包裹。

===== 术语表 =====
$(cat "$GLOSSARY")

===== 源文件 diff（$SRC, $OLD..$NEW）=====
$DIFF

===== 当前中文译文（$DST）=====
$(cat "$DST")
EOF
)" > "$DST.tmp"

# 校验 claude 输出：非空且仍含 zh-source 头，否则视为失败，保留原译文不动
if [[ ! -s "$DST.tmp" ]] || ! grep -q '^<!-- zh-source:' "$DST.tmp"; then
  rm -f "$DST.tmp"
  echo "claude 输出无效（空或缺 zh-source 头），已保留原译文: $SRC" >&2
  exit 1
fi
mv "$DST.tmp" "$DST"
echo "已增量更新: ${DST#"$ROOT"/} ($OLD → $NEW)"
