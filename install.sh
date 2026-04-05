#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  超星團隊 Superstar Team — 一鍵安裝      ║
# ║  Opus 架構師 + 4 Agent 全自動開發流水線   ║
# ╚══════════════════════════════════════════╝

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(cat "$SCRIPT_DIR/VERSION")
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "⭐ 超星團隊安裝程式 v${VERSION}"
echo "════════════════════"
echo ""

# 檢查 Claude Code
if ! command -v claude &> /dev/null; then
  echo -e "${RED}❌ 找不到 Claude Code CLI。先安裝：${NC}"
  echo "   npm install -g @anthropic-ai/claude-code"
  exit 1
fi

echo -e "${GREEN}✓${NC} Claude Code 已安裝"

# 檢查 gstack/xtools（可選，但強烈建議）
if [ -d "$CLAUDE_DIR/skills/xtools" ] || [ -d "$CLAUDE_DIR/skills/gstack" ]; then
  echo -e "${GREEN}✓${NC} gstack 已安裝（設計/QA/交付 skills 可用）"
else
  echo -e "${YELLOW}⚠${NC}  gstack 未安裝"
  echo ""
  echo "  Superstar Team 的核心編排（agents + worktree + API 契約）可獨立運作。"
  echo "  但以下功能需要 gstack 才能啟用："
  echo "    - Phase 2 設計流水線（design-consultation、design-shotgun）"
  echo "    - Phase 4.5 設計驗證（design-review）"
  echo "    - Phase 6 品質閘門（review、cso、qa、codex、health、benchmark）"
  echo "    - Phase 7 交付（ship、document-release、canary）"
  echo ""
  echo "  沒有 gstack 時，這些步驟會自動跳過，不影響基本開發流程。"
  echo ""
  echo "  安裝 gstack（推薦）："
  echo "    git clone https://github.com/garrytan/gstack.git ~/.claude/skills/gstack"
  echo "    cd ~/.claude/skills/gstack && ./setup"
  echo ""
  if [ -t 0 ]; then
    # Interactive terminal — ask user
    read -r -p "  要繼續安裝 Superstar Team 嗎？(Y/n) " answer
    if [[ "$answer" =~ ^[Nn] ]]; then
      echo "已取消。請先安裝 gstack 再重跑 install.sh。"
      exit 0
    fi
  else
    # Non-interactive (CI, pipe) — continue silently
    echo -e "  ${YELLOW}⚠${NC}  非互動模式，自動繼續安裝"
  fi
fi

# 建立目錄
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/knowledge/patterns"
mkdir -p "$CLAUDE_DIR/knowledge/training"

echo -e "${GREEN}✓${NC} 目錄建立完成"

# ═══════════════════════════════════
# 記錄 repo 位置（供 update.sh 使用）
# ═══════════════════════════════════

echo "$SCRIPT_DIR" > "$CLAUDE_DIR/.superstar-repo-path"

# ═══════════════════════════════════
# Agents（symlink 到 repo，git pull 即更新）
# ═══════════════════════════════════

for agent in architect backend frontend tester security; do
  # 如果已有舊的非 symlink 檔案，備份後替換
  target="$CLAUDE_DIR/agents/$agent.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.bak"
    echo -e "  ${YELLOW}⚠${NC}  備份舊版 $agent.md → $agent.md.bak"
  fi
  ln -sf "$SCRIPT_DIR/agents/$agent.md" "$target"
done

echo -e "${GREEN}✓${NC} 5 個 Agents 安裝完成（全 Opus，symlink 模式）"

# ═══════════════════════════════════
# Commands（symlink 到 repo，git pull 即更新）
# ═══════════════════════════════════

for cmd in team duo status; do
  target="$CLAUDE_DIR/commands/$cmd.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.bak"
    echo -e "  ${YELLOW}⚠${NC}  備份舊版 $cmd.md → $cmd.md.bak"
  fi
  ln -sf "$SCRIPT_DIR/commands/$cmd.md" "$target"
done

echo -e "${GREEN}✓${NC} 3 個 Commands 安裝完成（/team /duo /status，symlink 模式）"

# ═══════════════════════════════════
# Skills（從 GitHub clone）
# ═══════════════════════════════════

echo ""
echo -e "${YELLOW}安裝 Skills...${NC}"

