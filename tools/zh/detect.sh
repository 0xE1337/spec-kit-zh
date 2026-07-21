#!/usr/bin/env bash
# 只读检测：定时任务用。fetch 官方 → 检测过期/新增翻译文件 → 开/更新一个「待翻清单」issue。
# 不合并、不翻译、不改仓库、不碰 claude。翻译由人工触发（B 档：半自动）。
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/yijingguo/.local/bin:/Users/yijingguo/.nvm/versions/node/v24.10.0/bin:$PATH"

REPO="/Users/yijingguo/code/spec-kit-zh"
SLUG="0xE1337/spec-kit-zh"
cd "$REPO"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

git fetch upstream --quiet --tags
AHEAD="$(git rev-list --count HEAD..upstream/main)"
if [[ "$AHEAD" == "0" ]]; then
  log "已是最新，无官方更新"; exit 0
fi
NEWTAG="$(git tag --sort=-creatordate | grep -E '^v[0-9]' | head -1)"

# 过期译文（check-stale 对比 upstream/main，只读，无需合并）
STALE=()
while IFS= read -r line; do
  f="$(echo "$line" | sed -n 's/^🔴 过期: \.\/\(.*\.zh\.md\) .*/\1/p')"
  [[ -n "$f" ]] && STALE+=("${f%.zh.md}.md")
done < <(./tools/zh/check-stale.sh --fetch 2>/dev/null || true)

# 新增未译：upstream/main 里范围内、本地却没有对应 .zh.md 的 .md
NEW=()
while IFS= read -r f; do
  case "$f" in *.zh.md) continue;; esac
  [[ -f "${f%.md}.zh.md" ]] || NEW+=("$f")
done < <(git ls-tree -r --name-only upstream/main -- docs templates extensions presets spec-driven.md 2>/dev/null | grep '\.md$' || true)

if [[ ${#STALE[@]} -eq 0 && ${#NEW[@]} -eq 0 ]]; then
  log "官方领先 $AHEAD commit，但未触及翻译范围（仅 src/tests 等）。无需通知。"; exit 0
fi

log "检测到待翻：过期 ${#STALE[@]}、新增 ${#NEW[@]}（官方 $NEWTAG）"

STALE_LIST="$( [[ ${#STALE[@]} -eq 0 ]] && echo "（无）" || printf -- '- [ ] %s\n' "${STALE[@]}" )"
NEW_LIST="$( [[ ${#NEW[@]} -eq 0 ]] && echo "（无）" || printf -- '- [ ] %s\n' "${NEW[@]}" )"
BODY="$(cat <<EOF
官方 spec-kit 已更新到 **$NEWTAG**（领先 $AHEAD 个 commit）。以下文件待翻译/更新，翻完即与官方对齐。

## 过期待更新（${#STALE[@]}）
$STALE_LIST

## 新增待翻译（${#NEW[@]}）
$NEW_LIST

---
处理方式：在 Claude Code 会话里说一句「同步官方更新」，即按术语表翻译并合并。
🤖 由 tools/zh/detect.sh 每周自动检测生成（本 issue 会随后续更新原地刷新）。
EOF
)"

# 复用同一个「待翻清单」issue：存在就原地刷新，不存在才新建，避免每周刷屏
NUM="$(gh issue list -R "$SLUG" --state open --search '待翻清单 in:title' --json number --jq '.[0].number' 2>/dev/null || true)"
if [[ -n "$NUM" ]]; then
  gh issue edit "$NUM" -R "$SLUG" --title "待翻清单：官方更新到 $NEWTAG（${#STALE[@]} 过期 / ${#NEW[@]} 新增）" --body "$BODY" >/dev/null 2>&1 || true
  log "已刷新待翻清单 issue #$NUM"
else
  gh issue create -R "$SLUG" --title "待翻清单：官方更新到 $NEWTAG（${#STALE[@]} 过期 / ${#NEW[@]} 新增）" --body "$BODY" >/dev/null 2>&1 || true
  log "已新建待翻清单 issue"
fi
