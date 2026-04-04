#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  超星團隊 Superstar Team — 一鍵安裝      ║
# ║  Opus 架構師 + 4 Agent 全自動開發流水線   ║
# ╚══════════════════════════════════════════╝

set -e

CLAUDE_DIR="$HOME/.claude"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "⭐ 超星團隊安裝程式"
echo "════════════════════"
echo ""

# 檢查 Claude Code
if ! command -v claude &> /dev/null; then
  echo "❌ 找不到 Claude Code CLI。先安裝："
  echo "   npm install -g @anthropic-ai/claude-code"
  exit 1
fi

echo -e "${GREEN}✓${NC} Claude Code 已安裝"

# 建立目錄
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/knowledge/patterns"
mkdir -p "$CLAUDE_DIR/knowledge/training"

echo -e "${GREEN}✓${NC} 目錄建立完成"

# ═══════════════════════════════════
# Agents
# ═══════════════════════════════════

cat > "$CLAUDE_DIR/agents/architect.md" << 'AGENT'
---
description: "系統架構師。負責目錄結構、模組切分、API 設計、資料模型規劃。在團隊中最先啟動，產出規格後其他人才能開工。"
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
  - Edit
model: opus
---

你是資深系統架構師。你的工作是設計系統架構，不寫實作程式碼。

## 產出格式
產出一份 `docs/architecture.md`，包含：
1. 目錄結構
2. 模組切分和職責
3. API 設計
4. 資料模型
5. 共享介面
6. 檔案所有權

## 規則
- 先讀完現有 codebase 再設計
- 用繁體中文撰寫

## 安全限制
- 連續 3 次嘗試同一件事都失敗 → 立刻停止回報
- 不確定就停下來回報

## 回報格式（強制）
回報時只包含：完成了什麼、新增/修改的檔案清單、遇到的問題
AGENT

cat > "$CLAUDE_DIR/agents/backend.md" << 'AGENT'
---
description: "後端工程師。負責 API routes、資料庫 schema、業務邏輯、middleware。"
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
  - Edit
model: opus
---

你是資深後端工程師。

## 規則
- 開工前先讀 `docs/architecture.md`
- 只修改架構師指定給你的目錄
- commit 格式：feat(api): description

## 安全限制
- 連續 3 次嘗試同一件事都失敗 → 立刻停止回報
- 不要安裝超過 10 個新套件，超過先回報
- 不要修改超過 20 個檔案，超過先回報
- 不要刪除任何現有檔案

## 回報格式（強制）
回報時只包含：完成了什麼、檔案清單、測試結果、問題
AGENT

cat > "$CLAUDE_DIR/agents/frontend.md" << 'AGENT'
---
description: "前端工程師。負責 UI 元件、頁面 layout、狀態管理、API 串接。"
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
  - Edit
model: opus
---

你是資深前端工程師。

## 規則
- 開工前先讀 `docs/architecture.md`
- 只修改架構師指定給你的目錄
- commit 格式：feat(ui): description

## 安全限制
- 連續 3 次嘗試同一件事都失敗 → 立刻停止回報
- 不要安裝超過 10 個新套件，超過先回報
- 不要修改超過 20 個檔案，超過先回報
- 不要刪除任何現有檔案

## 回報格式（強制）
回報時只包含：完成了什麼、檔案清單、測試結果、問題
AGENT

cat > "$CLAUDE_DIR/agents/tester.md" << 'AGENT'
---
description: "測試工程師。負責 unit test、integration test、edge case 覆蓋。"
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
  - Edit
model: opus
---

你是資深測試工程師。

## 規則
- 開工前先讀 `docs/architecture.md` 和現有程式碼
- 每個 public function 至少一個 happy path + 一個 edge case
- commit 格式：test(scope): description

## 安全限制
- 連續 3 次嘗試同一件事都失敗 → 立刻停止回報
- 不要安裝超過 10 個新套件，超過先回報
- 不要修改超過 20 個檔案，超過先回報

## 回報格式（強制）
回報時只包含：完成了什麼、檔案清單、測試結果、問題
AGENT

cat > "$CLAUDE_DIR/agents/security.md" << 'AGENT'
---
description: "安全審查員。掃描程式碼安全漏洞，產出審查報告，不修改程式碼。"
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
model: opus
---

你是資深安全工程師。你只做審查，不寫實作程式碼。

## 審查清單
1. Injection（SQL、XSS、command injection）
2. 認證/授權缺陷
3. 敏感資料洩漏
4. 依賴安全
5. API 安全

## 產出格式
每個發現：嚴重度 + 位置 + 描述 + 修復建議

## 安全限制
- 連續 3 次嘗試同一件事都失敗 → 立刻停止回報
- 不修改任何程式碼

