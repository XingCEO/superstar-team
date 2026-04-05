#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  Superstar Team — Auto Update            ║
# ║  For existing users, just run this       ║
# ╚══════════════════════════════════════════╝

set -e

CLAUDE_DIR="$HOME/.claude"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "⭐ Superstar Team Updater"
echo "════════════════════"
echo ""

# ═══════════════════════════════════
# Locate repo
# ═══════════════════════════════════

# Method 1: Read from saved path
if [ -f "$CLAUDE_DIR/.superstar-repo-path" ]; then
  REPO_DIR=$(cat "$CLAUDE_DIR/.superstar-repo-path")
fi

# Method 2: Running directly from repo directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  REPO_DIR="$SCRIPT_DIR"
fi

if [ -z "$REPO_DIR" ] || [ ! -d "$REPO_DIR" ]; then
  echo -e "${RED}❌ Cannot find superstar-team repo.${NC}"
  echo "   cd into the repo directory and re-run, or clone again:"
  echo "   git clone https://github.com/XingCEO/superstar-team.git"
  echo "   cd superstar-team && ./install.sh"
  exit 1
fi

cd "$REPO_DIR"

# ═══════════════════════════════════
# Get version info
# ═══════════════════════════════════

LOCAL_VERSION="(not installed)"
if [ -f "$CLAUDE_DIR/.superstar-version" ]; then
  LOCAL_VERSION=$(cat "$CLAUDE_DIR/.superstar-version")
fi

echo -e "  Local version: ${YELLOW}${LOCAL_VERSION}${NC}"

# ═══════════════════════════════════
# Git pull to get latest version
# ═══════════════════════════════════

echo ""
echo "Pulling latest version..."
git pull origin main 2>&1 | head -5

REMOTE_VERSION=$(cat "$REPO_DIR/VERSION")
echo -e "  Latest version: ${GREEN}${REMOTE_VERSION}${NC}"

if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
  echo ""
  echo -e "${GREEN}✓ Already up to date.${NC}"

  # Even if version matches, ensure symlinks are correct
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
    echo -e "${YELLOW}  Detected legacy install (copy mode), upgrading to symlink mode...${NC}"
  else
    echo ""
    exit 0
  fi
fi

echo ""

# ═══════════════════════════════════
# Upgrade Agents → symlink
# ═══════════════════════════════════

echo "Updating Agents..."
for agent in architect backend frontend tester security; do
  target="$CLAUDE_DIR/agents/$agent.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.bak"
    echo -e "  ${YELLOW}⚠${NC}  Backed up $agent.md → $agent.md.bak"
  fi
  ln -sf "$REPO_DIR/agents/$agent.md" "$target"
done
echo -e "${GREEN}✓${NC} Agents updated (symlink mode)"

# ═══════════════════════════════════
# Upgrade Commands → symlink
# ═══════════════════════════════════

echo "Updating Commands..."
for cmd in team duo status; do
  target="$CLAUDE_DIR/commands/$cmd.md"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "$target.md.bak"
    echo -e "  ${YELLOW}⚠${NC}  Backed up $cmd.md → $cmd.md.bak"
  fi
  ln -sf "$REPO_DIR/commands/$cmd.md" "$target"
done
echo -e "${GREEN}✓${NC} Commands updated (symlink mode)"

# ═══════════════════════════════════
# Update Skills (git pull each repo)
# ═══════════════════════════════════

echo "Updating Skills..."
echo -e "  ${YELLOW}⚠${NC}  Skills are pinned to specific commit hashes by install.sh, skipping git pull"
echo -e "  ${YELLOW}⚠${NC}  To update skills: delete ~/.claude/skills/<dir> then re-run install.sh"
echo -e "  ${GREEN}✓${NC} Skill version pins intact (not updating to avoid breaking pins)"

# ═══════════════════════════════════
# Write version and repo path
# ═══════════════════════════════════

echo "$REMOTE_VERSION" > "$CLAUDE_DIR/.superstar-version"
echo "$REPO_DIR" > "$CLAUDE_DIR/.superstar-repo-path"

# ═══════════════════════════════════
# Done
# ═══════════════════════════════════

echo ""
echo "════════════════════════════════════"
echo -e "  ${GREEN}⭐ Update complete v${LOCAL_VERSION} → v${REMOTE_VERSION}${NC}"
echo "════════════════════════════════════"
echo ""
echo "  All agents and commands are now in symlink mode."
echo "  From now on, git pull will take effect automatically — no need to re-run update.sh."
echo ""
