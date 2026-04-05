#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  超星團隊 — 自動更新                     ║
# ║  已安裝的使用者跑這個就好                ║
# ╚══════════════════════════════════════════╝

set -e

CLAUDE_DIR="$HOME/.claude"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "⭐ 超星團隊更新程式"
echo "════════════════════"
echo ""

# ═══════════════════════════════════
# 找到 repo 位置
# ═══════════════════════════════════

# 方法 1：從記錄檔讀取
if [ -f "$CLAUDE_DIR/.superstar-repo-path" ]; then
  REPO_DIR=$(cat "$CLAUDE_DIR/.superstar-repo-path")
fi

# 方法 2：如果在 repo 目錄內直接跑
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  REPO_DIR="$SCRIPT_DIR"
fi

if [ -z "$REPO_DIR" ] || [ ! -d "$REPO_DIR" ]; then
  echo -e "${RED}❌ 找不到 superstar-team repo。${NC}"
  echo "   請 cd 到 repo 目錄後重跑，或重新 clone："
  echo "   git clone https://github.com/XingCEO/superstar-team.git"
  echo "   cd superstar-team && ./install.sh"
  exit 1
fi

cd "$REPO_DIR"

# ═══════════════════════════════════
# 取得版本資訊
# ═══════════════════════════════════

LOCAL_VERSION="(未安裝)"
if [ -f "$CLAUDE_DIR/.superstar-version" ]; then
  LOCAL_VERSION=$(cat "$CLAUDE_DIR/.superstar-version")
fi

echo -e "  本地版本：${YELLOW}${LOCAL_VERSION}${NC}"

# ═══════════════════════════════════
# Git pull 取得最新版
# ═══════════════════════════════════

echo ""
echo "拉取最新版本..."
git pull origin main 2>&1 | head -5

REMOTE_VERSION=$(cat "$REPO_DIR/VERSION")
echo -e "  最新版本：${GREEN}${REMOTE_VERSION}${NC}"

if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
  echo ""
  echo -e "${GREEN}✓ 已經是最新版本。${NC}"

  # 即使版本相同，也確保 symlink 正確
  NEED_RELINK=false
  for agent in architect backend frontend tester security; do
    target="$CLAUDE_DIR/agents/$agent.md"
    if [ ! -L "$target" ]; then
      NEED_RELINK=true
      break
    fi
  done
  for cmd in team duo status; do
    target="$CLAUDE_DIR/commands/$cmd.md"
    if [ ! -L "$target" ]; then
      NEED_RELINK=true
      break
    fi
  done

  if [ "$NEED_RELINK" = true ]; then
    echo -e "${YELLOW}  偵測到舊式安裝（複製模式），升級為 symlink 模式...${NC}"
  else
    echo ""
    exit 0
  fi
fi

echo ""

# ═══════════════════════════════════
# 升級 Agents → symlink
# ═══════════════════════════════════

echo "更新 Agents..."
for agent in architect backend frontend tester security; do
  target="$CLAUDE_DIR/agents/$agent.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.bak"
    echo -e "  ${YELLOW}⚠${NC}  備份 $agent.md → $agent.md.bak"
  fi
  ln -sf "$REPO_DIR/agents/$agent.md" "$target"
done
echo -e "${GREEN}✓${NC} Agents 更新完成（symlink 模式）"

# ═══════════════════════════════════
# 升級 Commands → symlink
# ═══════════════════════════════════

echo "更新 Commands..."
for cmd in team duo status; do
  target="$CLAUDE_DIR/commands/$cmd.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.md.bak"
    echo -e "  ${YELLOW}⚠${NC}  備份 $cmd.md → $cmd.md.bak"
  fi
  ln -sf "$REPO_DIR/commands/$cmd.md" "$target"
done
echo -e "${GREEN}✓${NC} Commands 更新完成（symlink 模式）"

# ═══════════════════════════════════
# 更新 Skills（git pull 各 repo）
# ═══════════════════════════════════

echo "更新 Skills..."
echo -e "  ${YELLOW}⚠${NC}  Skills 由 install.sh 鎖定到特定 commit hash，不做 git pull"
echo -e "  ${YELLOW}⚠${NC}  如需更新 skills：刪除 ~/.claude/skills/<dir> 後重跑 install.sh"
echo -e "  ${GREEN}✓${NC} Skills 版本鎖定完整（不更新以避免破壞鎖定）"

# ═══════════════════════════════════
# 寫入版本號和 repo 路徑
# ═══════════════════════════════════

echo "$REMOTE_VERSION" > "$CLAUDE_DIR/.superstar-version"
echo "$REPO_DIR" > "$CLAUDE_DIR/.superstar-repo-path"

# ═══════════════════════════════════
# 完成
# ═══════════════════════════════════

echo ""
echo "════════════════════════════════════"
echo -e "  ${GREEN}⭐ 更新完成 v${LOCAL_VERSION} → v${REMOTE_VERSION}${NC}"
echo "════════════════════════════════════"
echo ""
echo "  所有 agents 和 commands 現在是 symlink 模式。"
echo "  之後只要 git pull 就會自動生效，不用再跑 update.sh。"
echo ""
