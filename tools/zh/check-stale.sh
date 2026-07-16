#!/usr/bin/env bash
# 检查哪些 .zh.md 译文落后于上游英文原文
# 用法: tools/zh/check-stale.sh [--fetch]
#   --fetch  先执行 git fetch upstream 再比对
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

if [[ "${1:-}" == "--fetch" ]]; then
  git fetch upstream --quiet
fi

REF="upstream/main"
if ! git rev-parse -q --verify "$REF" >/dev/null 2>&1; then
  REF="HEAD"
fi

stale=0
fresh=0
unknown=0

while IFS= read -r zh; do
  src="${zh%.zh.md}.md"
  # 没有对应英文原文的 .zh.md 是本项目自有文件（如 GLOSSARY.zh.md），不参与比对
  if ! git cat-file -e "$REF:${src#./}" 2>/dev/null; then
    continue
  fi
  base="$(sed -n 's/^<!-- zh-base: \([0-9a-f]*\) -->$/\1/p' "$zh" | head -1)"

  if [[ -z "$base" ]]; then
    echo "⚠️  无基准记录: $zh"
    unknown=$((unknown + 1))
    continue
  fi

  cur="$(git log -1 --format=%h "$REF" -- "$src")"
  # 短哈希长度可能不一致，双向前缀比较
  if [[ "$cur" == "$base"* || "$base" == "$cur"* ]]; then
    fresh=$((fresh + 1))
  else
    n="$(git rev-list --count "$base..$REF" -- "$src" 2>/dev/null || echo '?')"
    echo "🔴 过期: $zh  ($base → $cur, 原文有 $n 次新改动)"
    stale=$((stale + 1))
  fi
done < <(find . -name '*.zh.md' -not -path './.git/*' | sort)

echo
echo "共 $((stale + fresh + unknown)) 个译文: $fresh 最新 / $stale 过期 / $unknown 无基准"
[[ $stale -eq 0 ]]