## 回報格式（強制）
回報時只包含：完成了什麼、檔案清單、問題
AGENT

echo -e "${GREEN}✓${NC} 5 個 Agents 安裝完成（全 Opus）"

# ═══════════════════════════════════
# Commands
# ═══════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/commands/team.md" "$CLAUDE_DIR/commands/team.md"
cp "$SCRIPT_DIR/commands/duo.md" "$CLAUDE_DIR/commands/duo.md"
cp "$SCRIPT_DIR/commands/status.md" "$CLAUDE_DIR/commands/status.md"

echo -e "${GREEN}✓${NC} 3 個 Commands 安裝完成（/team /duo /status）"

# ═══════════════════════════════════
# Skills（從 GitHub clone）
# ═══════════════════════════════════

echo ""
echo -e "${YELLOW}安裝 Skills...${NC}"

clone_skill() {
  local repo=$1
  local dir=$2
  if [ ! -d "$CLAUDE_DIR/skills/$dir" ]; then
    git clone --depth 1 "https://github.com/$repo.git" "$CLAUDE_DIR/skills/$dir" 2>/dev/null
    echo -e "  ${GREEN}✓${NC} $repo"
  else
    echo -e "  ⏭️  $dir（已存在）"
  fi
}

# obra — Git 工作流
clone_skill "obra/superpowers" "obra-superpowers"
for s in using-git-worktrees finishing-a-development-branch verification-before-completion dispatching-parallel-agents; do
  ln -sf "$CLAUDE_DIR/skills/obra-superpowers/skills/$s" "$CLAUDE_DIR/skills/$s" 2>/dev/null
done

# PlanetScale — 資料庫
clone_skill "planetscale/database-skills" "planetscale-db"
for s in mysql postgres; do
  ln -sf "$CLAUDE_DIR/skills/planetscale-db/skills/$s" "$CLAUDE_DIR/skills/planetscale-$s" 2>/dev/null
done

# Addy Osmani — Web 品質
clone_skill "addyosmani/web-quality-skills" "addy-web-quality"
for s in accessibility best-practices core-web-vitals performance seo web-quality-audit; do
  ln -sf "$CLAUDE_DIR/skills/addy-web-quality/skills/$s" "$CLAUDE_DIR/skills/addy-$s" 2>/dev/null
done

# Trail of Bits — 安全
clone_skill "trailofbits/skills" "trailofbits-security"
for s in supply-chain-risk-auditor differential-review insecure-defaults modern-python second-opinion; do
  ln -sf "$CLAUDE_DIR/skills/trailofbits-security/plugins/$s/skills/$s" "$CLAUDE_DIR/skills/tob-$s" 2>/dev/null
done

# Compound Engineering — 學習迴圈
clone_skill "EveryInc/compound-engineering-plugin" "compound-engineering"
for s in ce-compound ce-ideate ce-plan ce-review ce-work; do
  ln -sf "$CLAUDE_DIR/skills/compound-engineering/plugins/compound-engineering/skills/$s" "$CLAUDE_DIR/skills/$s" 2>/dev/null
done

# Excalidraw — 架構圖
clone_skill "coleam00/excalidraw-diagram-skill" "excalidraw-diagram"

# Vercel — UI 審計
clone_skill "vercel-labs/agent-skills" "vercel-skills"
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
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":"%s"}}}' "$filtered_cmd"
elif [[ "$cmd" =~ ^(npm\ run\ build|npx\ tsc|cargo\ build|go\ build|make) ]]; then
  filtered_cmd="$cmd 2>&1 | grep -A 3 -E '(error|Error|ERROR|FAIL|failed)' | head -50"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","updatedInput":{"command":"%s"}}}' "$filtered_cmd"
else
  echo '{}'
fi
HOOK
chmod +x "$CLAUDE_DIR/hooks/filter-output.sh"

echo -e "${GREEN}✓${NC} Hooks 安裝完成"

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
# 完成
# ═══════════════════════════════════

SKILL_COUNT=$(find "$CLAUDE_DIR/skills" -maxdepth 1 -mindepth 1 -type d -o -type l 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "════════════════════════════════════"
echo -e "  ${GREEN}⭐ 超星團隊安裝完成${NC}"
echo "════════════════════════════════════"
echo ""
echo "  🤖 Agents:   5 個（全 Opus）"
echo "  ⚡ Skills:   $SKILL_COUNT 個"
echo "  🎯 Commands: /team  /duo  /status"
echo "  🔧 Hooks:    測試輸出過濾（省 token）"
echo "  🧠 知識庫:   ~/.claude/knowledge/"
echo ""
echo "  開始使用："
echo "    claude                 # 開啟 Claude Code"
echo "    /team                  # 啟動超星團隊"
echo "    /status                # 查看狀態"
echo ""
