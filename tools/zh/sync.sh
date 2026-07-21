#!/usr/bin/env bash
# 自动同步官方 spec-kit：fetch → merge → 检测过期/新增 → AI 初翻 → 开 PR。
# 设计为 launchd/cron 无人值守运行；AI 译文进 PR 等人工审校，绝不自动合并到 main。
#
# 用法:
#   tools/zh/sync.sh          正常运行
#   tools/zh/sync.sh --dry    只检测并打印，不翻译不开 PR
set -euo pipefail

# launchd 环境 PATH 极简，显式补齐
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/yijingguo/.local/bin:/Users/yijingguo/.nvm/versions/node/v24.10.0/bin:$PATH"

REPO="/Users/yijingguo/code/spec-kit-zh"
SLUG="0xE1337/spec-kit-zh"   # 所有 gh 命令显式指向本仓库，杜绝回退到 upstream
cd "$REPO"
DRY="${1:-}"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

# 1. 前置检查：工作树必须干净，且当前在 main
if [[ -n "$(git status --porcelain)" ]]; then
  log "工作树不干净，跳过本次同步（请先处理本地改动）"; exit 0
fi
if [[ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]]; then
  log "当前不在 main 分支，跳过"; exit 0
fi

# 2. 已有未合并的同步 PR 就不再叠加开新 PR
OPEN_PR="$(gh pr list -R "$SLUG" --state open --json number,headRefName --jq '[.[]|select(.headRefName|startswith("sync/upstream-"))][0].number' 2>/dev/null || true)"
if [[ -n "$OPEN_PR" ]]; then
  log "已有未合并的同步 PR #$OPEN_PR，先合并它再说，跳过"; exit 0
fi

# 3. 拉取官方
git fetch upstream --quiet --tags
AHEAD="$(git rev-list --count HEAD..upstream/main)"
if [[ "$AHEAD" == "0" ]]; then
  log "已是最新，无官方更新"; exit 0
fi
NEWTAG="$(git tag --sort=-creatordate | grep -E '^v[0-9]' | head -1)"
log "官方领先 $AHEAD 个 commit，最新 tag: $NEWTAG"

# 4. 建同步分支并合并（并存式结构预期零冲突；冲突则中止并留痕）
BRANCH="sync/upstream-$(date +%Y%m%d-%H%M)"
git switch -c "$BRANCH" >/dev/null 2>&1
if ! git merge upstream/main --no-edit >/dev/null 2>&1; then
  git merge --abort
  git switch main >/dev/null 2>&1
  git branch -D "$BRANCH" >/dev/null 2>&1
  log "合并出现冲突（异常，应人工介入）——已中止。开一个 issue 提醒。"
  gh issue create -R "$SLUG" --title "自动同步冲突：$NEWTAG 需人工合并" \
    --body "sync.sh 在合并 upstream/main（领先 $AHEAD commit，最新 $NEWTAG）时遇到冲突，已自动中止。请手动 \`git merge upstream/main\` 处理。" \
    2>/dev/null || true
  exit 1
fi

# 5. 检测过期译文 + 范围内新增未译文件
STALE=()
while IFS= read -r line; do
  f="$(echo "$line" | sed -n 's/^🔴 过期: \.\/\(.*\.zh\.md\) .*/\1/p')"
  [[ -n "$f" ]] && STALE+=("${f%.zh.md}.md")
done < <(./tools/zh/check-stale.sh 2>/dev/null || true)

NEWFILES=()
while IFS= read -r f; do
  [[ -f "${f%.md}.zh.md" ]] || NEWFILES+=("$f")
done < <(find docs templates extensions presets -name '*.md' -not -name '*.zh.md' 2>/dev/null; [[ -f spec-driven.md ]] && echo spec-driven.md)