clone_skill() {
  local repo=$1
  local dir=$2
  local pin=$3  # commit hash to pin (optional)
  if [ ! -d "$CLAUDE_DIR/skills/$dir" ]; then
    git clone --depth 50 "https://github.com/$repo.git" "$CLAUDE_DIR/skills/$dir" 2>/dev/null
    if [ -n "$pin" ]; then
      (cd "$CLAUDE_DIR/skills/$dir" && git checkout "$pin" --quiet 2>/dev/null)
    fi
    echo -e "  ${GREEN}✓${NC} $repo${pin:+ @ ${pin:0:7}}"
  else
    echo -e "  ⏭️  $dir（已存在）"
  fi
}

# ═══════════════════════════════════
# Skill 版本鎖定（最後驗證日：2026-04-05）
# 更新方式：改 hash 後重跑 install.sh（需先刪 ~/.claude/skills/<dir>）
# ═══════════════════════════════════

# obra — Git 工作流
clone_skill "obra/superpowers" "obra-superpowers" "b7a8f76"
for s in using-git-worktrees finishing-a-development-branch verification-before-completion dispatching-parallel-agents; do
  ln -sf "$CLAUDE_DIR/skills/obra-superpowers/skills/$s" "$CLAUDE_DIR/skills/$s" 2>/dev/null
done

# PlanetScale — 資料庫
clone_skill "planetscale/database-skills" "planetscale-db" "b156f4c"
for s in mysql postgres; do
  ln -sf "$CLAUDE_DIR/skills/planetscale-db/skills/$s" "$CLAUDE_DIR/skills/planetscale-$s" 2>/dev/null
done

# Addy Osmani — Web 品質
clone_skill "addyosmani/web-quality-skills" "addy-web-quality" "fed9617"
for s in accessibility best-practices core-web-vitals performance seo web-quality-audit; do
  ln -sf "$CLAUDE_DIR/skills/addy-web-quality/skills/$s" "$CLAUDE_DIR/skills/addy-$s" 2>/dev/null
done

# Trail of Bits — 安全
clone_skill "trailofbits/skills" "trailofbits-security" "d7f76b5"
for s in supply-chain-risk-auditor differential-review insecure-defaults modern-python second-opinion; do
  ln -sf "$CLAUDE_DIR/skills/trailofbits-security/plugins/$s/skills/$s" "$CLAUDE_DIR/skills/tob-$s" 2>/dev/null
done

# Compound Engineering — 學習迴圈
clone_skill "EveryInc/compound-engineering-plugin" "compound-engineering" "b223e39"
for s in ce-compound ce-ideate ce-plan ce-review ce-work; do
  ln -sf "$CLAUDE_DIR/skills/compound-engineering/plugins/compound-engineering/skills/$s" "$CLAUDE_DIR/skills/$s" 2>/dev/null
done

# Excalidraw — 架構圖
clone_skill "coleam00/excalidraw-diagram-skill" "excalidraw-diagram" "8646fcc"

# Vercel — UI 審計
clone_skill "vercel-labs/agent-skills" "vercel-skills" "73140fc"
ln -sf "$CLAUDE_DIR/skills/vercel-skills/skills/web-design-guidelines" "$CLAUDE_DIR/skills/vercel-web-design" 2>/dev/null

echo -e "${GREEN}✓${NC} Skills 安裝完成"

# ═══════════════════════════════════
# Hooks
# ═══════════════════════════════════

cat > "$CLAUDE_DIR/hooks/filter-output.sh" << 'HOOK'
#!/bin/bash
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null)
if [ -z "$cmd" ] || [ "$cmd" = "null" ]; then
  echo '{}'
  exit 0
fi
if [[ "$cmd" =~ ^(npm\ test|npx\ jest|pytest|python\ -m\ pytest|go\ test|cargo\ test|bun\ test|vitest|mocha) ]]; then
  filtered_cmd="$cmd 2>&1 | tail -50"
  jq -n --arg cmd "$filtered_cmd" '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":$cmd}}}'
elif [[ "$cmd" =~ ^(npm\ run\ build|npx\ tsc|cargo\ build|go\ build|make) ]]; then
  filtered_cmd="$cmd 2>&1 | grep -A 3 -E '(error|Error|ERROR|FAIL|failed)' | head -50"
  jq -n --arg cmd "$filtered_cmd" '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":$cmd}}}'
else
  echo '{}'
fi
HOOK
chmod +x "$CLAUDE_DIR/hooks/filter-output.sh"