if [[ ${#STALE[@]} -eq 0 && ${#NEWFILES[@]} -eq 0 ]]; then
  # 官方只改了 src/tests 等范围外文件：合并本身有价值，直接快进合并回 main，无需 PR
  git switch main >/dev/null 2>&1
  git merge --ff-only "$BRANCH" >/dev/null 2>&1 && git branch -D "$BRANCH" >/dev/null 2>&1
  git push --quiet origin main 2>/dev/null || true
  log "官方更新未触及翻译范围，已直接同步 main（无需 PR）"; exit 0
fi

log "过期 ${#STALE[@]} 个，新增 ${#NEWFILES[@]} 个"
if [[ "$DRY" == "--dry" ]]; then
  printf '  过期: %s\n' "${STALE[@]:-（无）}"
  printf '  新增: %s\n' "${NEWFILES[@]:-（无）}"
  git switch main >/dev/null 2>&1; git branch -D "$BRANCH" >/dev/null 2>&1
  exit 0
fi

# 6. 逐个翻译（过期→增量补丁，新增→全量），失败不中断整体；错误输出留进日志
DONE_STALE=(); DONE_NEW=(); FAILED=()
for f in "${STALE[@]:-}"; do
  [[ -z "$f" ]] && continue
  if out="$(./tools/zh/translate-patch.sh "$f" 2>&1)"; then DONE_STALE+=("$f"); else FAILED+=("$f (patch)"); log "补丁失败 $f: $out"; fi
done
for f in "${NEWFILES[@]:-}"; do
  [[ -z "$f" ]] && continue
  if out="$(./tools/zh/translate.sh "$f" 2>&1)"; then DONE_NEW+=("${f%.md}.zh.md"); else FAILED+=("$f (new)"); log "翻译失败 $f: $out"; fi
done

# 7. 提交、推送、开 PR。若翻译全部失败（无译文改动），优雅收场并开 issue，不留悬空分支
git add -A
if git diff --cached --quiet; then
  log "所有翻译均失败，无改动可提交（失败 ${#FAILED[@]}）。切回 main、清理分支、开 issue。"
  git switch main >/dev/null 2>&1
  git branch -D "$BRANCH" >/dev/null 2>&1
  gh issue create -R "$SLUG" --title "自动同步：$NEWTAG 翻译失败需人工处理" \
    --body "sync.sh 检测到 ${#STALE[@]} 过期 / ${#NEWFILES[@]} 新增，但翻译全部失败：$(printf '%s; ' "${FAILED[@]:-}")见 tools/zh/sync.log。" \
    2>/dev/null || true
  exit 1
fi
git commit -q -m "chore(sync): 同步官方 $NEWTAG（AI 初翻，待审校）

过期修补 ${#DONE_STALE[@]} · 新增翻译 ${#DONE_NEW[@]}$( [[ ${#FAILED[@]} -gt 0 ]] && echo " · 失败 ${#FAILED[@]}" )"
git push --quiet -u origin "$BRANCH"

BODY="$(cat <<EOF
自动同步官方 spec-kit 到 **$NEWTAG**（领先 $AHEAD 个 commit）。

> ⚠️ 以下为 AI 初翻，**需人工审校后再合并**。

## 过期修补（${#DONE_STALE[@]}）
$( [[ ${#DONE_STALE[@]} -eq 0 ]] && echo "（无）" || printf -- '- %s\n' "${DONE_STALE[@]}" )

## 新增翻译（${#DONE_NEW[@]}）
$( [[ ${#DONE_NEW[@]} -eq 0 ]] && echo "（无）" || printf -- '- %s\n' "${DONE_NEW[@]}" )

$( [[ ${#FAILED[@]} -gt 0 ]] && printf '## ⚠️ 翻译失败，需手动处理（%s）\n%s\n' "${#FAILED[@]}" "$(printf -- '- %s\n' "${FAILED[@]}")" )

---
🤖 由 tools/zh/sync.sh 自动生成
EOF
)"
gh pr create -R "$SLUG" --base main --head "$BRANCH" --title "sync: 同步官方 $NEWTAG（AI 初翻待审校）" --body "$BODY" >/dev/null
git switch main >/dev/null 2>&1
log "已开同步 PR：$NEWTAG（过期 ${#DONE_STALE[@]}、新增 ${#DONE_NEW[@]}、失败 ${#FAILED[@]}）"