# Guardrail hook — programmatic file + package enforcement
cat > "$CLAUDE_DIR/hooks/guardrail.sh" << 'HOOK'
#!/bin/bash
# PreToolUse hook: hard-block file writes beyond 20, package installs beyond 10
input=$(cat)
tool=$(echo "$input" | jq -r '.tool_name' 2>/dev/null)
# Session ID: extract from hook's stdin JSON (most reliable),
# fallback to grandparent PID if JSON doesn't have it
SESSION_ID=$(echo "$input" | jq -r '.session_id // empty' 2>/dev/null)
if [ -z "$SESSION_ID" ]; then
  SESSION_ID=$(ps -o ppid= -p "${PPID:-$$}" 2>/dev/null | tr -d ' ')
  [ -z "$SESSION_ID" ] && SESSION_ID="${PPID:-$$}"
fi

# --- File count guardrail (Write/Edit) ---
if [ "$tool" = "Write" ] || [ "$tool" = "Edit" ]; then
  COUNTER="/tmp/superstar-file-${SESSION_ID}"
  count=0
  [ -f "$COUNTER" ] && count=$(cat "$COUNTER")
  count=$((count + 1))
  echo "$count" > "$COUNTER"

  if [ "$count" -gt 20 ]; then
    jq -n '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","reason":"BLOCKED: 20-file limit reached. Stop and report to Lead."}}'
    exit 0
  elif [ "$count" -ge 16 ]; then
    jq -n --arg msg "WARNING: $count/20 files modified. Approaching hard limit." \
      '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","message":$msg}}'
    exit 0
  fi
fi

# --- Package install guardrail (Bash) ---
if [ "$tool" = "Bash" ]; then
  cmd=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null)
  if echo "$cmd" | grep -qE '^(npm install|npm i |yarn add|pnpm add|pip install|pip3 install|cargo add|bun add)'; then
    COUNTER="/tmp/superstar-pkg-${SESSION_ID}"
    count=0
    [ -f "$COUNTER" ] && count=$(cat "$COUNTER")
    count=$((count + 1))
    echo "$count" > "$COUNTER"

    if [ "$count" -gt 10 ]; then
      jq -n '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","reason":"BLOCKED: 10-package limit reached. Stop and report to Lead."}}'
      exit 0
    elif [ "$count" -ge 8 ]; then
      jq -n --arg msg "WARNING: $count/10 packages installed. Approaching hard limit." \
        '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","message":$msg}}'
      exit 0
    fi
  fi
fi

echo '{}'
HOOK
chmod +x "$CLAUDE_DIR/hooks/guardrail.sh"

echo -e "${GREEN}✓${NC} Hooks 安裝完成（output filter + guardrail）"

# ═══════════════════════════════════
# Settings（不覆蓋現有）
# ═══════════════════════════════════

if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
  cat > "$CLAUDE_DIR/settings.json" << 'SETTINGS'
{
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "70"
  },
  "model": "opus[1m]",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/filter-output.sh"
          },
          {
            "type": "command",
            "command": "~/.claude/hooks/guardrail.sh"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/guardrail.sh"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/guardrail.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS
  echo -e "${GREEN}✓${NC} settings.json 建立完成"
else
  echo -e "${YELLOW}⏭️${NC}  settings.json 已存在，跳過（不覆蓋）"
fi

# ═══════════════════════════════════
# 版本紀錄
# ═══════════════════════════════════

echo "$VERSION" > "$CLAUDE_DIR/.superstar-version"

# ═══════════════════════════════════
# 完成
# ═══════════════════════════════════

SKILL_COUNT=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -mindepth 1 \( -type d -o -type l \) 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "════════════════════════════════════"
echo -e "  ${GREEN}⭐ 超星團隊安裝完成 v${VERSION}${NC}"
echo "════════════════════════════════════"
echo ""
echo "  🤖 Agents:   5 個（全 Opus）"
echo "  ⚡ Skills:   $SKILL_COUNT 個"
echo "  🎯 Commands: /team  /duo  /status"
echo "  🔧 Hooks:    測試輸出過濾（省 token）"
echo "  🧠 知識庫:   ~/.claude/knowledge/"
echo "  🔗 模式:     symlink（git pull 即更新）"
echo ""
echo "  開始使用："
echo "    claude                 # 開啟 Claude Code"
echo "    /team                  # 啟動超星團隊"
echo "    /status                # 查看狀態"
echo ""
echo "  更新："
echo "    cd $(basename "$SCRIPT_DIR") && git pull"
echo "    # 或"
echo "    ./update.sh"
echo ""
